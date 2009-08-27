Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbZH0N7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbZH0N7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 09:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZH0N7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 09:59:55 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:33142
	"EHLO QMTA11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbZH0N7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 09:59:54 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Aug 2009 09:59:54 EDT
Message-ID: <4A968FF8.8050109@byu.net>
Date: Thu, 27 Aug 2009 07:54:00 -0600
From: Eric Blake <ebb9@byu.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.23) Gecko/20090812 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bug-coreutils@gnu.org, bug-gnulib@gnu.org,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] open: introduce O_NOSTD
References: <4A9285FC.8000606@byu.net> <1251202593-3676-1-git-send-email-ebb9@byu.net> <alpine.DEB.2.00.0908251420190.18518@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.0908251420190.18518@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

According to Davide Libenzi on 8/25/2009 3:53 PM:
>> Another solution is for the application to sanitize all newly-created
>> fds: GNU coreutils provides a wrapper open_safer, which does nothing
>> extra in the common case that open() returned 3 or larger, but calls
>> fcntl(n,F_DUPFD,3)/close(n) before returning if n was less than 3.
>> However, this leads to triple the syscall cost for every open() call
>> if the process starts life with a std fd closed; and if O_CLOEXEC is
>> not used, still leaves a window of time where the fd can be leaked
>> through another thread's use of fork/exec.
> 
> I think we can say that the vast majority of the software is not going to 
> notice the proposed open_safer(), performance-wise, since the first three 
> fds are always filled. So IMO the performance impact argument is a weak one.
> If CLOEXEC semantics are needed in the open operation, F_DUPFD_CLOEXEC can 
> be used to match it.

The current gnulib implementation of open_safer (pre-O_CLOEXEC support) is
(roughly):

/* Wrap open, to guarantee that a successful return value is >= 3.  */
int open_safer (const char *name, int flags, int mode)
{
  int fd = open (name, flags, mode);
  if (0 <= fd && fd <= 2)
    {
      int dup = fcntl (fd, F_DUPFD, 3);
      int saved_errno = errno;
      close (fd);
      errno = saved_errno;
      fd = dup;
    }
  return fd;
}

which has the desired property of no overhead in the common case of all
standard fds open.  But it obviously mishandles the O_CLOEXEC flag.
Here's a first cut at supporting it:

int open_safer (const char *name, int flags, int mode)
{
  int fd = open (name, flags, mode);
  if (0 <= fd && fd <= 2)
    {
      int dup = fcntl (fd, ((flags & O_CLOEXEC)
                            ? F_DUPFD_CLOEXEC : F_DUPFD), 3);
      int saved_errno = errno;
      close (fd);
      errno = saved_errno;
      fd = dup;
    }
  return fd;
}

If the user requested open_safer(O_CLOEXEC), then we still have the
desired property of no syscall overhead and no fd leak.  But if the user
intentionally does not pass O_CLOEXEC because they wanted to create an
inheritable fd, but without stomping on standard fds, then this version
still has a window for an fd leak.  So let's try this version, which
guarantees no fd leak, while still keeping the semantics of giving the
user an inheritable fd outside the std fd range:

int open_safer (const char *name, int flags, int mode)
{
  int fd = open (name, flags | O_CLOEXEC, mode);
  if (0 <= fd && fd <= 2)
    {
      int dup = fcntl (fd, ((flags & O_CLOEXEC)
                            ? F_DUPFD_CLOEXEC : F_DUPFD), 3);
      int saved_errno = errno;
      close (fd);
      errno = saved_errno;
      fd = dup;
    }
  else if (!(flags & O_CLOEXEC))
    {
      if ((flags = fcntl (fd, F_GETFD)) < 0
          || fcntl (fd, F_SETFD, flags & ~FD_CLOEXEC) == -1)
        {
          int saved_errno = errno;
          close (fd);
          fd = -1;
          errno = saved_errno;
        }
    }
  return fd;
}

This solves the fd leak, and open_safer(O_CLOEXEC) is still cheap in the
common case.  But now the case of open_safer without O_CLOEXEC costs 3
syscalls, regardless of whether the standard fds were already open (if we
assumed there were no possibility of new FD_* flags, we could cut the
common-case penalty from three to two by skipping the fcntl(fd,F_GETFD)
and just using fcntl(fd,F_SETFD,0), but that's asking for problems).

> While the patch is simple, IMO this is something that can be easily taken 
> care in glibc layers w/out huge drawbacks.

I hope that my example shows why doing it in the kernel is desirable -
there is no safe way to keep the pre-O_CLOEXEC efficiency using just the
library, but there IS a way to do it with kernel support:

int open_safer (const char *name, int flags, int mode)
{
  return open (name, flags | O_NOSTD, mode);
}

Also, remember this statement from Ulrich in the series that first
introduced O_CLOEXEC/O_NONBLOCK support across all the fd creation APIs:

"In future there will be other uses.  Like a O_* flag to enable the use
of non-sequential descriptors."
http://marc.info/?l=linux-kernel&m=121010907127190&w=2

- --
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Cygwin)
Comment: Public key at home.comcast.net/~ericblake/eblake.gpg
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqWj/gACgkQ84KuGfSFAYClIgCdEw6/7+PiFhR7aKGyuLUd5RdR
lbAAmgKLqCC5zlhkOm/x4K+Om7nqeD0i
=Ibq4
-----END PGP SIGNATURE-----
