Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbYKKRXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbYKKRXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYKKRXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:23:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58152 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbYKKRXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:23:44 -0500
Date: Tue, 11 Nov 2008 19:24:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] atkbd: cancel delayed work before freeing its structure
Message-ID: <20081111182421.GA22518@redhat.com>
References: <20081105153140.25132ca1@psychotron.englab.brq.redhat.com> <20081107154325.GD9368@redhat.com> <20081111145155.GA24881@anvil.corenet.prv> <20081111172050.GC18214@redhat.com> <20081111112741.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111112741.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Dmitry Torokhov wrote:
>
> On Tue, Nov 11, 2008 at 06:20:50PM +0100, Oleg Nesterov wrote:
> > On 11/11, Dmitry Torokhov wrote:
> > >
> > But let me repeat, if queue_delayed_work() fails becuase this work is
> > already queued we (in this particular case) need mb(), not wmb(). Or
> > atkbd_schedule_event_work() can miss a bit in ->event_mask. So I think
> > this wmb() is misleading.
>
> Could you please explain why wmb() is not enough and full mb() is
> needed in this case? I thought that if write happens before we decide
> whether to schedule event_work or not it would be enough.

Yes, but how we decide whether to schedule or not? Let's suppose we do
this without mb(). say, queue_work() starts with

	if (test_bit(WORK_STRUCT_PENDING)) // no barrier semantics
		return;

In that case the code in atkbd_schedule_event_work()

	set_bit(event_bit, &atkbd->event_mask);
	wmb();
	schedule_delayed_work(atkbd->event_work);

can be reordered (if ->event_work is queued) as

	schedule_delayed_work(atkbd->event_work);
	set_bit(event_bit, &atkbd->event_mask);

wmb() can only serialize STOREs, not STORE vs LOAD. The result of
set_bit() can be "delayed".

Now, run_workqueue() does

	// again, no barrier semantics, but this doesn't matter
	clear_bit(WORK_STRUCT_PENDING);

	call atkbd_schedule_event_work()
		if (test_and_clear_bit(atkbd->event_mask))
			 atkbd_set_xxx();

and we can miss an event.

> > And unneeded because queue_work() implies mb(),
> > but this is not really documented.
>
> It would be great if we can get it documented and then i'd drop *mb()
> from atkbd.

It is not easy document the current behaviour. Actually, perhaps
run_workqueue() needs smp_mb__after_clear_bit()...

But for this particular case this doesn't matter. Note that
atkbd_event_work() does test_and_clear_bit(), it can't be re-ordered
with clear_bit(WORK_STRUCT_PENDING), otherwise even mb() can't help.

Oleg.

