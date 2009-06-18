Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbZFRIsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbZFRIsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 04:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbZFRIsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 04:48:08 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52752 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbZFRIsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 04:48:05 -0400
Subject: Re: [PATCH]x86-tsc.c : fix compile warning
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: balbir@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Cc: Frans Pop <elendil@planet.nl>, "Figo.zhang" <figo1802@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Sumit Panchasara <sumit.panchasara@einfochips.com>,
       "'Sachin P Sant'" <sachinp@linux.vnet.ibm.com>,
       "'H. Peter Anvin'" <hpa@zytor.com>,
       "'Andi Kleen'" <andi@firstfloor.org>,
       "'Thomas Gleixner'" <tglx@linutronix.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
In-Reply-To: <20090618072758.GI22013@balbir.in.ibm.com>
References: <1245247057.3312.2.camel@myhost>
	 <1245248241.4870.12.camel@subratamodak.linux.ibm.com>
	 <20090617152802.GB6042@elte.hu> <200906171812.51478.elendil@planet.nl>
	 <20090617162303.GA10158@elte.hu> <20090618072758.GI22013@balbir.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Organization: IBM
Date: Thu, 18 Jun 2009 14:18:00 +0530
Message-Id: <1245314880.5310.4.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-18 at 12:57 +0530, Balbir Singh wrote:
> * Ingo Molnar <mingo@elte.hu> [2009-06-17 18:23:03]:
> 
> > 
> > * Frans Pop <elendil@planet.nl> wrote:
> > 
> > > On Wednesday 17 June 2009, Ingo Molnar wrote:
> > > > Ah, and you fixed in what a superior way: you improved the code in
> > > > the process :-) This is how warnings should be fixed really.
> > > 
> > > Hmm. Did you also see Pavel's reply to that patch [1]:
> > > ! But that's a bug to be fixed, I'd say? ... actually I believe you are
> > > ! introducing a bug here. Yes, old code would put random numbers in
> > > ! loops_per_jiffy_ref for !CPUFREQ_CONST_LOOPS, but you are introducing
> > > ! oops there.
> > > 
> > > Was his comment incorrect?
> > > 
> > > Cheers,
> > > FJP
> > > 
> > > [1] http://lkml.org/lkml/2009/5/24/159
> > 
> > hm, Pavel seems right - i missed that. Subrata, mind sending an 
> > updated patch?
> >
> 
> Hi, Ingo,
> 
> Yes, it does seem that we'll oops at *lpj, but to be honest the code
> is badly written, ideally the CONFIG_SMP part should be abstracted
> out, having that in a if loop makes reading it time consuming and
> kills a few neuro cells each time.

Balbir/Ingo,

I find this fixed in todayś Linus´s git tree. dummy has been removed,
and, so does lpj initialization taking place properly.

631 static int time_cpufreq_notifier(struct notifier_block *nb, unsigned
long val,
632                                 void *data)
633 {
634         struct cpufreq_freqs *freq = data;
635         unsigned long *lpj;
636 
637         if (cpu_has(&cpu_data(freq->cpu), X86_FEATURE_CONSTANT_TSC))
638                 return 0;
639 
640         lpj = &boot_cpu_data.loops_per_jiffy;

this gets initialized here for the first time on any system.

641 #ifdef CONFIG_SMP
642         if (!(freq->flags & CPUFREQ_CONST_LOOPS))
643                 lpj = &cpu_data(freq->cpu).loops_per_jiffy;
644 #endif

And gets re-assigned if CONFIG_SMP.

Regards--
Subrata

> 
> 

