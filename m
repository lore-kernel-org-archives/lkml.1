Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZLVWck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZLVWck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 17:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZLVWci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 17:32:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056AbZLVWci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 17:32:38 -0500
Date: Tue, 22 Dec 2009 14:31:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebb9@byu.net
Cc: bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Ulrich Drepper <drepper@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 14832] New: futimens (AT_FDCWD, arg) should
 fail
Message-Id: <20091222143137.7f9b4e8b.akpm@linux-foundation.org>
In-Reply-To: <bug-14832-10286@http.bugzilla.kernel.org/>
References: <bug-14832-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Fri, 18 Dec 2009 16:08:29 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14832
> 
>            Summary: futimens (AT_FDCWD, arg) should fail
>            Product: File System
>            Version: 2.5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: fs_other@kernel-bugs.osdl.org
>         ReportedBy: ebb9@byu.net
>         Regression: No
> 
> 
> According to POSIX 2008, futimens() shall fail with EBADF if fd is not a valid
> file descriptor.  AT_FDCWD, being negative, falls into this category.  Yet this
> program mistakenly changes the timestamps of the current directory, then
> aborts:
> 
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <errno.h>
> #include <stdlib.h>
> int
> main ()
> {
>   if (futimens (AT_FDCWD, NULL) != -1 || errno != EBADF)
>     abort ();
> }
> 
> Since futimens is a library call on top of utimensat, the fix is to add a
> special case to the utimensat syscall that fails with EBADF if fd is negative
> when path is NULL.
> 

Confused.

: long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags)
: {
: 	int error = -EINVAL;
: 
: 	if (times && (!nsec_valid(times[0].tv_nsec) ||
: 		      !nsec_valid(times[1].tv_nsec))) {
: 		goto out;
: 	}
: 
: 	if (flags & ~AT_SYMLINK_NOFOLLOW)
: 		goto out;
: 
: 	if (filename == NULL && dfd != AT_FDCWD) {
: 		struct file *file;
: 
: 		if (flags & AT_SYMLINK_NOFOLLOW)
: 			goto out;
: 
: 		file = fget(dfd);
: 		error = -EBADF;
: 		if (!file)
: 			goto out;
: 

afacit, if filename==NULL and dfd==-1 then fget() will return NULL and
the syscall returns -EBAFD.

Your report doesn't tell us what kernel version you're testing.  We did
fix a few things ni this area, but it was a long time ago.

