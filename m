Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab0BDTLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:11:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59276 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab0BDTLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:11:18 -0500
Date: Thu, 4 Feb 2010 20:11:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
Subject: [PATCH] HPET: Drop WARN_ON for mismatch on HPET CMP readback
Message-ID: <20100204191112.GA10135@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    HPET: Drop WARN_ON for mismatch on HPET CMP readback
    
    At least one Intel chipset seems to always return a constant value
    when reading back the HPET CMP register. This triggers the WARN_ON_ONCE
    on each boot.
    
    In addition the WARN_ON was buggy: it has a side-effect and
    actually needed code could be optimized out if someone disabled
    CONFIG_BUG.
    
    So far there's no indication that miscompare on reading
    points to actual problem.
    
    So simply drop the WARN_ON_ONCE.
    
    Based on discussions with Thomas Gleixner.
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ad80a1c..18cf7a6 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -394,14 +394,11 @@ static int hpet_next_event(unsigned long delta,
 	 * at that point and we would wait for the next hpet interrupt
 	 * forever. We found out that reading the CMP register back
 	 * forces the transfer so we can rely on the comparison with
-	 * the counter register below. If the read back from the
-	 * compare register does not match the value we programmed
-	 * then we might have a real hardware problem. We can not do
-	 * much about it here, but at least alert the user/admin with
-	 * a prominent warning.
+	 * the counter register below. 
+         * But don't actually check the read-back value. Some Intel chipsets
+	 * return always the same value.
 	 */
-	WARN_ONCE(hpet_readl(HPET_Tn_CMP(timer)) != cnt,
-		  KERN_WARNING "hpet: compare register read back failed.\n");
+	(void)hpet_readl(HPET_Tn_CMP(timer);
 
 	return (s32)(hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
 }
