Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbYBYSUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbYBYSUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYBYSTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:19:52 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:54520 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbYBYSTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:19:52 -0500
Date: Mon, 25 Feb 2008 21:23:45 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Harald Welte <laforge@gnumonks.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH 1/1] file capabilities: simplify signal check
Message-ID: <20080225182345.GA22095@tv-sign.ru>
References: <20080223000237.518aace0.akpm@linux-foundation.org> <m17igu6e73.fsf@ebiederm.dsl.xmission.com> <20080224180931.GA74@tv-sign.ru> <20080224210842.GA4003@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224210842.GA4003@prithivi.gnumonks.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24, Harald Welte wrote:
>
> On Sun, Feb 24, 2008 at 09:09:31PM +0300, Oleg Nesterov wrote:
> > I just have an almost off-topic (sorry ;) question. Do we really need
> > kill_pid_info_as_uid() ? Harald Welte cc'ed.
> > 
> > From "[PATCH] Fix signal sending in usbdevio on async URB completion"
> > commit 46113830a18847cff8da73005e57bc49c2f95a56
> > 
> > 	> If a process issues an URB from userspace and (starts to) terminate
> > 	> before the URB comes back, we run into the issue described above.  This
> > 	> is because the urb saves a pointer to "current" when it is posted to the
> > 	> device, but there's no guarantee that this pointer is still valid
> > 	> afterwards.
> > 	>
> > 	> In fact, there are three separate issues:
> > 	>
> > 	> 1) the pointer to "current" can become invalid, since the task could be
> > 	>    completely gone when the URB completion comes back from the device.
> > 	>
> > 	> 2) Even if the saved task pointer is still pointing to a valid task_struct,
> > 	>    task_struct->sighand could have gone meanwhile.
> > 	>
> > 	> 3) Even if the process is perfectly fine, permissions may have changed,
> > 	>    and we can no longer send it a signal.
> > 
> > The problems 1) and 2) are solved by converting to a struct pid. Is 3) a real
> > problem? The task which does ioctl(USBDEVFS_SUBMITURB) explicitly asks to send
> > the signal to it, should we deny the signal even if it changes its credentials
> > in some way?
> 
> At the time I discovered the abovementioned problem, '1' and '2' were
> real practical issues that I was seeing on live systems, triggerable
> from userspace with no problems. '3' was more of a theoretical issue
> that was discovered while reading the code and spending some thought on
> it.

Yes, yes, I see, the patch was fine.

> Whether or not we should deny the signal even if the process changes its
> own credentials in some way sounds like a much more esoteric question to
> me.  I think it's fair to say that the resulting behavior is
> "unspecified but shouldn't cause the process and/or kernel to misbehave"
> 
> At least I'm not aware of any usbdevio logic that would require some
> specific behaviour here.

OK, thanks.

So, the only reason why we can't kill kill_pid_info_as_uid() and just use
kill_pid_info() is that USB uses .si_code = SI_ASYNCIO. The latter means
that SI_FROMUSER(info) == T.

I assume that it is not an option to change USB to use .si_code > 0, yes?

Oleg.

