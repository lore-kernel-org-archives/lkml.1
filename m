Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYJWPGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYJWPGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYJWPFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:05:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33903 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbYJWPFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:05:49 -0400
Message-Id: <20081023145054.998439866@marvin.suse.de>
User-Agent: quilt/0.47-12
Date: Thu, 23 Oct 2008 16:50:55 +0200
From: Daniel Gollub <dgollub@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org
Cc: linux-man@vger.kernel.org
Cc: ltp-list@lists.sourceforge.net
Subject: [patch 0/3] [RFC] kernel/glibc mismatch of "readlink" syscall?
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

found something which looks for me like a kernel/glibc syscall mismatch. At
least the parameter list of "readlink" is different in the kernel compared to
glibc, POSIX and linux-man-pages. I'm not quite sure if this difference was
intended or not ... 

man 3p readlink:
ssize_t readlink(const char *restrict path, char *restrict buf, size_t bufsize);

http://www.opengroup.org/onlinepubs/000095399/functions/readlink.html:
size_t readlink(const char *restrict path, char *restrict buf, size_t bufsize);

glibc (/usr/include/unistd.h):
size_t readlink (__const char *__restrict __path, char *__restrict __buf, size_t

man 2 readlink:
ssize_t readlink(const char *path, char *buf, size_t bufsiz);
                                              ^^^^^^
linux-2.6/include/linux/syscalls.h:
asmlinkage long sys_readlink(const char __user *path, char __user *buf, int
		bufsiz);                                                ^^^


All readlink prototypes, expect the one in the kernel, have an unsigned
buffer size. Even the readlink(2) man-page, which also describes an error
statement like this:

EINVAL bufsiz is not positive.

Note: the same man-page defined bufsiz as type of size_t (unsigned).

While reviewing LTP i discovered that the "readlink03" syscall test contains a 
testcase to do a functional error-path test for "EINVAL bufsiz is not positive".
This testcase is using the glibc readlink() interface, which cause a unsigned
cast of the value "-1" and let the testcase fail (actually due to gcc/glibc
fortify checks and cause a __chk_fail()).

Before workarounding the testcase, or not applying -D_FORTIFY_SOURCE=2 on LTP
build, i try to understand if there is any reason for this mismatch between
kernel and glibc/POSIX. Regarding the man-page, i'm quite certain this was a
copy&paste-error by coping the prototype from the POSIX man-page.

Even sys_readlinkat(), which got introduced a long time after sys_readlink(),
got a signed buffer size. Intended?

In the rare case all this was unintended, find patches for kernel, man-pages
and LTP to change the kernel readlink syscall interface to a unsigned buffer
size.

Thoughts?

best regards,
Daniel
