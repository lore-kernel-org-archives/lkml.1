Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbZH1Mpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbZH1Mpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbZH1Mpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:45:31 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:54520 "EHLO
	QMTA02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481AbZH1Mpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:45:30 -0400
Message-ID: <4A97D16D.5060003@byu.net>
Date: Fri, 28 Aug 2009 06:45:33 -0600
From: Eric Blake <ebb9@byu.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.23) Gecko/20090812 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Florian Weimer <fweimer@bfk.de>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bug-coreutils@gnu.org, bug-gnulib@gnu.org,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] open: introduce O_NOSTD
References: <4A9285FC.8000606@byu.net>	<1251202593-3676-1-git-send-email-ebb9@byu.net>	<alpine.DEB.2.00.0908251420190.18518@makko.or.mcafeemobile.com>	<4A968FF8.8050109@byu.net> <82k50puxx8.fsf@mid.bfk.de>
In-Reply-To: <82k50puxx8.fsf@mid.bfk.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

According to Florian Weimer on 8/27/2009 8:35 AM:
> * Eric Blake:
> 
>> int open_safer (const char *name, int flags, int mode)
>> {
>>   int fd = open (name, flags | O_CLOEXEC, mode);
>>   if (0 <= fd && fd <= 2)
>>     {
>>       int dup = fcntl (fd, ((flags & O_CLOEXEC)
>>                             ? F_DUPFD_CLOEXEC : F_DUPFD), 3);
>>       int saved_errno = errno;
>>       close (fd);
>>       errno = saved_errno;
>>       fd = dup;
>>     }
>>   else if (!(flags & O_CLOEXEC))
>>     {
>>       if ((flags = fcntl (fd, F_GETFD)) < 0
>>           || fcntl (fd, F_SETFD, flags & ~FD_CLOEXEC) == -1)
>>         {
>>           int saved_errno = errno;
>>           close (fd);
>>           fd = -1;
>>           errno = saved_errno;
>>         }
>>     }
>>   return fd;
>> }
> 
>> This solves the fd leak,
> 
> It's still buggy.

In what manner?  Are you stating that F_DUPFD_CLOEXEC is not atomic?

>  You need something like this:
> 
> int open_safer(const char *name, int flags, int mode)
> {
>   int opened_fd[3] = {0, 0, 0};
>   int fd, i, errno_saved;
>   while (1) {
>     fd = open(name, flags | O_CLOEXEC, mode);
>     if (fd < 0 || fd > 2) {
>       break;
>     }
>     opened_fd[fd] = 1;
>   }
>   for (int i = 0; i <= 2; ++i) {
>     if (opened_fd[i]) {
>       errno_saved = errno;
>       close(i);
>       errno = errno_saved;
>     }
>   }
>   return fd;
> }
> 
> It's untested, so it's probably still buggy.

Your version fails to clear the cloexec bit of the final fd if the
original caller didn't request O_CLOEXEC.  If the caller requested
O_CLOEXEC, then your version takes 3, 5, or 7 syscalls depending on how
many std fds were closed, while my version takes 3 syscalls regardless of
how many std fds were closed.  Also, your suggestion has a definite race
in that you are calling open() multiple times rather than cloning an
existing fd after the first open(), such that another process could alter
which file is visited between your first and last open().

- --
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Cygwin)
Comment: Public key at home.comcast.net/~ericblake/eblake.gpg
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqX0W0ACgkQ84KuGfSFAYDYdwCeOB8dt0Rx2QYJkfIsfP452AYj
V7QAoL1FACwnRPhhQ2aTh2EB38i+d34o
=ouPs
-----END PGP SIGNATURE-----
