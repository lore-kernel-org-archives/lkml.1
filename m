Return-Path: <linux-kernel-owner+w=401wt.eu-S1751382AbXBRQKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbXBRQKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 11:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXBRQKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 11:10:32 -0500
Received: from mail.parknet.jp ([210.171.160.80]:1341 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbXBRQKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 11:10:31 -0500
X-AuthUser: hirofumi@parknet.jp
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20 kernel hang with USB drive and vfat doing ftruncate
References: <6EF4DB85-C7D4-445B-B9B5-0D22D5D893CD@kernel.crashing.org>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 19 Feb 2007 01:10:05 +0900
In-Reply-To: <6EF4DB85-C7D4-445B-B9B5-0D22D5D893CD@kernel.crashing.org> (Kumar Gala's message of "Fri\, 16 Feb 2007 13\:54\:20 -0600")
Message-ID: <87vehzqwf6.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala <galak@kernel.crashing.org> writes:

> I'm seeing an issue with a stock 2.6.20 kernel running on an embedded  
> PPC.  I've got a usb flash drive plugged in and the filesystem on the  
> drive is vfat.  Running with 64M and no swap.
>
> If I execute a series of large (100M+) ftruncate() on the disk the  
> kernel will hang and never return.  It seems to be stuck in the idle  
> loop().
>
> The following is the test program I'm running:
>
> #include <sys/mman.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <unistd.h>
> #include <errno.h>
>
> void usage (void)
> {
>          printf ("truncate_test <filename> <size>\n\n");
> }
>
> int main(int argc, char *argv[])
> {
>          int fd, i;
>          int ret = 0;
>          unsigned int len;
>
>          if (argc != 3) {
>                  printf("Invalid number of arguments\n\n");
>                  usage();
>                  exit(1);
>          }
>
>          fd = open(argv[1], O_CREAT|O_RDWR|O_TRUNC, S_IRWXU);
>          len = strtoul(argv[2], NULL, 0);
>
>          ret = ftruncate(fd, len);
>
>          if (ret)
>                  printf ("ftruncate ret = %d %d\n", ret, errno);
>
>          close(fd);
>
>          return ret;
> }
>
> I usually run the following twice to get the hang state:
>
> time ./trunc_test bar 100000000 &
> time ./trunc_test baz 100000000 &
>
> I was wondering if anyone had any suggestions on what to poke at next  
> to try and figure out what is going on.

Can you check /sys/block/xxx/stat or something to make sure there is
no outstanding IO request?

It seems to be no response from the lower layer...
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
