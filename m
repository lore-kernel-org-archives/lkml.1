Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbZI1I1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbZI1I1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 04:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbZI1I1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 04:27:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:54451 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbZI1I1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 04:27:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,465,1249282800"; 
   d="scan'208";a="452175774"
Subject: Re: [BUGFIX -v2] x86, mce, inject: Make injected mce valid only
 during faked handler call
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4AC06D96.4000508@jp.fujitsu.com>
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>
	 <4AC05A57.1080505@jp.fujitsu.com>
	 <1254121753.15717.1373.camel@yhuang-dev.sh.intel.com>
	 <4AC06D96.4000508@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 28 Sep 2009 16:27:37 +0800
Message-Id: <1254126457.15717.1405.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-28 at 16:02 +0800, Hidetoshi Seto wrote: 
> Huang Ying wrote:
> >>> mce.finished is enabled only during faked MCE handler call and
> >>> protected by IRQ disabling. This make it impossible for real
> >>> machine_check_poll to consume it.
> >> Are there the reverse case - is it possible that the faked handler
> >> call might consume real error which is not handled yet by the real
> >> machine_check_poll?
> > 
> > Yes. It's possible at least in theory. But whole mce-inject.c is used
> > for testing only. The faked handler call will not occur on real system.
> 
> Just I concerned that it may confuse the mce test suite.

I don't think that is a big issue. Real MCE is very rare for a normal
machine.

> >>> +#define MCJ_LOADED		(1 << MCJ_LOADED_BIT)
> >> I'd like to see a patch to replace MCJ_* to MCE_INJ_* before
> >> adding new flag.
> > 
> > MCX_ prefix is the naming convention used all over the mce.h, such as
> > MCG_, MCI_, MCM_, if we want to change MCJ_ into MCE_INJ_, we should
> > consider changing all these into similar style to keep consistent. 
> 
> That is bad naming convention, isn't it?
> I don't mind considering changing all those.

MCG_ and MCI_ (MCi) comes from "Intel Software developer's manual Vol
3A", I think keep consistent is more important.

> >> Why
> >>   clear_bit(MCJ_LOADED_BIT, (unsigned long *)&m->inject_flags);
> >>   set_bit(MCJ_LOADED_BIT, (unsigned long *)&i->inject_flags);
> >> cannot be
> >>   m->inject_flags &= ~MCJ_LOADED;
> >>   m->inject_flags |= MCJ_LOADED;
> >> ?
> > 
> > Because they may be write on one CPU and read on another CPU, atomic
> > operation is safer for this.
> 
> I think such read should not happen while write is on flight.
> We already have many barriers all around.
> 
> >> I think the "finished" is not good name. (I suppose it is named
> >> after "loading data to structure have been finished" or so.)
> > 
> > No. Its name is not invented for injecting. It stands for the MCE record
> > writing to mce log buffer has finished. That is, it is named according
> > to normal path, not testing path.
> 
> I know it.
> I just point that there is a bad name since early times.

It is not a bad time when it is used for mce_log and mce_read. Only
finished mce can be read out.

> >> I believe what you want to do here is "make mce_rdmsrl()/mce_wrmsrl()
> >> to refer faked data only during faked handler call."
> >> Then what we have to do is making a flag to indicate that "now
> >> in faked handler call," for an example:
> >>
> >>     309         if (__get_cpu_var(mce_fake_in_progress)) {
> >>
> >> and:
> >> 	local_irq_save(flags);
> >> 	__get_cpu_var(mce_fake_in_progress) = 1;
> >> 	machine_check_poll(0, &b);
> >> 	__get_cpu_var(mce_fake_in_progress) = 0;
> >> 	local_irq_restore(flags);
> > 
> > I don't think this method is better than the original one. They are just
> > equivalent. 
> 
> No, you changed usage of .finished, and transfer the functionality of the
> flag to newly introduced MCJ_LOADED.
> We can keep .finished as is, and introduce one new flag for this.

You just use .finished as MCJ_LOADED and mce_fake_in_progress
as .finished.

Use a per-CPU variable mce_fake_in_progress make it hard to add support
to inject multiple MCEs in one CPU.

Best Regards,
Huang Ying


