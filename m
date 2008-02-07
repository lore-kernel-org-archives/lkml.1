Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYBGIDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYBGIDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 03:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYBGIDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 03:03:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47626 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbYBGIDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:03:04 -0500
Date: Thu, 7 Feb 2008 09:02:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balaji Rao <balajirrao@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       jesse.barnes@intel.com, yhlu.kernel@gmail.com, ak@suse.de,
       Yinghai Lu <yinghai.lu@sun.com>
Subject: Re: [PATCH][Regression] x86, 32-bit: trim memory not covered by wb
	mtrrs - FIX
Message-ID: <20080207080245.GA28631@elte.hu>
References: <200802071257.51893.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802071257.51893.balajirrao@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Balaji Rao <balajirrao@gmail.com> wrote:

> Hello,
> 
> The following commit caused my X server to stop working.
> 
> commit 99fc8d424bc5d803fe92cad56c068fe64e73747a
> Author: Jesse Barnes <jesse.barnes@intel.com>
> Date:   Wed Jan 30 13:33:18 2008 +0100
> 
>     x86, 32-bit: trim memory not covered by wb mtrrs
> 
> This patch fixes the improper handling of addresses > 4G by 
> mtrr_trim_uncached_memory. This, now brings up X on my system.

thanks. Incidentally this same bug was reported and fixed yesterday, and 
that fix is upstream already. Could you please compare your solution to 
Yinghai Lu's fix below, and send us a patch for any further improvements 
(or cleanups) you might notice in that code? It seems to be almost the 
same fix as yours. (and hopefully it fixes your X problem too)

	Ingo

------------------>
commit 20651af9ac60fd6e31360688ad44861a7d05256a
Author: Yinghai Lu <yinghai.lu@sun.com>
Date:   Wed Feb 6 22:39:45 2008 +0100

    x86: fix mttr trimming
    
    Pavel Emelyanov reported that his networking card did not work
    and bisected it down to:
    
    "
    The commit
    
      093af8d7f0ba3c6be1485973508584ef081e9f93
      x86_32: trim memory by updating e820
    
    broke my e1000 card: on loading driver says that
    
      e1000: probe of 0000:04:03.0 failed with error -5
    
    and the interface doesn't appear.
    "
    
    on a 32-bit kernel, base will overflow when try to do PAGE_SHIFT,
    and highest_addr will always less 4G.
    
    So use pfn instead of address to avoid the overflow when more than
    4g RAM is installed on a 32-bit kernel.
    
    Many thanks to Pavel Emelyanov for reporting and testing it.
    
    Bisected-by: Pavel Emelyanov <xemul@openvz.org>
    Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
    Tested-by: Pavel Emelyanov <xemul@openvz.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 1e27b69..b6e136f 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -659,7 +659,7 @@ static __init int amd_special_default_mtrr(void)
  */
 int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 {
-	unsigned long i, base, size, highest_addr = 0, def, dummy;
+	unsigned long i, base, size, highest_pfn = 0, def, dummy;
 	mtrr_type type;
 	u64 trim_start, trim_size;
 
@@ -682,28 +682,27 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 		mtrr_if->get(i, &base, &size, &type);
 		if (type != MTRR_TYPE_WRBACK)
 			continue;
-		base <<= PAGE_SHIFT;
-		size <<= PAGE_SHIFT;
-		if (highest_addr < base + size)
-			highest_addr = base + size;
+		if (highest_pfn < base + size)
+			highest_pfn = base + size;
 	}
 
 	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
-	if (!highest_addr) {
+	if (!highest_pfn) {
 		printk(KERN_WARNING "WARNING: strange, CPU MTRRs all blank?\n");
 		WARN_ON(1);
 		return 0;
 	}
 
-	if ((highest_addr >> PAGE_SHIFT) < end_pfn) {
+	if (highest_pfn < end_pfn) {
 		printk(KERN_WARNING "WARNING: BIOS bug: CPU MTRRs don't cover"
-			" all of memory, losing %LdMB of RAM.\n",
-			(((u64)end_pfn << PAGE_SHIFT) - highest_addr) >> 20);
+			" all of memory, losing %luMB of RAM.\n",
+			(end_pfn - highest_pfn) >> (20 - PAGE_SHIFT));
 
 		WARN_ON(1);
 
 		printk(KERN_INFO "update e820 for mtrr\n");
-		trim_start = highest_addr;
+		trim_start = highest_pfn;
+		trim_start <<= PAGE_SHIFT;
 		trim_size = end_pfn;
 		trim_size <<= PAGE_SHIFT;
 		trim_size -= trim_start;
