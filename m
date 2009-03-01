Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZCADL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZCADL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 22:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbZCADLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 22:11:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:55441 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276AbZCADLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 22:11:48 -0500
Message-ID: <49A9FC9A.2030707@kernel.org>
Date: Sat, 28 Feb 2009 19:10:18 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Kevin O'Connor" <kevin@koconnor.net>
CC: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stefan Reinauer <stepan@coresystems.de>, linux-kernel@vger.kernel.org,
       coreboot@coreboot.org, Jaswinder Singh Rajput <jaswinder@infradead.org>
Subject: Re: MPTable can not be high-memory on Linux
References: <499DB40C.1060205@coresystems.de> <499DCE79.8020809@coresystems.de> <20090222152530.GA30576@morn.localdomain> <200902221806.55429.rjw@sisk.pl> <49A1C4AF.9000009@kernel.org> <20090222223226.GA3346@morn.localdomain> <20090222225847.GB1649@elte.hu> <49A23EE0.8000102@kernel.org> <20090228234127.GA29964@morn.localdomain>
In-Reply-To: <20090228234127.GA29964@morn.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin O'Connor wrote:
> On Sun, Feb 22, 2009 at 10:14:56PM -0800, Yinghai Lu wrote:
>> please check
>>
>> [PATCH] x86: check physptr with max_low_pfn on 32bit
> 
> Thanks for looking at this issue.
> 
> Unfortunately, the kernel still does not work with the applied patch.
> Neither 32bit nor 64bit kernels boot.  (Note, I applied the patch to
> Linus' git, and I had to replace mpf->physptr with mpf->mpf_physptr.)
> 
> The error messages from before and after patching appear to be the
> same.
> 
> 

please add this patch too

[PATCH] x86: ioremap mptable

Impact: fix boot with mptable above max_low_mapped

try to use early_ioremap it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/mpparse.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -611,12 +611,20 @@ static void __init __get_smp_config(unsi
 		construct_default_ISA_mptable(mpf->feature1);
 
 	} else if (mpf->physptr) {
+		struct mpc_table *mpc;
+		unsigned int length;
 
+		mpc = early_ioremap(mpf->physptr, PAGE_SIZE);
+		length = mpc->length;
+		apic_printk(APIC_VERBOSE, "  mpc: %x-%x\n", mpf->physptr,
+			 mpf->physptr + length);
+		early_iounmap(mpc, PAGE_SIZE);
+		mpc = early_ioremap(mpf->physptr, length);
 		/*
 		 * Read the physical hardware table.  Anything here will
 		 * override the defaults.
 		 */
-		if (!smp_read_mpc(phys_to_virt(mpf->physptr), early)) {
+		if (!smp_read_mpc(mpc, early)) {
 #ifdef CONFIG_X86_LOCAL_APIC
 			smp_found_config = 0;
 #endif
@@ -624,9 +632,12 @@ static void __init __get_smp_config(unsi
 			       "BIOS bug, MP table errors detected!...\n");
 			printk(KERN_ERR "... disabling SMP support. "
 			       "(tell your hw vendor)\n");
+			early_iounmap(mpc, length);
 			return;
 		}
 
+		early_iounmap(mpc, length);
+
 		if (early)
 			return;
 #ifdef CONFIG_X86_IO_APIC
