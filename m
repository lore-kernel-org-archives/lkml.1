Return-Path: <linux-kernel-owner+w=401wt.eu-S1759601AbZDQXoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601AbZDQXoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 19:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbZDQXnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 19:43:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:43527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007AbZDQXnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 19:43:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,206,1239001200"; 
   d="scan'208";a="507439202"
Subject: Re: [PATCH 3/5] x86, intr-remap: enable interrupt remapping early
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Ingo Molnar <mingo@elte.hu>
Cc: "Han, Weidong" <weidong.han@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
In-Reply-To: <20090417141310.GD23493@elte.hu>
References: <1239957736-6161-1-git-send-email-weidong.han@intel.com>
	 <1239957736-6161-4-git-send-email-weidong.han@intel.com>
	 <20090417141310.GD23493@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 17 Apr 2009 16:42:23 -0700
Message-Id: <1240011743.27006.8496.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 07:13 -0700, Ingo Molnar wrote:
> * Weidong Han <weidong.han@intel.com> wrote:
> 
> > --- a/arch/x86/kernel/apic/apic.c
> > +++ b/arch/x86/kernel/apic/apic.c
> > @@ -118,6 +118,8 @@ static int x2apic_preenabled;
> >  static int disable_x2apic;
> >  static __init int setup_nox2apic(char *str)
> >  {
> > +	if (x2apic_enabled())
> > +		panic("Bios already enabled x2apic, can't enforce nox2apic");
> 
> Could you please turn that into something like:

I have couple of patches cleaning these up(including some warnings). I
will post them shortly.

> > +ir_failed:
> > +	if (x2apic_preenabled)
> > +		panic("x2apic enabled by bios. But IR enabling failed");
> 
> What is the likelyhood that we can continue in compat mode? If 
> there's some chance, we should rather print a KERN_WARNING and 
> should try to continue. If IRQs are not coming we'll hang shortly 
> afterwards anyway.

Typically only on high end platforms we will see x2apic enabled by BIOS
before OS handover. And in these cases, BIOS should have already enabled
interrupt-remapping in extended interrupt mode, before handing over
control to OS. If the extended interrupt mode is set, HW will block  the
compatibility format interrupts anyway. And I think its better to panic
rather than hanging at random places(depending on which interrupts are
already in remapped format and which are not). This way, it will be easy
for anyone to figure out what is happening.

thanks,
suresh

