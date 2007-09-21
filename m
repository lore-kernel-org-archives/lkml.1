Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbXIUJOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbXIUJOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXIUJOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:14:07 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:1928 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbXIUJOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:14:06 -0400
From: Vitaliy Gusev <vgusev@sw.ru>
Organization: SWsoft
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Problem: LTP linkat01 test fails on nfs directory (NFS v3)
Date: Fri, 21 Sep 2007 13:13:00 +0400
User-Agent: KMail/1.9.5
References: <46F1541B.2040800@sw.ru>
In-Reply-To: <46F1541B.2040800@sw.ru>
MIME-Version: 1.0
Message-Id: <200709211313.01040.vgusev@sw.ru>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ds48GI8lZ/6FPbJ"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_ds48GI8lZ/6FPbJ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello.

Tested kernels: 2.6.18, 2.6.22, 2.6.23-rc2

Steps to reproduce: Suppose that we have mounted some directory from nfs v3 
server with default options. Also we  have the two directories in this 
mountpoint and each directory has hard linked file. Try to open those files 
and write to one and read from another. Data will not be equal. (Testcase: 
attached hardlink_test.c)

Analysis: Although these hard linked files have same nfs_fattr::fileid but 
have different nfs_fh fhandle. In this case nfs_find_actor() function 
(fs/nfs/inode.c) returns false during opening each file:

nfs_find_actor()
{
...
	if (nfs_compare_fh(NFS_FH(inode), fh))
		return 0;
...
}

Therefore for each of hard links new struct inode is allocated. It leads to 
cache aliasing.

Please explain why nfs_find_actor() function compares file handles?

-- 
Thanks,
Vitaliy Gusev


--Boundary-00=_ds48GI8lZ/6FPbJ
Content-Type: text/x-csrc;
  charset="utf-8";
  name="hardlink_test.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
	filename="hardlink_test.c"

#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <err.h>

#define SLEEP 15

int main(int argc, char *argv[])
{
	int fd1,fd2;
	char *f1 = argv[1];
	char *f2 = argv[2];
	char buf[1000]= {0,};
	char wrbuf[200];
	int ret;

	assert(argc == 3);

	printf("write to: %s\nread from: %s\n\n",
	       f1, f2);

	fd1 = open(f1, O_RDWR);
	fd2 = open(f2, O_RDONLY);
	if (fd1 < 0 || fd2 < 0)
		err(1, "error open");
		
	sprintf(wrbuf, "test message-%d", getpid());
	printf("Write: [%s]\n", wrbuf);
	ret = write(fd1, wrbuf, strlen(wrbuf));
	if (ret < 0)
		err(1, "error write");

	sleep(1);
	ret = read(fd2, buf, sizeof(buf) - 1);
	if (ret < 0)
		err(1, "error read");
	printf("Read:  [%s]\n", buf);
	return 0;
}

--Boundary-00=_ds48GI8lZ/6FPbJ--
