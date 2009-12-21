Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbZLUHb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbZLUHb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 02:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZLUHbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 02:31:55 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:37726 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbZLUHby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 02:31:54 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Eric Blake <ebb9@byu.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net>
Date: Mon, 21 Dec 2009 16:31:49 +0900
In-Reply-To: <4B2B156D.9040604@byu.net> (Eric Blake's message of "Thu, 17 Dec
	2009 22:38:53 -0700")
Message-ID: <87aaxclr4q.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Blake <ebb9@byu.net> writes:

> POSIX requires that utimensat/futimens must update ctime in all cases
> where any change is made (it only exempts when both atime and mtime were
> requested as UTIME_OMIT, where the file must exist but no change is made).
>  Unfortunately, when atime is specified and mtime is UTIME_OMIT, the
> kernel mistakenly behaves like read(), by updating atime but not ctime.
> This in turn caused a regression in coreutils 8.2, visible through 'touch -a':
> http://lists.gnu.org/archive/html/bug-coreutils/2009-12/msg00171.html
>
> Here is a simple program demonstrating the failure:
> $ cat foo.c
> #include <fcntl.h>
> #include <unistd.h>
> #include <sys/stat.h>
> int
> main ()
> {
>   int fd = creat ("file", 0600);
>   struct stat st1, st2;
>   struct timespec t[2] = { { 1000000000, 0 }, { 0, UTIME_OMIT } };
>   fstat (fd, &st1);
>   sleep (1);
>   futimens (fd, t);
>   fstat (fd, &st2);
>   return st1.st_ctime == st2.st_ctime;
> }
> $ gcc -o foo foo.c -D_GNU_SOURCE
> $ ./foo; echo $?
> 1
>
> The exit status should have been 0.
>
> GNU coreutils will end up working around the bug by calling fstat/[l]stat
> prior to futimens/utimensat, and populating the mtime field with the
> desired value rather than using UTIME_OMIT.  But this is a pointless stat
> call, which could be avoided if the kernel were fixed to comply with POSIX
> by updating ctime even when mtime is UTIME_OMIT.

I couldn't reproduce this with your test program on my machine (latest
linus tree). And that utime path looks like no problem, um..., can you
provide output of strace or something?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
