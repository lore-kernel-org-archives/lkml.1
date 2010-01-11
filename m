Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845Ab0AKWyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab0AKWyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083Ab0AKWyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:54:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:32010 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab0AKWys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:54:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,258,1262592000"; 
   d="scan'208";a="586264572"
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR
 instead of 0x1f
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B47E7A9.6090904@zytor.com>
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>
	 <4B47E7A9.6090904@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 11 Jan 2010 14:53:38 -0800
Message-Id: <1263250418.2859.681.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-08 at 18:19 -0800, H. Peter Anvin wrote:
> On 01/08/2010 06:09 PM, Suresh Siddha wrote:
> > 
> > So change the IRQ_MOVE_CLEANUP_VECTOR to 0x20 and  allow 0x21-0x2f to be used
> > for device interrupts. 0x30-0x3f will be used for ISA interrupts (these
> > also can be migrated in the context of IOAPIC and hence need to be at a higher
> > priority level than IRQ_MOVE_CLEANUP_VECTOR).
> > 
> 
> You're referring to when they're accessed as IOAPIC interrupts as
> opposed to ExtInt interrupts?

yes.

> > -/*
> > - * First APIC vector available to drivers: (vectors 0x30-0xee).  We
> > - * start allocating at 0x31 to spread out vectors evenly between
> > - * priority levels. (0x80 is the syscall vector)
> > - */
> > -#define FIRST_DEVICE_VECTOR		(IRQ15_VECTOR + 1)
> > -#define VECTOR_OFFSET_START		1
> > -
> >  #define NR_VECTORS			 256
> >  
> >  #define FPU_IRQ				  13
> > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> > index d5bfa29..5c090a1 100644
> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -1162,8 +1162,8 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
> >  	 * Also, we've got to be careful not to trash gate
> >  	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
> >  	 */
> > -	static int current_vector = FIRST_DEVICE_VECTOR + VECTOR_OFFSET_START;
> > -	static int current_offset = VECTOR_OFFSET_START % 8;
> > +	static int current_vector = FIRST_DEVICE_VECTOR;
> > +	static int current_offset = 0;
> >  	unsigned int old_vector;
> >  	int cpu, err;
> >  	cpumask_var_t tmp_mask;
> > 
> 
> I'm not entirely sure I like losing this bit, even though it isn't
> really necessary with your changes (VECTOR_OFFSET_START would be 0).
> I'm afraid we might end up with the same buglet being "reinvented" later.

Ok. We should be able to retain that bit. I will send another version
shortly.

> However, my most serious concern with this patch is that there is a
> fairly significant change due to this patch, which is that the legacy
> IRQ vectors now fall *inside* the FIRST_DEVICE_VECTOR range.  This isn't
> a bad thing -- in fact, it is fundamentally the right thing to do
> especially once we consider platforms which *don't* have the legacy IRQs
> -- but it makes me scared of unexpected behavior changes as a result.
> If you feel confident that that is not the case, could you outline why
> it shouldn't be a problem?

In irqinit.c, we statically pre-assign the per-cpu vector to irq
mappings (vector_irq) for all the legacy IRQ vectors. Similarly irq_cfg
is statically initialized for legacy IRQ's in io_apic.c. So we won't be
able to use this space for anything else.

thanks,
suresh

