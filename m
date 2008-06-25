Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbYFYANP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbYFYANP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 20:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYFYAM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 20:12:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:18016 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbYFYAM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 20:12:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,699,1204531200"; 
   d="scan'208";a="345227193"
Date: Tue, 24 Jun 2008 17:12:56 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Max Asbock <masbock@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: mce_64.c: mce_cpu_quirks being ignored
Message-ID: <20080625001256.GA31734@linux-os.sc.intel.com>
References: <1213908276.5942.16.camel@w-amax.beaverton.ibm.com> <485ACCA1.6070507@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485ACCA1.6070507@firstfloor.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 02:16:17PM -0700, Andi Kleen wrote:
> Max Asbock wrote:
> 
> 
> 
> > static void __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
> > {
> >         /* This should be disabled by the BIOS, but isn't always */
> >         if (c->x86_vendor == X86_VENDOR_AMD) {
> >                 if(c->x86 == 15)
> >                         /* disable GART TBL walk error reporting, which trips off
> >                            incorrectly with the IOMMU & 3ware & Cerberus. */
> >                         clear_bit(10, &bank[4]);
> > ....
> >
> > Is turning off that bit still needed?
> 
> Yes it is. Also referencing the bank is needed for other reasons anyways,
> otherwise it would ignore the user sysfs choice on reconfiguration.
> 
> Venki, I did a patch for dynamic banks anyways, but haven't submitted it yet.
> 

Yes. That particular quirk getting ignored was a bug. Below patch fixes
the bug, until we have the dynamic banks support.

sysfs choice configuration should not have any issues with the earlier patch
as we look for NR_SYSFS_BANKS in do_machine_check().

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2008-06-24 16:01:23.000000000 -0700
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_64.c	2008-06-24 16:48:01.000000000 -0700
@@ -463,7 +463,11 @@ static void mce_init(void *dummy)
 		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
 
 	for (i = 0; i < banks; i++) {
-		wrmsrl(MSR_IA32_MC0_CTL+4*i, ~0UL);
+		if (i < NR_SYSFS_BANKS)
+			wrmsrl(MSR_IA32_MC0_CTL+4*i, bank[i]);
+		else
+			wrmsrl(MSR_IA32_MC0_CTL+4*i, ~0UL);
+
 		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
 	}
 }
