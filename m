Return-Path: <linux-kernel-owner+w=401wt.eu-S1751359AbZH0Wz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbZH0Wz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 18:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbZH0Wzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 18:55:54 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51705 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZH0Wzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 18:55:54 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 27 Aug 2009 15:55:52 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Eric Blake <ebb9@byu.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bug-coreutils@gnu.org, bug-gnulib@gnu.org,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] open: introduce O_NOSTD
In-Reply-To: <4A968FF8.8050109@byu.net>
Message-ID: <alpine.DEB.2.00.0908271554130.5649@makko.or.mcafeemobile.com>
References: <4A9285FC.8000606@byu.net> <1251202593-3676-1-git-send-email-ebb9@byu.net> <alpine.DEB.2.00.0908251420190.18518@makko.or.mcafeemobile.com> <4A968FF8.8050109@byu.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009, Eric Blake wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> According to Davide Libenzi on 8/25/2009 3:53 PM:
> >> Another solution is for the application to sanitize all newly-created
> >> fds: GNU coreutils provides a wrapper open_safer, which does nothing
> >> extra in the common case that open() returned 3 or larger, but calls
> >> fcntl(n,F_DUPFD,3)/close(n) before returning if n was less than 3.
> >> However, this leads to triple the syscall cost for every open() call
> >> if the process starts life with a std fd closed; and if O_CLOEXEC is
> >> not used, still leaves a window of time where the fd can be leaked
> >> through another thread's use of fork/exec.
> > 
> > I think we can say that the vast majority of the software is not going to 
> > notice the proposed open_safer(), performance-wise, since the first three 
> > fds are always filled. So IMO the performance impact argument is a weak one.
> > If CLOEXEC semantics are needed in the open operation, F_DUPFD_CLOEXEC can 
> > be used to match it.
> 
> The current gnulib implementation of open_safer (pre-O_CLOEXEC support) is
> (roughly):
> 
> /* Wrap open, to guarantee that a successful return value is >= 3.  */
> int open_safer (const char *name, int flags, int mode)
> {
>   int fd = open (name, flags, mode);
>   if (0 <= fd && fd <= 2)
>     {
>       int dup = fcntl (fd, F_DUPFD, 3);
>       int saved_errno = errno;
>       close (fd);
>       errno = saved_errno;
>       fd = dup;
>     }
>   return fd;
> }
> 
> which has the desired property of no overhead in the common case of all
> standard fds open.  But it obviously mishandles the O_CLOEXEC flag.
> Here's a first cut at supporting it:
> 
> int open_safer (const char *name, int flags, int mode)
> {
>   int fd = open (name, flags, mode);
>   if (0 <= fd && fd <= 2)
>     {
>       int dup = fcntl (fd, ((flags & O_CLOEXEC)
>                             ? F_DUPFD_CLOEXEC : F_DUPFD), 3);
>       int saved_errno = errno;
>       close (fd);
>       errno = saved_errno;
>       fd = dup;
>     }
>   return fd;
> }
> 
> If the user requested open_safer(O_CLOEXEC), then we still have the
> desired property of no syscall overhead and no fd leak.  But if the user
> intentionally does not pass O_CLOEXEC because they wanted to create an
> inheritable fd, but without stomping on standard fds, then this version
> still has a window for an fd leak.  So let's try this version, which
> guarantees no fd leak, while still keeping the semantics of giving the
> user an inheritable fd outside the std fd range:
> 
> int open_safer (const char *name, int flags, int mode)
> {
>   int fd = open (name, flags | O_CLOEXEC, mode);
>   if (0 <= fd && fd <= 2)
>     {
>       int dup = fcntl (fd, ((flags & O_CLOEXEC)
>                             ? F_DUPFD_CLOEXEC : F_DUPFD), 3);
>       int saved_errno = errno;
>       close (fd);
>       errno = saved_errno;
>       fd = dup;
>     }
>   else if (!(flags & O_CLOEXEC))
>     {
>       if ((flags = fcntl (fd, F_GETFD)) < 0
>           || fcntl (fd, F_SETFD, flags & ~FD_CLOEXEC) == -1)
>         {
>           int saved_errno = errno;
>           close (fd);
>           fd = -1;
>           errno = saved_errno;
>         }
>     }
>   return fd;
> }
> 
> This solves the fd leak, and open_safer(O_CLOEXEC) is still cheap in the
> common case.  But now the case of open_safer without O_CLOEXEC costs 3
> syscalls, regardless of whether the standard fds were already open (if we
> assumed there were no possibility of new FD_* flags, we could cut the
> common-case penalty from three to two by skipping the fcntl(fd,F_GETFD)
> and just using fcntl(fd,F_SETFD,0), but that's asking for problems).
> 
> > While the patch is simple, IMO this is something that can be easily taken 
> > care in glibc layers w/out huge drawbacks.
> 
> I hope that my example shows why doing it in the kernel is desirable -
> there is no safe way to keep the pre-O_CLOEXEC efficiency using just the
> library, but there IS a way to do it with kernel support:
> 
> int open_safer (const char *name, int flags, int mode)
> {
>   return open (name, flags | O_NOSTD, mode);
> }

Can't the handling be done on close(), like (modulo some errno save/restore):

int safer_close(int fd) {
	int error = close(fd);

	if (fd < 3 && fd >= 0) {
		if ((fd = open("/dev/null", O_RDWR)) > 2)
			close(fd);
	}

	return error;
}



- Davide


