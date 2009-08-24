Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZHXSIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZHXSIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbZHXSID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:08:03 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:40910 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZHXSIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=lCfoS2Doydi234q+Si64xmlX6rzv0TZBnIYnJDBwr+61bwfz3Psv3nSxSD9UiRowZ3
         CgATLR0y8tCyttD1uwW/D1D3JtNi0tFNMfXnWo0dgySzbi0F2XS2RsABW9M+oIYz4HpK
         RBOM6kSdIQafZ3wRJ4sBbPBMtjpivw7EFwy2o=
Date: Mon, 24 Aug 2009 11:07:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: cancel_delayed_work and its use of del_timer_sync
References: <20090824065111.A51D8526EC9@mailhub.coreip.homeip.net> <20090824174910.GA16202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824174910.GA16202@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090824183949.B15F5526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 07:49:10PM +0200, Oleg Nesterov wrote:
> On 08/23, Dmitry Torokhov wrote:
> 
> > it is possible to have a reschedule_delayed_work() taht would do a
> > "soft" cancel and [re]submit the work. In the use cases I am concerned
> > about we don't really care if work is not reliably cancelled, we just
> > need to be able to schedule it earlier if it has already been scheduled
> > for execution in some point in the future.
> 
> Well. this depends on how "soft" should be that cancel.
> 
> Consider the auto-rearming delayed work, its work->func() calls
> queue_delayed_work(self, BIG_DELAY). The caller of requeue_work(SMALL_DELAY)
> preempts cwq->thread right after it sets _PENDING.
> 
> Now, what should requeue_work() do ? Even if the requeue_work() and
> work->func() run on different CPUs, in this case requeue_ must spin.
> 
> So. It is easy to create requeue_work() which never sleeps/spins, but
> it can return the error in case it hits the queueing in progress.
> 
> Is it OK?
> 
> And another question, should it cancel (without sleep/spin) this dwork
> if the timer has expired, the work is pending, but its ->func() has not
> started yet?
>

It depends... In most cases we have a delayed work scheduled with a
BIG_DELAY and then interrupt comes and we want to reschedule the delayed
work so it can be executed right away. So, in this particular case, we
don't need to cancel a work that is being scheduled at this particular
moment. On the other hand there was a driver that wanted the same
semantics for delayed works as timers... I think that if work is already
scheduled for execution we could let it go and not try to cancel it.

-- 
Dmitry
