Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbZHQWQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbZHQWQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbZHQWQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:16:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:62770 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754AbZHQWQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:16:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,398,1246863600"; 
   d="scan'208";a="717637366"
Subject: Re: [patch] x86, pat: allow ISA memory range uncacheable mapping
 requests
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "xam@debian.org" <xam@debian.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A89C76B.2020307@zytor.com>
References: <1250540630.2709.193.camel@sbs-t61.sc.intel.com>
	 <4A89C76B.2020307@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 17 Aug 2009 15:15:09 -0700
Message-Id: <1250547309.2709.251.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 14:11 -0700, H. Peter Anvin wrote:
> On 08/17/2009 01:23 PM, Suresh Siddha wrote:
> > Max Vozeler reported:
> >>  Bug 13877 -  bogl-term broken with CONFIG_X86_PAT=y, works with =n  
> >>
> >>  strace of bogl-term:
> >>  814   mmap2(NULL, 65536, PROT_READ|PROT_WRITE, MAP_SHARED, 4, 0)
> >> 				 = -1 EAGAIN (Resource temporarily unavailable)
> >>  814   write(2, "bogl: mmaping /dev/fb0: Resource temporarily unavailable\n",
> >> 	       57) = 57
> > 
> > PAT code maps the ISA memory range as WB in the PAT attribute, so that
> > fixed range MTRR registers define the actual memory type (UC/WC/WT etc).
> > 
> > But the upper level is_new_memtype_allowed() API checks are failing,
> > as the request here is for UC and the return tracked type is WB (Tracked type is
> > WB as MTRR type for this legacy range potentially will be different for each
> > 4k page).
> > 
> > Fix is_new_memtype_allowed() by always succeeding the ISA address range
> > checks, as the null PAT (WB) and def MTRR fixed range register settings
> > satisfy the memory type needs of the applications that map the ISA address
> > range.
> 
> This patch seems correct in that it matches the current behavior of the
> code.  I have, though, to ask what the logic behind treating the ISA
> region in this way is.

With the (legacy) applications mapping this ISA region we have observed

a) they typically map more than what they want. some of this might be
covering some RAM backed pages  which are at < 1MB

b) they really don't care about the requested attribute but some specify
uncached and some don't specify any attribute

And mapped ISA range can have different memory attributes (UC, WT, WP
etc) based on the MTRR fixed range registers.

> From a hardware perspective it makes sense --
> these addresses have the Legacy MTRRs which are like a
> physical-address-based PAT, but it seems somewhat odd that'd we would
> expect applications to use different APIs for this region.

We are using the same pat API but the API handles this legacy range
differently.

Atleast some of the special ISA checks can be simplified by tracking the
memory range page by page (based on the attribute set by mtrr etc) for
this region and not at the granularity of the user mapping request. But
we need to pass the per page attributes to the higher level API's like
ioremap() or remap_pfn_range()  who has to set different attributes for
these pfn's. Not sure if this is all worth for some legacy applications
which are not performance sensitive and all they want is to just access
those memory ranges.

thanks,
suresh

