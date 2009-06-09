Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbZFIPXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbZFIPXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 11:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZFIPXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 11:23:09 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:47362 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbZFIPXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 11:23:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmAGAFgZLkpMQW1W/2dsb2JhbACBT4EwzVmECgU
Date: Tue, 9 Jun 2009 11:23:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       cpufreq@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       trenn@suse.de, sven.wegener@stealer.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, mingo@elte.hu,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] remove rwsem lock from CPUFREQ_GOV_STOP call (second
	call site)
Message-ID: <20090609152302.GA22784@Krystal>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.7vF.2Y7KKB@chimera> <84144f020906070621r1f480eaeief026d23662df380@mail.gmail.com> <a8e1da0906080035j9f8b38drb46132de5a515915@mail.gmail.com> <1244447366.13471.4.camel@penberg-laptop> <20090608124844.GA17588@Krystal> <20090608143220.GC2516@redhat.com> <20090608152316.GA21033@Krystal> <a8e1da0906081815q68ea7741v3568d6cad5f72bb8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <a8e1da0906081815q68ea7741v3568d6cad5f72bb8@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:22:25 up 101 days, 11:48,  4 users,  load average: 0.85, 0.52,
	0.47
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Young (hidave.darkstar@gmail.com) wrote:
> On Mon, Jun 8, 2009 at 11:23 PM, Mathieu
> Desnoyers<mathieu.desnoyers@polymtl.ca> wrote:
> > * Dave Jones (davej@redhat.com) wrote:
> >> On Mon, Jun 08, 2009 at 08:48:45AM -0400, Mathieu Desnoyers wrote:
> >>
> >>  > > > >> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13475
> >>  > > > >> Subject         : suspend/hibernate lockdep warning
> >>  > > > >> References      : http://marc.info/?l=linux-kernel&m=124393723321241&w=4
> >>  > > >
> >>  > > > I suspect the following commit, after revert this patch I test 5 times
> >>  > > > without lockdep warnings.
> >>  > > >
> >>  > > > commit b14893a62c73af0eca414cfed505b8c09efc613c
> >>  > > > Author: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> >>  > > > Date:   Sun May 17 10:30:45 2009 -0400
> >>  > > >
> >>  > > >        [CPUFREQ] fix timer teardown in ondemand governor
> >>  > >
> >>  > > The patch is probably not at fault here. I suspect it's some latent bug
> >>  > > that simply got exposed by the change to cancel_delayed_work_sync(). In
> >>  > > any case, Mathieu, can you take a look at this please?
> >>  >
> >>  > Yes, it's been looked at and discussed on the cpufreq ML. The short
> >>  > answer is that they plan to re-engineer cpufreq and remove the policy
> >>  > rwlock taken around almost every operations at the cpufreq level.
> >>  >
> >>  > The short-term solution, which is recognised as ugly, would be do to the
> >>  > following before doing the cancel_delayed_work_sync() :
> >>  >
> >>  > unlock policy rwlock write lock
> >>  >
> >>  > lock policy rwlock write lock
> >>  >
> >>  > It basically works because this rwlock is unneeded for teardown, hence
> >>  > the future re-work planned.
> >>  >
> >>  > I'm sorry I cannot prepare a patch current... I've got quite a few pages
> >>  > of Ph.D. thesis due for the beginning of July.
> >>
> >> I'm kinda scared to touch this code at all for .30 due to the number of
> >> unexpected gotchas we seem to run into every time we touch something
> >> locking related.  So I'm inclined to just live with the lockdep warning
> >> for .30, and see how the real fixes look for .31, and push them back
> >> as -stable updates if they work out.
> >>
> >>
> >> Venki, what are your thoughts?
> >>
> >
> > Hi Dave,
> >
> > I've looked through the cpufreq code, and the following patch should
> > address the call site I've missed in commit
> > 42a06f2166f2f6f7bf04f32b4e823eacdceafdc9. I've followed all
> > __cpufreq_set_policy call sites within cpufreq.c to make sure they all
> > hold the rwsem write lock. An extra round of review would be good
> > though.
> >
> > Can someone try the following patch and see if it fixes the regression ?
> 
> Bad news, I have tried the patch and It does not fix the regression.
> 

Can you provide the lockdep error message you get with the patch
applied?

Thanks,

Mathieu


> > My test machine is currently busy running long formal verifications, and
> > therefore unavailable for kernel patch testing. It compiles fine on a
> > 2.6.30-rc5 kernel with my (now mainlined) cpufreq patches applied.
> >
> > Mathieu
> >
> >
> > remove rwsem lock from CPUFREQ_GOV_STOP call (second call site)
> >
> > commit  42a06f2166f2f6f7bf04f32b4e823eacdceafdc9
> >
> > Missed a call site for CPUFREQ_GOV_STOP to remove the rwlock taken around the
> > teardown. To make a long story short, the rwlock write-lock causes a circular
> > dependency with cancel_delayed_work_sync(), because the timer handler takes the
> > read lock.
> >
> > Note that all callers to __cpufreq_set_policy are taking the rwsem. All sysfs
> > callers (writers) hold the write rwsem at the earliest sysfs calling stage.
> >
> > However, the rwlock write-lock is not needed upon governor stop.
> >
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: rjw@sisk.pl
> > CC: mingo@elte.hu
> > CC: Shaohua Li <shaohua.li@intel.com>
> > CC: Pekka Enberg <penberg@cs.helsinki.fi>
> > CC: Dave Young <hidave.darkstar@gmail.com>
> > CC: "Rafael J. Wysocki" <rjw@sisk.pl>
> > CC: Rusty Russell <rusty@rustcorp.com.au>
> > CC: trenn@suse.de
> > CC: sven.wegener@stealer.net
> > CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > CC: cpufreq@vger.kernel.org
> > ---
> >  drivers/cpufreq/cpufreq.c |   11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > Index: linux-2.6-lttng/drivers/cpufreq/cpufreq.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/drivers/cpufreq/cpufreq.c      2009-06-08 10:20:48.000000000 -0400
> > +++ linux-2.6-lttng/drivers/cpufreq/cpufreq.c   2009-06-08 10:48:52.000000000 -0400
> > @@ -1697,8 +1697,17 @@ static int __cpufreq_set_policy(struct c
> >                        dprintk("governor switch\n");
> >
> >                        /* end old governor */
> > -                       if (data->governor)
> > +                       if (data->governor) {
> > +                               /*
> > +                                * Need to release the rwsem around governor
> > +                                * stop due to lock dependency between
> > +                                * cancel_delayed_work_sync and the read lock
> > +                                * taken in the delayed work handler.
> > +                                */
> > +                               unlock_policy_rwsem_write(data->cpu);
> >                                __cpufreq_governor(data, CPUFREQ_GOV_STOP);
> > +                               lock_policy_rwsem_write(data->cpu);
> > +                       }
> >
> >                        /* start new governor */
> >                        data->governor = policy->governor;
> >
> >
> > --
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> 
> -- 
> Regards
> dave
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
