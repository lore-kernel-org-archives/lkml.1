Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbYEFRoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbYEFRoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932704AbYEFRmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:42:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:62099 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbYEFRmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:42:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=gq60Pm4/kGR64SK61tZDehgH2x68ib1NT/69Hb1CKca1e5YDy2Lbm2/iYjknqUvLa5VsE62RojtBFAyuBMzcGxi48lp31gtI2oW2+4Me9vTq1vrMunAbn0ry9QaDMONHas77m5fYclyYJccHXzGPn+9OnX+9ugYiHpWMeSUbzRE=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: fixed mtrr change WP to WB
Date: Tue, 6 May 2008 10:41:39 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200805061038.58023.yhlu.kernel@gmail.com>
In-Reply-To: <200805061038.58023.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805061041.40047.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: fixed mtrr change WP to WB

so we modify mptable near below 1M

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
@@ -192,6 +192,26 @@ void mtrr_save_fixed_ranges(void *info)
 		get_fixed_ranges(mtrr_state.fixed_ranges);
 }
 
+int update_mtrr_fixed_ranges(unsigned char old_type, unsigned char new_type)
+{
+	unsigned char *type;
+	int i;
+	int changed = 0;
+
+	if (!mtrr_state.have_fixed)
+		return 0;
+
+	type = mtrr_state.fixed_ranges;
+	for (i = 0; i < NUM_FIXED_RANGES; i++) {
+		if (type[i] == old_type) {
+			type[i] = new_type;
+			changed = 1;
+		}
+	}
+
+	return changed;
+}
+
 static void print_fixed(unsigned base, unsigned step, const mtrr_type*types)
 {
 	unsigned i;
Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -794,6 +794,24 @@ x86_get_mtrr_mem_range(struct res_range 
 	return nr_range;
 }
 
+extern int __initdata enable_update_mptable;
+
+static int __init fixed_mtrr_cleanup(void)
+{
+	unsigned char new_type;
+
+	if (!enable_update_mptable)
+		return 0;
+
+	/* AMD 0x1e, intel 0x06 */
+	new_type = 0x06;
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
+	    (boot_cpu_data.x86 >= 0x0f && boot_cpu_data.x86 <= 0x11))
+		new_type = 0x1e;
+
+	return update_mtrr_fixed_ranges(0x05, new_type);
+}
+
 static struct res_range __initdata range[RANGE_NUM];
 
 #ifdef CONFIG_MTRR_SANITIZER
@@ -1162,6 +1180,7 @@ static int __init mtrr_cleanup(unsigned 
 	unsigned long range_sums, range_sums_new;
 	int index_good;
 	int num_reg_good;
+	int changed;
 
 	/* extra one for all 0 */
 	int num[MTRR_NUM_TYPES + 1];
@@ -1173,6 +1192,8 @@ static int __init mtrr_cleanup(unsigned 
 	if (def != MTRR_TYPE_UNCACHABLE)
 		return 0;
 
+	changed = fixed_mtrr_cleanup();
+
 	/* get it and store it aside */
 	memset(range_state, 0, sizeof(range_state));
 	for (i = 0; i < num_var_ranges; i++) {
@@ -1196,12 +1217,12 @@ static int __init mtrr_cleanup(unsigned 
 
 	/* check if we got UC entries */
 	if (!num[MTRR_TYPE_UNCACHABLE])
-		return 0;
+		return changed;
 
 	/* check if we only had WB and UC */
 	if (num[MTRR_TYPE_WRBACK] + num[MTRR_TYPE_UNCACHABLE] !=
 		num_var_ranges - num[MTRR_NUM_TYPES])
-		return 0;
+		return changed;
 
 	memset(range, 0, sizeof(range));
 	extra_remove_size = 0;
@@ -1363,12 +1384,12 @@ static int __init mtrr_cleanup(unsigned 
 	printk(KERN_INFO "mtrr_cleanup: can not find optimal value\n");
 	printk(KERN_INFO "please specify mtrr_gran_size/mtrr_chunk_size\n");
 
-	return 0;
+	return changed;
 }
 #else
 static int __init mtrr_cleanup(unsigned address_bits)
 {
-	return 0;
+	return fixed_mtrr_cleanup();
 }
 #endif
 
Index: linux-2.6/arch/x86/kernel/cpu/mtrr/mtrr.h
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -83,6 +83,7 @@ void set_mtrr_prepare_save(struct set_mt
 
 void fill_mtrr_var_range(unsigned int index,
 		u32 base_lo, u32 base_hi, u32 mask_lo, u32 mask_hi);
+int update_mtrr_fixed_ranges(unsigned char old_type, unsigned char new_type);
 void get_mtrr_state(void);
 
 extern void set_mtrr_ops(struct mtrr_ops * ops);
