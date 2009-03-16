Return-Path: <linux-kernel-owner+w=401wt.eu-S1759279AbZCPXg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbZCPXg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 19:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbZCPXgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 19:36:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:39323 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbZCPXgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 19:36:14 -0400
Message-ID: <49BEE1E7.7020706@kernel.org>
Date: Mon, 16 Mar 2009 16:33:59 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org,
       =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
Subject: [PATCH] x86: workaround system with stange var MTRR -v2
References: <49BE58BA.1000907@pardus.org.tr> <86802c440903161121s3ba18abaiaa3ccf6847e0eafe@mail.gmail.com> <49BEB3C9.8070705@pardus.org.tr> <49BECBF4.1000508@kernel.org> <49BED5D5.2000801@pardus.org.tr>
In-Reply-To: <49BED5D5.2000801@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: don't trim e820 according to wrong mtrr

Ozan report his branded server emit strange warning.
it turns out MTRR is some wrong.

Ignore those strange range, and don't trim e820. just emit one warning about
BIOS

Reported-by: Ozan Çağlayan <ozan@pardus.org.tr>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/mtrr/cleanup.c |   11 +++++++++++
 arch/x86/kernel/cpu/mtrr/main.c    |   16 ++++++++--------
 arch/x86/kernel/cpu/mtrr/mtrr.h    |    1 +
 3 files changed, 20 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/cleanup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -189,6 +189,17 @@ x86_get_mtrr_mem_range(struct res_range
 		if (!size)
 			continue;
 		base = range_state[i].base_pfn;
+		if (base < (1<<(20-PAGE_SHIFT)) && mtrr_state.have_fixed &&
+		    (mtrr_state.enabled & 1)) {
+			/* var MTRR contain UC below 1M ?  skip it*/
+			printk(KERN_WARNING "WARNING: BIOS bug: VAR MTRR "
+				"contains strange UC entry under 1M, check "
+				"with your system vendor!\n");
+			if (base + size <= (1<<(20-PAGE_SHIFT)))
+				continue;
+			size -= (1<<(20-PAGE_SHIFT)) - base;
+			base = 1<<(20-PAGE_SHIFT);
+		}
 		subtract_range(range, base, base + size - 1);
 	}
 	if (extra_remove_size)
Index: linux-2.6/arch/x86/kernel/cpu/mtrr/mtrr.h
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -79,6 +79,7 @@ extern struct mtrr_ops * mtrr_if;
 
 extern unsigned int num_var_ranges;
 extern u64 mtrr_tom2;
+extern struct mtrr_state_type mtrr_state;
 
 void mtrr_state_warn(void);
 const char *mtrr_attrib_to_str(int x);
Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -574,7 +574,7 @@ struct mtrr_value {
 	unsigned long	lsize;
 };
 
-static struct mtrr_value mtrr_state[MTRR_MAX_VAR_RANGES];
+static struct mtrr_value mtrr_value[MTRR_MAX_VAR_RANGES];
 
 static int mtrr_save(struct sys_device * sysdev, pm_message_t state)
 {
@@ -582,9 +582,9 @@ static int mtrr_save(struct sys_device *
 
 	for (i = 0; i < num_var_ranges; i++) {
 		mtrr_if->get(i,
-			     &mtrr_state[i].lbase,
-			     &mtrr_state[i].lsize,
-			     &mtrr_state[i].ltype);
+			     &mtrr_value[i].lbase,
+			     &mtrr_value[i].lsize,
+			     &mtrr_value[i].ltype);
 	}
 	return 0;
 }
@@ -594,11 +594,11 @@ static int mtrr_restore(struct sys_devic
 	int i;
 
 	for (i = 0; i < num_var_ranges; i++) {
-		if (mtrr_state[i].lsize) 
+		if (mtrr_value[i].lsize)
 			set_mtrr(i,
-				 mtrr_state[i].lbase,
-				 mtrr_state[i].lsize,
-				 mtrr_state[i].ltype);
+				 mtrr_value[i].lbase,
+				 mtrr_value[i].lsize,
+				 mtrr_value[i].ltype);
 	}
 	return 0;
 }
