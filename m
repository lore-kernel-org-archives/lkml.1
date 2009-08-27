Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbZH0Ofz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbZH0Ofz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZH0Ofz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:35:55 -0400
Received: from mx01.bfk.de ([193.227.124.2]:53651 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbZH0Ofy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:35:54 -0400
To: Eric Blake <ebb9@byu.net>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bug-coreutils@gnu.org, bug-gnulib@gnu.org,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] open: introduce O_NOSTD
References: <4A9285FC.8000606@byu.net>
	<1251202593-3676-1-git-send-email-ebb9@byu.net>
	<alpine.DEB.2.00.0908251420190.18518@makko.or.mcafeemobile.com>
	<4A968FF8.8050109@byu.net>
From: Florian Weimer <fweimer@bfk.de>
Date: Thu, 27 Aug 2009 14:35:47 +0000
In-Reply-To: <4A968FF8.8050109@byu.net> (Eric Blake's message of "Thu\, 27 Aug 2009 07\:54\:00 -0600")
Message-ID: <82k50puxx8.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Blake:

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

> This solves the fd leak,

It's still buggy.  You need something like this:

int open_safer(const char *name, int flags, int mode)
{
  int opened_fd[3] = {0, 0, 0};
  int fd, i, errno_saved;
  while (1) {
    fd = open(name, flags | O_CLOEXEC, mode);
    if (fd < 0 || fd > 2) {
      break;
    }
    opened_fd[fd] = 1;
  }
  for (int i = 0; i <= 2; ++i) {
    if (opened_fd[i]) {
      errno_saved = errno;
      close(i);
      errno = errno_saved;
    }
  }
  return fd;
}

It's untested, so it's probably still buggy.

(O_CLOEXEC should have been a thread attribute, like the base path in
the *_at functions. *sigh*)

-- 
Florian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstraﬂe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
