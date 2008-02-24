Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbYBXSFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbYBXSFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYBXSFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:05:42 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:50811 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbYBXSFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:05:41 -0500
Date: Sun, 24 Feb 2008 21:09:31 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Harald Welte <laforge@gnumonks.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH 1/1] file capabilities: simplify signal check
Message-ID: <20080224180931.GA74@tv-sign.ru>
References: <20080223000237.518aace0.akpm@linux-foundation.org> <m17igu6e73.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17igu6e73.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23, Eric W. Biederman wrote:
>
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > um, is that code namespace-clean?
> 
> Choke, gag.
> 
> There are uid namespace issues but since no one has finished the
> uid namespace that I am aware of that is minor.
> 
> However the code does not appear clean/maintainable.  The normal linux
> signal sending policy has already been enforce before we get to this
> point.
> 
> So unless I am totally mistaken the code should read:
> 
> int cap_task_kill(struct task_struct *p, struct siginfo *info,
>                                 int sig, u32 secid)
> {
>         if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
>                 return 0;
> 
>         if (!cap_issubset(p->cap_permitted, current->cap_permitted))
>                 return -EPERM;
> 
> 	return 0;
> }
> 
> Although doing it that way violates:
>        /*
>          * Running a setuid root program raises your capabilities.
>          * Killing your own setuid root processes was previously
>          * allowed.
>          * We must preserve legacy signal behavior in this case.
>          */
> 
> 
> Which says to me the code should really read:
> int cap_task_kill(struct task_struct *p, struct siginfo *info,
>                                 int sig, u32 secid)
> {
> 	return 0;
> }
> 
> The entire point of defining cap_task_kill under
> CONFIG_SECURITY_FILE_CAPABLITIES appears to be deny killing processes
> with more caps.  Killing processes that we could ordinarily kill 
> which have more caps appears to be precisely the case we have decided
> to allow.  So the patched version of cap_task_kill appears to be an
> expensive way of doing nothing, just waiting for someone to complain
> about the last couple of cases it denies until it is truly a noop.

(Can't comment, I never understood this security magic, but Eric's
 explanation looks very reasonable to me).


I just have an almost off-topic (sorry ;) question. Do we really need
kill_pid_info_as_uid() ? Harald Welte cc'ed.

>From "[PATCH] Fix signal sending in usbdevio on async URB completion"
commit 46113830a18847cff8da73005e57bc49c2f95a56

	> If a process issues an URB from userspace and (starts to) terminate
	> before the URB comes back, we run into the issue described above.  This
	> is because the urb saves a pointer to "current" when it is posted to the
	> device, but there's no guarantee that this pointer is still valid
	> afterwards.
	>
	> In fact, there are three separate issues:
	>
	> 1) the pointer to "current" can become invalid, since the task could be
	>    completely gone when the URB completion comes back from the device.
	>
	> 2) Even if the saved task pointer is still pointing to a valid task_struct,
	>    task_struct->sighand could have gone meanwhile.
	>
	> 3) Even if the process is perfectly fine, permissions may have changed,
	>    and we can no longer send it a signal.

The problems 1) and 2) are solved by converting to a struct pid. Is 3) a real
problem? The task which does ioctl(USBDEVFS_SUBMITURB) explicitly asks to send
the signal to it, should we deny the signal even if it changes its credentials
in some way?

Just curious. Thanks,

Oleg.

