Return-Path: <linux-kernel-owner+w=401wt.eu-S1751363AbZLRFjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbZLRFjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 00:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbZLRFjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 00:39:07 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:38341 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbZLRFjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 00:39:06 -0500
Message-ID: <4B2B156D.9040604@byu.net>
Date: Thu, 17 Dec 2009 22:38:53 -0700
From: Eric Blake <ebb9@byu.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.23) Gecko/20090812 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: utimensat fails to update ctime
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

POSIX requires that utimensat/futimens must update ctime in all cases
where any change is made (it only exempts when both atime and mtime were
requested as UTIME_OMIT, where the file must exist but no change is made).
 Unfortunately, when atime is specified and mtime is UTIME_OMIT, the
kernel mistakenly behaves like read(), by updating atime but not ctime.
This in turn caused a regression in coreutils 8.2, visible through 'touch -a':
http://lists.gnu.org/archive/html/bug-coreutils/2009-12/msg00171.html

Here is a simple program demonstrating the failure:
$ cat foo.c
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
int
main ()
{
  int fd = creat ("file", 0600);
  struct stat st1, st2;
  struct timespec t[2] = { { 1000000000, 0 }, { 0, UTIME_OMIT } };
  fstat (fd, &st1);
  sleep (1);
  futimens (fd, t);
  fstat (fd, &st2);
  return st1.st_ctime == st2.st_ctime;
}
$ gcc -o foo foo.c -D_GNU_SOURCE
$ ./foo; echo $?
1

The exit status should have been 0.

GNU coreutils will end up working around the bug by calling fstat/[l]stat
prior to futimens/utimensat, and populating the mtime field with the
desired value rather than using UTIME_OMIT.  But this is a pointless stat
call, which could be avoided if the kernel were fixed to comply with POSIX
by updating ctime even when mtime is UTIME_OMIT.

-- 
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net
