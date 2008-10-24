Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYJXWxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYJXWxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 18:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYJXWx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:53:27 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:56992 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYJXWx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:53:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=qyDGGatz4rvK04qbs1I38Bwsedy33SCagc21wDs/bCjvwBKVRkSMCWJaItEjBg9Eoy
         +rHQr9zKeHkWEXVmsjKooTGnoOGC09nTyouaIHw+N1TTZIyMRdC2TKaaNuHOECExlqCY
         flD+AaLDPYWVzU4U9EOJE064+1NuIHEOVVIwM=
Message-ID: <cfd18e0f0810241553x77194611o11655a89871dc210@mail.gmail.com>
Date: Fri, 24 Oct 2008 17:53:25 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Daniel Gollub" <dgollub@suse.de>
Subject: Re: [patch 0/3] [RFC] kernel/glibc mismatch of "readlink" syscall?
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       linux-man@vger.kernel.org, ltp-list@lists.sourceforge.net,
       "A.E. Brouwer" <aeb@win.tue.nl>
In-Reply-To: <20081023145054.998439866@marvin.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081023145054.998439866@marvin.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding the man-pages historian to the CC.]

Hi Daniel,

On Thu, Oct 23, 2008 at 9:50 AM, Daniel Gollub <dgollub@suse.de> wrote:
> Hi,
>
> found something which looks for me like a kernel/glibc syscall mismatch. At
> least the parameter list of "readlink" is different in the kernel compared to
> glibc, POSIX and linux-man-pages. I'm not quite sure if this difference was
> intended or not ...
>
> man 3p readlink:
> ssize_t readlink(const char *restrict path, char *restrict buf, size_t bufsize);
>
> http://www.opengroup.org/onlinepubs/000095399/functions/readlink.html:
> size_t readlink(const char *restrict path, char *restrict buf, size_t bufsize);
>
> glibc (/usr/include/unistd.h):
> size_t readlink (__const char *__restrict __path, char *__restrict __buf, size_t
>
> man 2 readlink:
> ssize_t readlink(const char *path, char *buf, size_t bufsiz);
>                                              ^^^^^^
> linux-2.6/include/linux/syscalls.h:
> asmlinkage long sys_readlink(const char __user *path, char __user *buf, int
>                bufsiz);                                                ^^^
>
>
> All readlink prototypes, expect the one in the kernel, have an unsigned
> buffer size. Even the readlink(2) man-page, which also describes an error
> statement like this:
>
> EINVAL bufsiz is not positive.

I agree; the inconsistency is strange.  Probably it was a historical accident.

> Note: the same man-page defined bufsiz as type of size_t (unsigned).

A little history, as it appears to me...

It looks like the Linux man page came from BSD.  The 4.3BSD man page
documented the type as "int" (and did not document an EINVAL error for
a negative bufsize), and even today the FreeBSD (6.2) man page
documents the type as "int" (and still does not document an EINVAL
error for this case), and that is how the argument is prototyped in
FreeBSD 6.2's <unistd.h>.  (I haven't tested what FreeBSD actually
does with a negative bufsize value.)

In 1993, when Linux man-pages-1.0 took the page from BSD (that page
was timestamped 19991), it looks like someone must have changed the
type of bufsize to "size_t" in the man page SYNOPSIS.  Now that could
be to match Linux libc of the time, which was already using "size_t"
(even though the then current kernel used "int"), or it could have
been to match the current standards (SUSv1, which was based on the
original POSIX.1, documents the type as "size"t").

The EINVAL error was added to man-pages-1.18 in 1997 (even though, as
you note, the type was "size_t").  I suspect (this was well before I
had any association with man-pages) that was done to reflect kernel
reality (since one could bypass glibc invoke the syscall directly),
but obviously it is inconsistent with the prototype.

> While reviewing LTP i discovered that the "readlink03" syscall test contains a
> testcase to do a functional error-path test for "EINVAL bufsiz is not positive".
> This testcase is using the glibc readlink() interface, which cause a unsigned
> cast of the value "-1" and let the testcase fail (actually due to gcc/glibc
> fortify checks and cause a __chk_fail()).
>
> Before workarounding the testcase, or not applying -D_FORTIFY_SOURCE=2 on LTP
> build, i try to understand if there is any reason for this mismatch between
> kernel and glibc/POSIX. Regarding the man-page, i'm quite certain this was a
> copy&paste-error by coping the prototype from the POSIX man-page.

(See above -- the type might have been taken either from POSIX.1 or
glibc, and that might have been quite deliberate.)

> Even sys_readlinkat(), which got introduced a long time after sys_readlink(),
> got a signed buffer size. Intended?

Probably done to match sys_readlink().

> In the rare case all this was unintended, find patches for kernel, man-pages
> and LTP to change the kernel readlink syscall interface to a unsigned buffer
> size.
>
> Thoughts?

Your proposed kernel patch is an ABI change, albeit one that quite
likely would affect no applications.  So it might not hurt any one.
On the other hand, is there a benefit to making the change?

Perhaps the best think to do is simply to add a note to the man page
about this inconsistency.  (It's not sufficient to just remove the
EINVAL error as you propose in one of your patches, since that can
still occur when bypassing glibc.)

Perhaps others have some thoughts?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
