Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbYFJByZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbYFJByZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 21:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYFJByP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 21:54:15 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:36167 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbYFJByO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 21:54:14 -0400
Message-Id: <6.0.0.20.2.20080610104711.00208ac0@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Tue, 10 Jun 2008 10:52:34 +0900
To: Andrew Morton <akpm@linux-foundation.org>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] VFS: Pagecache usage optimization
  onpagesize!=blocksizeenvironment
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080528162302.d2924861.akpm@linux-foundation.org>
References: <6.0.0.20.2.20080513205758.03a7a6b0@172.19.0.2>
 <20080521001930.202446eb.akpm@linux-foundation.org>
 <6.0.0.20.2.20080522160939.051ca938@172.19.0.2>
 <20080522010355.32590474.akpm@linux-foundation.org>
 <6.0.0.20.2.20080527172732.05447770@172.19.0.2>
 <20080527015135.561eeb6d.akpm@linux-foundation.org>
 <6.0.0.20.2.20080527175418.0554f348@172.19.0.2>
 <20080528162302.d2924861.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At 08:23 08/05/29, Andrew Morton wrote:
>	On Tue, 27 May 2008 18:34:02 +0900
>Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:
>
>> When we read some part of a file through pagecache, if there is a pagecache 
>> of corresponding index but this page is not uptodate, read IO is issued and
>> this page will be uptodate.
>> I think this is good for pagesize == blocksize environment but there is room
>> for improvement on pagesize != blocksize environment. Because in this case
>> a page can have multiple buffers and even if a page is not uptodate, some 
>buffers 
>> can be uptodate. So I suggest that when all buffers which correspond to a part
>> of a file that we want to read are uptodate, use this pagecache and copy data
>> from this pagecache to user buffer even if a page is not uptodate. This can
>> reduce read IO and improve system throughput.
>> 
>> v2: add new address_space_operations member is_partially_uptodate, and 
>>      block_is_partially_uptodate was registered to ext2/3/4's aops.
>>      modify do_generic_file_read to use this aops callback.
>> v3: use unsigned instead of unsigned long in block_is_partially_uptodate.
>>      cleaned up and simplified page buffer iteration code in 
>block_is_partially_uptodate.
>> 
>> Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
>
>OK, thanks, let's give it a try.
>
>It would be excellent if we had some benchmark numbers which justify
>this change.
>
>It also would be good if we can think up some workload which might be
>slowed down by the change, and then demonstrate that this is not a
>significant problem.
>
>After all, it _is_ a performance patch...

I wrote a benchmark program and got result number with this program.
This benchmark do:
	1, mount and open a test file.
	2, create a 512MB file.
	3, close a file and umount.
	4, mount and again open a test file.
	5, pwrite randomly 300000 times on a test file. offset is aligned by IO size(1024bytes).
	6, measure time of preading randomly 100000 times on a test file.

The result was:
	2.6.26-rc5
        329 sec

	2.6.25-rc5-patched
        223 sec

arch:i386 
filesystem:ext3
blocksize:1024 bytes
Memory: 1GB

The read IO throughput was improved.

The benchmark program is as follows:

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>

#define LEN 1024
#define LOOP 1024*512 /* 512MB */

main(void)
{
	unsigned long i, offset, filesize;
	int fd;
	char buf[LEN];
	time_t t1, t2;

	if (mount("/dev/sda1", "/root/test1/", "ext3", 0, 0) < 0) {
		perror("cannot mount\n");
		exit(1);
	}
	memset(buf, 0, LEN);
	fd = open("/root/test1/testfile", O_CREAT|O_RDWR|O_TRUNC);
	if (fd < 0) {
		perror("cannot open file\n");
		exit(1);
	}
	for (i = 0; i < LOOP; i++)
		write(fd, buf, LEN);
	close(fd);
	if (umount("/root/test1/") < 0) {
		perror("cannot umount\n");
		exit(1);
	}
	if (mount("/dev/sda1", "/root/test1/", "ext3", 0, 0) < 0) {
		perror("cannot mount\n");
		exit(1);
	}
	fd = open("/root/test1/testfile", O_RDWR);
	if (fd < 0) {
		perror("cannot open file\n");
		exit(1);
	}

	filesize = LEN * LOOP;
	for (i = 0; i < 300000; i++){
		offset = (random() % filesize) & (~(LEN - 1));
		pwrite(fd, buf, LEN, offset);
	}
	printf("start test\n");
	time(&t1);
	for (i = 0; i < 100000; i++){
		offset = (random() % filesize) & (~(LEN - 1));
		pread(fd, buf, LEN, offset);
	}
	time(&t2);
	printf("%ld sec\n", t2-t1);
	close(fd);
	if (umount("/root/test1/") < 0) {
		perror("cannot umount\n");
		exit(1);
	}
}


