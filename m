Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389Ab0AKRkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab0AKRkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 12:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250Ab0AKRkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 12:40:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:14899 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab0AKRkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 12:40:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="231466360"
Subject: Re: [PATCH] Make Intel 8-way Xeons boot again
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "yinghai@kernel.org" <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <alpine.LFD.2.00.1001091007150.7821@localhost.localdomain>
References: <20100109101038.GA17555@in.ibm.com>
	 <alpine.LFD.2.00.1001091007150.7821@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 11 Jan 2010 09:38:53 -0800
Message-Id: <1263231535.2859.19.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-09 at 10:11 -0800, Linus Torvalds wrote:
> 
> On Sat, 9 Jan 2010, Ananth N Mavinakayanahalli wrote:
> >
> > On an 8-way system with Intel Xeon X7350 CPUs, booting 2.6.32 or newer
> > kernels fails at:
> > 
> > ...
> > CPU0: Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz stepping 0b
> > Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
> > Brought up 8 CPUs
> > Total of 8 processors activated (46906.05 BogoMIPS).
> > 
> > Git bisect showed 2fbd07a5f as the offending commit.

hmm. Let me check and get back to you on what is wrong. In the legacy
apic case, irrespective of the apic id, if we have 8 or less logical
cpu's, we should be able to use logical flat mode.

> 
> Ok, that commit definitely is buggy.
> 
> > With the patch below, I am able to boot the latest Linus' git tree on
> > the machine. If this patch is correct, it needs to get into the stable
> > tree too.
> 
> I don't think the patch is correct, though. The thing is, the AMD check 
> seems to be the correct one: you can only use 'apic_flat' if all the APIC 
> ID's are < 8.
> 
> It doesn't matter _how_ many CPU's you have. If you have two CPU's, but 
> one of them has an APIC ID >= 8, then you cannot use the flat APIC model, 
> since it depends on a 8-bit bitfield.

flat APIC model has nothing to do with the actual physical apic id's, as
OS programs logical LDR as a bit mask and that is what we use.

> So your patch doesn't seem right either, because it still tests 
> num_processors, which is bogus.
> 
> In fact, I can't for the life of me understand why it treats different 
> vendors differently. Why is that code not just a simple
> 
> 	/* Flat apic mode requires that all APIC ID's are in the range 0..7 */
> 	if (apic == &apic_flat && max_physical_apicid >= 8)
> 		apic = &apic_physflat;
> 
> instead, with no crazy vendor tests.
> 
> What am I missing? 

If I remember, Yinghai mentioned that AMD platforms have some issues
with using flat mode on some systems where the total logical cpus are <=
8. Intel platforms have no such issues.

thanks,
suresh

