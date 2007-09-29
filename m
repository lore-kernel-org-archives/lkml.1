Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbXI2ATT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbXI2ATT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 20:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbXI2ATK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 20:19:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:36806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbXI2ATJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 20:19:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,211,1188802800"; 
   d="scan'208";a="156736765"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH RFC] paravirt_ops: refactor struct paravirt_ops into smaller pv_*_ops
Date: Fri, 28 Sep 2007 17:19:07 -0700
Message-ID: <97D612E30E1F88419025B06CB4CF1BE1039B6D3E@scsmsx412.amr.corp.intel.com>
In-Reply-To: <46FD8FE1.4090507@goop.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH RFC] paravirt_ops: refactor struct paravirt_ops into smaller pv_*_ops
Thread-Index: AcgCKFYGlyuTuOJZQvu/hguQ3nn1nwAAXNFg
References: <46FD4388.6000106@goop.org> <97D612E30E1F88419025B06CB4CF1BE10396C957@scsmsx412.amr.corp.intel.com> <46FD8FE1.4090507@goop.org>
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Andi Kleen" <ak@suse.de>, "Zachary Amsden" <zach@vmware.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Avi Kivity" <avi@qumranet.com>,
       "Glauber de Oliveira Costa" <glommer@gmail.com>,
       "Anthony Liguori" <anthony@codemonkey.ws>,
       "Virtualization Mailing List" <virtualization@lists.osdl.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
X-OriginalArrivalTime: 29 Sep 2007 00:19:08.0801 (UTC) FILETIME=[5A5F5F10:01C8022E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Nakajima, Jun wrote:
> > Jeremy Fitzhardinge wrote:
> > 
> > 
> > > +	.pv_irq_ops = {
> > > +		 .init_IRQ = native_init_IRQ,
> > > +		 .save_fl = native_save_fl,
> > > +		 .restore_fl = native_restore_fl,
> > > +		 .irq_disable = native_irq_disable,
> > > +		 .irq_enable = native_irq_enable,
> > > +		 .safe_halt = native_safe_halt,
> > > +		 .halt = native_halt,
> > > +	 },
> > > 
> > 
> > I think the halt stuff should be moved to pv_cpu_ops?
> > 
> You mean halt's alternate "shutdown vcpu" meaning if you call it with
> interrupts disabled?  Yeah, I'd be happy to have an explicit op for
> that, rather than making it a secondary overloaded meaning.  And use
> "safe_halt" for all uses of "wait for next interrupt".

Yes. For the native, "safe_halt" is "sti; hlt". The "native_halt" is
just "hlt". So the para_virt part of "hlt" could be moved to pv_cpu_ops,
and the "sti" part stays in pv_irq_ops.

> 
> > > +	.pv_misc_ops = {
> > > +		 .set_lazy_mode = paravirt_nop,
> > > +	 },
> > > 
> > 
> > Or you can split it to pv_cpu_ops and pv_mmu_ops, assuming that they
> > don't need to interact with each other in terms of the lazy
handling.
> > 
> 
> You mean have separate lazy_mmu and lazy_cpu (lazy_context_switch)
ops?
> Possible, but they're still exclusive.  (I think VMI, at least,
assumes
> that you can't have lazy_mmu and lazy_cpu active at the same time, and
> its nice to enforce this in the interface.)

Okay I understand what you are saying.

> 
> But having a whole misc structure for this interface is pretty warty,
I
> admit.
> 
>     J

Actually my concern was that such misc ops might grow to include the
things don't fit well anywhere else. To me, then pv_lazy_ops (with just
.set_mode) might be better.

Jun
---
Intel Open Source Technology Center
