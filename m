Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbYC1VJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbYC1VJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbYC1VI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:08:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57471 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754718AbYC1VI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:08:56 -0400
Date: Fri, 28 Mar 2008 16:08:54 -0500
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] x86_64: Support for new UV apic
Message-ID: <20080328210854.GA8067@sgi.com>
References: <20080328191216.GA16455@sgi.com> <20080328201532.GB26555@elte.hu> <20080328202430.GA13040@sgi.com> <20080328204533.GC7159@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328204533.GC7159@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 09:45:33PM +0100, Ingo Molnar wrote:
> 
> * Jack Steiner <steiner@sgi.com> wrote:
> 
> > On Fri, Mar 28, 2008 at 09:15:32PM +0100, Ingo Molnar wrote:
> > > 
> > > * Jack Steiner <steiner@sgi.com> wrote:
> > > 
> > > > Index: linux/arch/x86/kernel/apic_64.c
> > > > ===================================================================
> > > > --- linux.orig/arch/x86/kernel/apic_64.c	2008-03-28 13:00:22.000000000 -0500
> > > > +++ linux/arch/x86/kernel/apic_64.c	2008-03-28 13:06:12.000000000 -0500
> > > > @@ -738,6 +738,7 @@ void __cpuinit setup_local_APIC(void)
> > > >  	unsigned int value;
> > > >  	int i, j;
> > > >  
> > > > +	preempt_disable();
> > > >  	value = apic_read(APIC_LVR);
> > > >  
> > > >  	BUILD_BUG_ON((SPURIOUS_APIC_VECTOR & 0x0f) != 0x0f);
> > > > @@ -831,6 +832,7 @@ void __cpuinit setup_local_APIC(void)
> > > >  	else
> > > >  		value = APIC_DM_NMI | APIC_LVT_MASKED;
> > > >  	apic_write(APIC_LVT1, value);
> > > > +	preempt_enable();
> > > >  }
> > > 
> > > hm, this looks a bit weird - why are all the preempt-disable/enable 
> > > calls needed?
> > 
> > The first patch had a preempt disable/enable in the function that 
> > reads apicid (see read_apic_id() in arch/x86/kernel/genapic_64.c). 
> > This seemed necessary since large system generate an apicid by reading 
> > the live id & concatenating it with extra bits.
> > 
> > One of the review comments suggested that I change the preempt to a 
> > WARN() since reading apic_id really should be done with preemtion 
> > disabled. The added code eliminates the warnings.
> 
> could you post the stacktraces of the warnings as they occured? All 
> those codepaths should be running with preemption disabled in some 
> natural way.
> 
> 	Ingo

Here is one of the pathes. I have not been able to reproduce the 
other (smp_sanity_check()).  It's possible there was cleanup that
eliminated the message, or I might have forgotten the receipe. I
know it was early in boot:



WARNING: at arch/x86/kernel/genapic_64.c:97 read_apic_id+0x30/0x6a()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-rc7-x86-latest.git-00829-gfb5f592-dirty #15

Call Trace:
 [<ffffffff80231e69>] warn_on_slowpath+0x51/0x63
 [<ffffffff80578d37>] _spin_lock+0xe/0x24
 [<ffffffff8022b289>] task_rq_lock+0x3d/0x6f
 [<ffffffff80579133>] _spin_unlock_irqrestore+0x12/0x2c
 [<ffffffff8022d7fd>] set_cpus_allowed+0xd9/0xe6
 [<ffffffff8057319c>] set_cpu_sibling_map+0x2f4/0x30c
 [<ffffffff8021f434>] read_apic_id+0x30/0x6a
 [<ffffffff807cf898>] native_smp_prepare_cpus+0xc4/0x2d4
 [<ffffffff807c580f>] kernel_init+0x4e/0x2cb
 [<ffffffff8020bee8>] child_rip+0xa/0x12


--- jack
