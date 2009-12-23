Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbZLWNIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbZLWNIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 08:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbZLWNIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 08:08:22 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:42024 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755831AbZLWNIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 08:08:22 -0500
Message-ID: <4B321663.2050603@byu.net>
Date: Wed, 23 Dec 2009 06:08:51 -0700
From: Eric Blake <ebb9@byu.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.23) Gecko/20090812 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Ulrich Drepper <drepper@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 14832] New: futimens (AT_FDCWD, arg) should
 fail
References: <bug-14832-10286@http.bugzilla.kernel.org/> <20091222143137.7f9b4e8b.akpm@linux-foundation.org>
In-Reply-To: <20091222143137.7f9b4e8b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Andrew Morton on 12/22/2009 3:31 PM:
> Confused.
> 
> : long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags)
> : {
> : 	int error = -EINVAL;
> : 
> : 	if (times && (!nsec_valid(times[0].tv_nsec) ||
> : 		      !nsec_valid(times[1].tv_nsec))) {
> : 		goto out;
> : 	}
> : 
> : 	if (flags & ~AT_SYMLINK_NOFOLLOW)
> : 		goto out;
> : 
> : 	if (filename == NULL && dfd != AT_FDCWD) {
> : 		struct file *file;
> : 
> : 		if (flags & AT_SYMLINK_NOFOLLOW)
> : 			goto out;
> : 
> : 		file = fget(dfd);
> : 		error = -EBADF;
> : 		if (!file)
> : 			goto out;
> : 
> 
> afacit, if filename==NULL and dfd==-1 then fget() will return NULL and
> the syscall returns -EBAFD.

Yes, that's true if dfd==-1.  But My complaint was not about dfd==-1, but
about dfd==AT_FDCWD, in which case, this block of code is skipped, and you
end up operating on the current directory ".".  My point is that the line:
 if (filename == NULL && dfd != AT_FDCWD) {
should probably be:
 if (filename == NULL) {
assuming that fget(AT_FDCWD) likewise fails.

> 
> Your report doesn't tell us what kernel version you're testing.  We did
> fix a few things ni this area, but it was a long time ago.

Yesterday, Ulrich patched glibc to avoid the issue from the library side
of things (I first raised the report against glibc 2 months ago, along
with a proposed patch:
http://sources.redhat.com/bugzilla/show_bug.cgi?id=10992).  But there is
still the case of newer kernels and unpatched glibc, where it would also
be nice to patch the kernel.  I reproduced the bug on
2.6.31.6-166.fc12.i686, where this test (part of coreutils' configure
script) failed with status 2:

| #include <fcntl.h>
| #include <sys/stat.h>
| #include <unistd.h>
|
| int
| main ()
| {
| struct timespec ts[2] = { { 1, UTIME_OMIT }, { 1, UTIME_NOW } };
|       int fd = creat ("conftest.file", 0600);
|       struct stat st;
|       if (fd < 0) return 1;
|       if (futimens (AT_FDCWD, NULL)) return 2;
|       if (futimens (fd, ts)) return 3;
|       sleep (1);
|       ts[0].tv_nsec = UTIME_NOW;
|       ts[1].tv_nsec = UTIME_OMIT;
|       if (futimens (fd, ts)) return 4;
|       if (fstat (fd, &st)) return 5;
|       if (st.st_ctime < st.st_atime) return 6;
|
|   ;
|   return 0;
| }


-- 
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net
