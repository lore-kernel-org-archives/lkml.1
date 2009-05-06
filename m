Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbZEFRIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbZEFRIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 13:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758627AbZEFRIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 13:08:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:38626 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbZEFRIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 13:08:37 -0400
Message-ID: <4A01C3BB.1000609@kernel.org>
Date: Wed, 06 May 2009 10:07:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [PATCH 3/7] x86: fix alloc_mptable
References: <4A01C35C.7060207@kernel.org>
In-Reply-To: <4A01C35C.7060207@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the condition checking.

[ Impact: make alloc_mptable working ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/mpparse.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -873,21 +873,24 @@ inline void __init check_irq_src(struct
 static int check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length,
 		      int count)
 {
+	int ret = 0;
+
 	if (!mpc_new_phys) {
-		pr_info("No spare slots, try to append...take your risk, "
+		pr_warning("No spare slots, try to append...take your risk, "
 			"new mpc_length %x\n", count);
 	} else {
-		if (count <= mpc_new_length)
+		if (count <= mpc_new_length) {
 			pr_info("No spare slots, try to append..., "
 				"new mpc_length %x\n", count);
-		else {
+			ret = 1;
+		} else {
 			pr_err("mpc_new_length %lx is too small\n",
 				mpc_new_length);
-			return -1;
+			ret = -1;
 		}
 	}
 
-	return 0;
+	return ret;
 }
 
 static int  __init replace_intsrc_all(struct mpc_table *mpc,
@@ -946,7 +949,7 @@ static int  __init replace_intsrc_all(st
 		} else {
 			struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
 			count += sizeof(struct mpc_intsrc);
-			if (!check_slot(mpc_new_phys, mpc_new_length, count))
+			if (check_slot(mpc_new_phys, mpc_new_length, count) < 0)
 				goto out;
 			assign_to_mpc_intsrc(&mp_irqs[i], m);
 			mpc->length = count;
