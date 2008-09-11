Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbYIKFrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYIKFrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 01:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYIKFrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 01:47:04 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:59276 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbYIKFrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 01:47:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=inOeixqRIJjXeWX/KXrEEgpGYAfoEmnBbecjwdIo+5rm2KFirWM+Oa4oLtFNzLwOiN
         9CN52mVMV9A1IZ+zARCFFJK0uJu5/o9SK8SYo9Grq+B/Ajog+J+bENQPSWjeYOREIPdk
         MeQ/Bjm58qPtiVPd5G03hqkf75Wh8ohhLsxVo=
Message-ID: <cfd18e0f0809102247h677acc76r9c76994cdf036443@mail.gmail.com>
Date: Thu, 11 Sep 2008 07:47:00 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: paccept() oddity
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Oleg Nesterov" <oleg@tv-sign.ru>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20080911003833.265E7154210@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AC4B6E.4040409@gmail.com>
	 <20080910111016.b289b3eb.akpm@linux-foundation.org>
	 <20080911003833.265E7154210@magilla.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland,

Thanks for having a look at this.

On 9/11/08, Roland McGrath <roland@redhat.com> wrote:
> I don't see any rationale for changing paccept to be an oddball special
> case in its EINTR behavior.
>
> select/poll are special cases historically, and that's why the principle of
> least astonishment makes it best for pselect/ppoll to match their behavior.

I agree on the idea of least astonishment.  I just differ on where
greater astonishment is considered to lie.  If I'm making a system
call one of whose arguments is a mask of signals that the system call
should wait for, then I expect the system call to return, rather than
restart, if that signal is delivered, regardless of SA_RESTART.  This
is the behaviour of pselect(), which seems perfectly reasonable, and
happens to coincide with historical select() EINTR behavior.

But, perhaps all of this is moot, given the point you raise below (and
which I already raised with Ulrich)...

> The same principle makes it highly dubious to have paccept differ from
> accept in such a subtlety.  I don't see any reason to want it, anyway.
> An application that wants to see EINTR can just use sigaction to clear
> SA_RESTART.
>
> Frankly, I don't see the rationale for rolling the implicit sigprocmask
> into paccept at all.  accept is analogous to read or other i/o calls,
> not to select/poll.

That is precisely the other point about paccept() that I've already
raised, which drew no response from Ulrich:

http://thread.gmane.org/gmane.linux.kernel/723952/focus=728786
(I'll add you to the CC on that thread.)

> It's not any normal plan to fiddle blocked signals
> around a blocking i/o call.  Instead, programs use (p)select/poll (and
> sometimes also O_NONBLOCK) to manage the blocking and waking up.  Then
> when the program finally calls accept, it knows it won't block.  The
> atomic signal machinery makes sense for pselect/ppoll to help manage the
> corner cases of blocking/wakeup in event loops.  It makes no more sense
> to roll blocked signal set changes into accept than it would to have
> read, write, etc. all take a sigset_t and do that.

Agreed.

Given that adding a sigset to accept():

* seems unnecessary (i.e., it provides no functionality that we can't
get otherwise), * is inconsistent with other I/O APIs that don't have
a sigset argument (e.g., read(), write(), redvfrom(), open(), etc.)
* currently (IMO) provides questionable semantics around EINTR

I'd argue in favour of eliminating this syscall in favour of a simpler:

accept4(int fd, struct sockaddr *sa, socklen_t *salen, ind flags);

and in the meantime disabling sys_paccept() in -rc.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
