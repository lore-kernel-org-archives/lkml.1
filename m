Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbZBTIgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbZBTIgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221AbZBTIfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:35:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60930 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbZBTIfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:35:50 -0500
Date: Fri, 20 Feb 2009 09:35:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       gleb@redhat.com
Subject: Re: [PATCH] x86: enable x2apic early at the first point
Message-ID: <20090220083528.GB24555@elte.hu>
References: <499DD40F.40102@kernel.org> <1235081612.14523.23.camel@vayu> <499DE05A.40804@kernel.org> <1235086118.14523.40.camel@vayu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235086118.14523.40.camel@vayu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Thu, 2009-02-19 at 14:42 -0800, Yinghai Lu wrote:
> > Ingo want to decouple that x2apic and intr_remapping.
> > it seems it does work with x2apic without intr_remapping in one of setup.
> 
> x2apic with out intr-remapping is not architectural. Even when 
> we have < 255 logical cpu's, logical x2apic id's will be 
> greater than 16 bits even on a single/two socket systems and 
> this will break interrupt delivery. Please look at the x2apic 
> logical destination mode definition in the SDM (Section 
> 9.7.2.3 and 9.7.2.4 in my copy of SDM Vol3a)
> 
> While it might work in certain configurations (for example, 
> physical mode with < 8 bit apicids), it is not architectural 
> and implementation dependent, which may break in future 
> generations.
> 
> And also, logical x2apic mode has more advantages compared to 
> physical mode (like using lowest priority delivery mode etc).
> 
> I will post couple of patches, which revert's Gleb's patch and 
> another fix for the early boot failure issue, tomorrow.

Instead of the revert, we can zap this patch from tip:x86/apic:

  d13d2c3: x86, apic: decouple x2apic from interrupt remapping

But it will all need more cleanups. For example the mandatory 
coupling between x2apic and intr-remap is not clearly spelled 
out.

Also, some of the code has also become rather ugly. For example 
could you please work on eliminating this #ifdef-fest:

earth4:~/tip> grep INTR_REMAP arch/x86/kernel/apic/io_apic.c 
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP
#ifdef CONFIG_INTR_REMAP

for example all the #ifdefs around irq_remapped() look bogus to 
me - dmar.h already defines irq_remapped() to always-0 when 
!CONFIG_INTR_REMAP.

	Ingo
