Return-Path: <linux-kernel-owner+w=401wt.eu-S1756948AbYISAfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbYISAfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 20:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbYISAfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 20:35:30 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56793 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206AbYISAf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 20:35:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jack Steiner <steiner@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dean Nelson <dcn@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Mayer <ajm@sgi.com>, jeremy@goop.org,
       rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <Yinghai.lu@amd.com>
References: <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org>
	<20080911152304.GA13655@sgi.com> <20080914153522.GJ29290@elte.hu>
	<20080915215053.GA11657@sgi.com> <20080916082448.GA17287@elte.hu>
	<20080916204654.GA3532@sgi.com> <48D1575E.1050306@zytor.com>
	<20080917202102.GA166524@sgi.com> <m1zlm6zafo.fsf@frodo.ebiederm.org>
	<20080918191052.GA22864@sgi.com>
Date: Thu, 18 Sep 2008 17:28:49 -0700
In-Reply-To: <20080918191052.GA22864@sgi.com> (Jack Steiner's message of "Thu,
	18 Sep 2008 14:10:52 -0500")
Message-ID: <m1zlm5rnb2.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jack Steiner <steiner@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4976]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 0/4] dynamically allocate arch specific system vectors
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Steiner <steiner@sgi.com> writes:

> On Wed, Sep 17, 2008 at 03:15:07PM -0700, Eric W. Biederman wrote:
>> Jack Steiner <steiner@sgi.com> writes:
>> 
>> > On Wed, Sep 17, 2008 at 12:15:42PM -0700, H. Peter Anvin wrote:
>> >> Dean Nelson wrote:
>> >> >
>> >> >    sgi-gru driver
>> >> >
>> >> >The GRU is not an actual external device that is connected to an IOAPIC.
>> >> >The gru is a hardware mechanism that is embedded in the node controller
>> >> >(UV hub) that directly connects to the cpu socket. Any cpu (with 
>> >> >permission)
>> >> >can do direct loads and stores to the gru. Some of these stores will
> result
>> >> >in an interrupt being sent back to the cpu that did the store.
>> >> >
>> >> >The interrupt vector used for this interrupt is not in an IOAPIC. Instead
>> >> >it must be loaded into the GRU at boot or driver initialization time.
>> >> >
>> >> 
>> >> Could you clarify there: is this one vector number per CPU, or are you 
>> >> issuing a specific vector number and just varying the CPU number?
>> >
>> > It is one vector for each cpu.
>> >
>> > It is more efficient for software if the vector # is the same for all cpus
>> Why?  Especially in terms of irq counting that would seem to lead to cache
>> line conflicts.
>
> Functionally, it does not matter. However, if the IRQ is not a per-cpu IRQ, a
> very large number of IRQs (and vectors) may be needed. The GRU requires 32
> interrupt
> lines on each blade. A large system can currently support up to 512 blades.

Every vendor of high end hardware is saying they intend to provide
1 or 2 queues per cpu and 1 irq per queue.  So the GRU is not special in
that regard.  Also a very large number of IRQs is not a problem as
soon as we start dynamically allocating them, which is currently
in progress.

Once we start dynamically allocating irq_desc structures we can put
them in node-local memory and guarantee there is no data shared between
cpus.

> After looking thru the MSI code, we are starting to believe that we should
> separate
> the GRU requirements from the XPC requirements. It looks like XPC can easily use
> the MSI infrastructure.  XPC needs a small number of IRQs, and interrupts are
> typically
> targeted to a single cpu. They can also be retargeted using the standard
> methods.

Alright. 

I would be completely happy if there were interrupts who's affinity we can
not change, and are always targeted at a single cpu.

> The GRU, OTOH, is more like a timer interrupt or like a co-processor interrupt.
> GRU interrupts can occur on any cpu using the GRU. When interrupts do occur, all
> that
> needs to happen is to call an interrupt handler. I'm thinking of something like
> the following:
>
> 	- permanently reserve 2 system vectors in include/asm-x86/irq_vectors.h
> 	- in uv_system_init(), call alloc_intr_gate() to route the
> 	  interrupts to a function in the file containing uv_system_init().
> 	- initialize the GRU chipset with the vector, etc, ...
> 	- if an interrupt occurs and the GRU driver is NOT loaded, print
> 	  an error message (rate limited or one time)
>
> 	- provide a special UV hook for the GRU driver to register/deregister a
> 	  special callback function for GRU interrupts

That would work.  So far the GRU doesn't sound that special.

For a lot of this I would much rather solve the general case on this
giving us a solution that works for all high end interrupts rather than
one specific solution just for the GRU.  Especially since it looks like
we have most of the infrastructure already present to solve the general
case and we have to develop and review the specific case from scratch.

Eric
