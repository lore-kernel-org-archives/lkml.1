Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbYDXMeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbYDXMeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbYDXMed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:34:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:56050 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418AbYDXMea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:34:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=pwbcl/ox3R1oUi1Bq0620IxgDgXyT6hFQbOYRKnxNax77Ak1FJAq7nhZS1shkw/c9qY75b888MorNLRYA3kmrMfFO6Ye4fBMV3Ly3+TSolnv72uaCkz6HVKlR7S5cShYH08CMX9NgCCHksBmLQXe7nLbgOg7Zj4uWurFZm12QnA=
Message-ID: <517f3f820804240534r3bbbdc52s52a6dfe3f2d14b7f@mail.gmail.com>
Date: Thu, 24 Apr 2008 14:34:27 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] alternative to sys_indirect, part 1
Cc: "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Michael Kerrisk" <mtk.manpages@gmail.com>, michael.kerrisk@gmail.com,
       linux-man@vger.kernel.org
In-Reply-To: <20080424112514.055d8071@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>
	 <20080424112514.055d8071@the-village.bc.nu>
X-Google-Sender-Auth: f88e642d979760d6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/08, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > - I decided against using the O_* flags here.  Most are not useful and
>  >   we might need the bits for something else at some time.  Hence the
>  >   new SOCKFL_* flag.  The intend is to define SOCKFL_CLOEXEC and
>  >   O_CLOEXEC to the same value.  In this case there is zero overhead.
>
>
> Given we will never have 2^32 socket types, and in a sense this is part
>  of the type why not just use
>
>         socket(PF_INET, SOCK_STREAM|SOCK_CLOEXEC, ...)
>
>  that would be far far cleaner, no new syscalls on the socket side at all.

That''s not quite true.  There is still the problem of accept().

It's worth trying to summarize all of the syscalls that create file
descriptors to get a handle on how many new syscalls might really be
required.  AFAIK, the list below is all of the syscalls that create
FDs on Linux.

The following system calls all have a flags argument that either
already has a O_CLOEXEC functionality, or to which that functionality
could be added:

* open()
* openat()
* fcntl(F_DUPFD)
* timerfd_create()
* mq_open() (on Linux MQ descriptors are really just file descriptors)

For the following system calls, we could overload another argument for
the purpose:
* socket() (using the 'type' argument, as per Alan's suggestion)

The following syscalls don't have a flags argument, but does it
matter?  For each of them there is an alternative API that can be used
instead, if the functionality is required.

* dup2() -- use fcntl(F_DUPFD) instead
* dup() -- use fcntl(F_DUPFD) instead
* creat() -- use open() instead

The following system call doesn't have a flags argument, but we could
conceivably overload the existing 'fd' argument.  When creating a new
file descriptor, the 'fd' argument must be -1.  We could say that to
create a new fd, the argument must be say NEW_SIGNALFD, defined as
-MAXINT, ORed with the desired flags.

* signalfd()  (glibc API supplies a flags argument, but the syscall
doesn't have one)

The following system calls don't have a flags argument, and the only
way to solve the problem is a new syscall, or sys_indirect().

* eventfd()  (glibc API supplies a flags argument, but the syscall
doesn't have one)
* accept()
* pipe()
* inotify_init()
* epoll_create()

So the alternative to sys_indirect(), at least for the purpose of
O_CLOEXEC and similar, would be to create 5 new system calls (or six,
if one finds the signalfd() hack too ugly, which perhaps it is; or 7
if one doesn't like Alan's suggestion for socket() -- if one went the
route of new syscalls, then I'd suggest creating a new socket()-type
syscall with a flags argument).

Cheers,

Michael


-- 
I'll likely only see replies if they are CCed to mtk.manpages at gmail dot com
