Return-Path: <linux-kernel-owner+w=401wt.eu-S1761331AbZEZX72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761331AbZEZX72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbZEZXy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38614 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbZEZXyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:50 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 18/31] x86: MCE: Store record length into memory struct mce anchor
Date: Wed, 27 May 2009 01:54:20 +0200
Message-Id: <7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <b55d8c3d2842ee10f4b06f17cc2658f81b4f7b4e.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
 <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
 <abf61c300dec40b8e93bb5ae7154a0633c682799.1243381848.git.ak@linux.intel.com>
 <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
 <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
 <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>
 <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com>
 <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com>
 <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com>
 <10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com>
 <a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com>
 <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com>
 <b55d8c3d2842ee10f4b06f17cc2658f81b4f7b4e.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This makes it easier for tools who want to extract the mcelog out of
crash images or memory dumps to adapt to changing struct mce size.
The length field replaces padding, so it's fully compatible.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/mce.h       |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 1ff437f..6f45a87 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -59,7 +59,7 @@ struct mce_log {
 	unsigned len;	    /* = MCE_LOG_LEN */
 	unsigned next;
 	unsigned flags;
-	unsigned pad0;
+	unsigned recordlen;	/* length of struct mce */
 	struct mce entry[MCE_LOG_LEN];
 };
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d87f46f..bf9bd6f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -121,8 +121,9 @@ EXPORT_PER_CPU_SYMBOL_GPL(injectm);
  */
 
 static struct mce_log mcelog = {
-	MCE_LOG_SIGNATURE,
-	MCE_LOG_LEN,
+	.signature = MCE_LOG_SIGNATURE,
+	.len = MCE_LOG_LEN,
+	.recordlen = sizeof(struct mce),
 };
 
 void mce_log(struct mce *mce)
-- 
1.6.0.2

