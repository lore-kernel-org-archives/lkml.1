Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbYFSUou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbYFSUou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 16:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYFSUom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 16:44:42 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50780 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbYFSUol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 16:44:41 -0400
Subject: mce_64.c: mce_cpu_quirks being ignored
From: Max Asbock <masbock@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: venkatesh.pallipadi@intel.com, andi@firstfloor.org
Content-Type: text/plain
Date: Thu, 19 Jun 2008 13:44:36 -0700
Message-Id: <1213908276.5942.16.camel@w-amax.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent change to mce_init in -mm does the following:

@@ -462,7 +463,7 @@ static void mce_init(void *dummy)
 		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
 
 	for (i = 0; i < banks; i++) {
-		wrmsrl(MSR_IA32_MC0_CTL+4*i, bank[i]);
+		wrmsrl(MSR_IA32_MC0_CTL+4*i, ~0UL);
 		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
 	}
....
 
This change appears to ignore the fact that mce_cpu_quirks() clears a
bit in bank[4] for certain CPUs, as in:

static void __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
{
        /* This should be disabled by the BIOS, but isn't always */
        if (c->x86_vendor == X86_VENDOR_AMD) {
                if(c->x86 == 15)
                        /* disable GART TBL walk error reporting, which trips off
                           incorrectly with the IOMMU & 3ware & Cerberus. */
                        clear_bit(10, &bank[4]);
....

Is turning off that bit still needed?

Max


