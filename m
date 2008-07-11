Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbYGKUuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbYGKUuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYGKUtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:49:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50868 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759933AbYGKUtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:49:52 -0400
Date: Fri, 11 Jul 2008 22:49:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and
	x2apic support
Message-ID: <20080711204931.GB15689@elte.hu>
References: <20080710181634.764954000@linux-os.sc.intel.com> <20080710195320.GA23322@elte.hu> <20080710215617.GM1678@linux-os.sc.intel.com> <20080711102814.GA17938@elte.hu> <20080711200957.GA8173@elte.hu> <20080711203151.GU1678@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080711203151.GU1678@linux-os.sc.intel.com>
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

> On Fri, Jul 11, 2008 at 01:09:57PM -0700, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > >   http://redhat.com/~mingo/misc/config-Thu_Jul_10_21_43_28_CEST_2008.bad
> > > >
> > > > Ingo, that was my stupid typo. Please apply this patch. BTW, we need
> > > > some more xen64 paravirt fixes in this area. I will look at it as
> > > > soon as possible.
> > >
> > > applied to tip/x86/x2apic - thanks Suresh.
> > 
> > another problem is the redefinition of apic_read(), causing:
> > 
> >  arch/x86/xen/enlighten.c: In function ‘xen_patch':
> >  arch/x86/xen/enlighten.c:1084: warning: label ‘patch_site' defined but not used
> >  arch/x86/xen/enlighten.c: At top level:
> >  arch/x86/xen/enlighten.c:1272: error: expected identifier before ‘(' token
> >  arch/x86/xen/enlighten.c:1273: error: expected ‘}' before ‘.' token
> > 
> > with this config:
> > 
> >   http://redhat.com/~mingo/misc/config-Fri_Jul_11_21_51_18_CEST_2008.bad
> > 
> > the continued spaghetti in all the APIC variants is quite ugly. This
> > should all be handled via a single apic_ops template that should cover
> > the paravirt and native variants as well.
> 
> Ingo, I just posted the fix for this.

applied to tip/x86/x2apic:

  Suresh Siddha (3):
        x2apic: uninline uv_init_apic_ldr()
        x2apic: xen64 paravirt basic apic ops
        x2apic: kernel-parameter documentation for "x2apic_phys"

thanks Suresh.

> To cleanup the code:
> 
> struct pv_apic_ops {
> #ifdef CONFIG_X86_LOCAL_APIC
> 	/*
> 	* Direct APIC operations, principally for VMI.  Ideally
> 	* these shouldn't be in this interface.
> 	*/
> 	void (*apic_write)(unsigned long reg, u32 v);
> 	void (*apic_write_atomic)(unsigned long reg, u32 v);
> 	u32 (*apic_read)(unsigned long reg);
> 
> Probably we should move the three above routines to basic apic_ops, 
> which just deal with the apic HW accesses and retain the below for 
> pv_apic_ops, which care more than the basic reg accesses. This will be 
> true for both 32/64bits..
> 
>         void (*setup_boot_clock)(void);
>         void (*setup_secondary_clock)(void);
> 
>         void (*startup_ipi_hook)(int phys_apicid,
>                                  unsigned long start_eip,
>                                  unsigned long start_esp);
> #endif
> };
> 
> Unless there is an objection, I will post the fix.

ok. Jeremy, agreed?

	Ingo
