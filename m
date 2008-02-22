Return-Path: <linux-kernel-owner+w=401wt.eu-S1761458AbYBVCho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761458AbYBVCho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 21:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbYBVChg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 21:37:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:7313 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbYBVChf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 21:37:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,388,1199692800"; 
   d="scan'208";a="300722692"
Subject: Re: [PATCH 2/2] x86 : relocate uninitialized variable in init DATA
	section into init BSS section
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Ian Campbell <ijc@hellion.org.uk>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080221095301.GA29361@elte.hu>
References: <1203581723.4707.20.camel@caritas-dev.intel.com>
	 <20080221090557.GB20055@elte.hu>
	 <1203586106.4707.25.camel@caritas-dev.intel.com>
	 <20080221095301.GA29361@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 22 Feb 2008 10:38:00 +0800
Message-Id: <1203647880.4707.39.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 22 Feb 2008 02:36:38.0410 (UTC) FILETIME=[BFD54EA0:01C874FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 10:53 +0100, Ingo Molnar wrote:
> * Huang, Ying <ying.huang@intel.com> wrote:
> 
> > > > -int __initdata early_ioremap_debug;
> > > > +int __initbss early_ioremap_debug;
> > > 
> > > will we get some sort of build error if we accidentally do:
> > > 
> > >    int __initbss early_ioremap_debug = 1;
> > > 
> > > ?
> > 
> > I tested it just now, and there is no build error.
> 
> well, that's bad. We'd silently ignore the " = 1" and boot up with that 
> value at 0, right? At minimum we need some really prominent build-time 
> _errors_ (i.e. aborted builds) if this ever happens. But ideally, 
> shouldnt this whole thing be done at link time? Couldnt the linker sort 
> the variables that are zero initialized into the right section, and move 
> this constant maintenance pressure off the programmer's shoulder?

I think another method is to add a new attribute into GCC to prepend or
append something to section name instead of just to replace it, like the
example as follow:

#define __initdata  __attribute__((section_append(".init")))

int __initdata early_ioremap_debug_data = 1;
int __initdata early_ioremap_debug_bss;

The GCC can deduce the section (.data or .bss) of global variable based
on whether it is initialized. That is, without attribute,
early_ioremap_debug_data will be in ".data", early_ioremap_debug_bss
will be in ".bss". And with section_append attribute,
early_ioremap_debug_data will be in ".data.init" and
early_ioremap_debug_bss will be in ".bss.init".

Best Regards,
Huang Ying

