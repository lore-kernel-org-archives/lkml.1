Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbZF2PK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbZF2PK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbZF2PKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:10:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51951 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbZF2PKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:10:15 -0400
Date: Mon, 29 Jun 2009 18:10:16 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH v3] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090629151016.GA8122@redhat.com>
References: <20090629132926.GB20289@redhat.com> <1246287519.27006.10660.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246287519.27006.10660.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 07:58:39AM -0700, Suresh Siddha wrote:
> On Mon, 2009-06-29 at 06:29 -0700, Gleb Natapov wrote:
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index d1430ef..3e5b6ea 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -260,12 +260,15 @@ config SMP
> >  
> >  config X86_X2APIC
> >  	bool "Support x2apic"
> > -	depends on X86_LOCAL_APIC && X86_64 && INTR_REMAP
> > +	depends on X86_LOCAL_APIC && X86_64
> 
> Thinking more, probably we shouldn't remove this dependency. This might
> encourage people (knowingly or unknowingly) to enable x2apic without
> interrupt-remapping. Can we remove this? KVM mode will still work even
> if we fail to enable interrupt-remapping. So this shouldn't be an issue,
> correct?
> 
Yes, KVM will still work. I don't have strong fillings one way or the
other, but why mandate an option that is no longer mandatory. What
others think?

> Sorry I should have commented about this before.
> 
> >  
> >  	ioapic_entries = alloc_ioapic_entries();
> >  	if (!ioapic_entries) {
> > -		pr_info("Allocate ioapic_entries failed: %d\n", ret);
> > -		goto end;
> > +		 pr_info("Allocate ioapic_entries failed\n");
> > +		 return;
> 
> 
> We should go to ir_failed ..
Why? There is not more ir_failed.

> 
> >  	}
> >  
> >  	ret = save_IO_APIC_setup(ioapic_entries);
> >  	if (ret) {
> >  		pr_info("Saving IO-APIC state failed: %d\n", ret);
> > -		goto end;
> > +		free_ioapic_entries(ioapic_entries);
> > +		return;
> 
> same here.
> 
Why? What ir_failed should do? Call free_ioapic_entries(ioapic_entries)
and exit?

--
			Gleb.
