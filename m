Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab0BAV0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 16:26:07 -0500
Received: from mga14.intel.com ([143.182.124.37]:46088 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219Ab0BAV0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 16:26:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="239209657"
Subject: Re: [patch 2/2] x86, irq: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR
 instead of 0x1f
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "yinghai@kernel.org" <yinghai@kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1001310705280.31764@eddie.linux-mips.org>
References: <20100114002118.436172066@sbs-t61.sc.intel.com>
	 <20100114002118.521826763@sbs-t61.sc.intel.com>
	 <alpine.LFD.2.00.1001240545180.13034@eddie.linux-mips.org>
	 <4B5C00EB.3000208@zytor.com>
	 <alpine.LFD.2.00.1001310705280.31764@eddie.linux-mips.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 01 Feb 2010 13:24:57 -0800
Message-Id: <1265059497.2802.178.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-30 at 23:19 -0800, Maciej W. Rozycki wrote:
> On Sun, 24 Jan 2010, H. Peter Anvin wrote:
> 
> > > > So change the IRQ_MOVE_CLEANUP_VECTOR to 0x20 and  allow 0x21-0x2f to be
> > > > used
> > > > for device interrupts. 0x30-0x3f will be used for ISA interrupts (these
> > > > also can be migrated in the context of IOAPIC and hence need to be at a
> > > > higher
> > > > priority level than IRQ_MOVE_CLEANUP_VECTOR).
> > > 
> > >   I have troubles understanding what exactly this change is needed for
> > > (i.e. what's the difference between using vectors 0x20-0x2f and 0x30-0x3f
> > > as ExtINT interrupts, what's the gain from relocating them? -- they are
> > > transparent to the APIC, so the exact priority level used does not matter
> > > at all), but since I've been cc-ed, I have one question -- have you
> > > verified that with the new arrangement the mixed interrupt mode (where
> > > some interrupts come via the APIC and some via the 8259A PICs) still
> > > works?
> > > 
> > 
> > The difference is relevant when they are *not* invoked as ExtInt interrupts,
> > but when used as IOAPIC interrupts it matters.
> 
>  Hmm, I/O APIC interrupts coming from ISA devices used not to differ from 
> ones from PCI devices and their vectors were evenly distributed across the 
> whole device range (one reason for this was the (in)famous Pentium APIC 
> limitation WRT multiple outstanding requests at the same priority level).  
> Now what you've written suggests this has changed and now ISA devices only 
> get vectors within a single priority level -- am I getting this right?

Even before the current changes (2.6.32 for example), for irq0 to irq15,
irrespective of whether those irq's were handled by PIC or an IO-APIC,
we were using 16 vectors with in a single priority level for these
irq's.

Looking at the changelog, it looks this issue happened when we merged
io_apic.c for 32-bit and 64-bit. 2.6.28 and beyond uses the same
priority level for irq0..irq15

32bit kernels 2.6.27 and before has the behavior of evenly distributed
vectors for all the io-apic irq's (legacy or non-legacy) but starting
from 2.6.28, only for non-legacy irq's (16 and above) we try to spread
the vectors uniformly across priority levels.

>  If so, then to push my original question further: how are these vectors 
> allocated -- are they identity mapped with the corresponding i8259A 
> vectors?  And how does it play with the Pentium APIC limitation (that may 
> actually apply to all the local APIC cores that use serial bus delivery; 
> I'm not sure) I mentioned above?

As we are using the code from 2.6.28 and no one noticed/complained about
this issue for more than 1.5 years, probably the pentium APIC issue is
not wide-spread.

If we care about this, I can post a fix (which is needed irrespective of
the current changes). 

thanks,
suresh

