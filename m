Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYGCSjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYGCSjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 14:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYGCSjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 14:39:13 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:63483 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbYGCSjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:39:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Qyvctl51OZ82zKcmXQNHNVviXshMlTPp2PxfiOXEK+5tADWiI5bOmsLybDA++iKStR
         bl6G8T6n857nFblgsFddVVmL1uvio9E6R8HllUzwlPZjfsgJ1AE7gKLLr1mZFaPpoADT
         uYhFxc9mvlt5srPymGZxF82WWn/zkelbS0Bx4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] x86: let early_reserve_e820 update e820_saved too
Date: Thu, 3 Jul 2008 11:39:00 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807031135.37465.yhlu.kernel@gmail.com>
In-Reply-To: <200807031135.37465.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807031139.00349.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so when it is called after early_param, e820_saved get updated too.
esp for mpc update.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/e820.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -414,8 +414,9 @@ static int __init append_e820_map(struct
 	return __append_e820_map(biosmap, nr_map);
 }
 
-u64 __init e820_update_range(u64 start, u64 size, unsigned old_type,
-				unsigned new_type)
+static u64 __init e820_update_range_map(struct e820map *e820x, u64 start,
+					u64 size, unsigned old_type,
+					unsigned new_type)
 {
 	int i;
 	u64 real_updated_size = 0;
@@ -426,7 +427,7 @@ u64 __init e820_update_range(u64 start,
 		size = ULLONG_MAX - start;
 
 	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
+		struct e820entry *ei = &e820x->map[i];
 		u64 final_start, final_end;
 		if (ei->type != old_type)
 			continue;
@@ -454,6 +455,19 @@ u64 __init e820_update_range(u64 start,
 	return real_updated_size;
 }
 
+u64 __init e820_update_range(u64 start, u64 size, unsigned old_type,
+			     unsigned new_type)
+{
+	return e820_update_range_map(&e820, start, size, old_type, new_type);
+}
+
+static u64 __init e820_update_range_saved(u64 start, u64 size,
+					  unsigned old_type, unsigned new_type)
+{
+	return e820_update_range_map(&e820_saved, start, size, old_type,
+				     new_type);
+}
+
 /* make e820 not cover the range */
 u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
 			     int checktype)
@@ -503,6 +517,15 @@ void __init update_e820(void)
 	printk(KERN_INFO "modified physical RAM map:\n");
 	e820_print_map("modified");
 }
+static void __init update_e820_saved(void)
+{
+	int nr_map;
+
+	nr_map = e820_saved.nr_map;
+	if (sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map), &nr_map))
+		return;
+	e820_saved.nr_map = nr_map;
+}
 #define MAX_GAP_END 0x100000000ull
 /*
  * Search for a gap in the e820 memory space from start_addr to end_addr.
@@ -1007,8 +1030,10 @@ u64 __init early_reserve_e820(u64 startt
 
 	addr = round_down(start + size - sizet, align);
 	e820_update_range(addr, sizet, E820_RAM, E820_RESERVED);
+	e820_update_range_saved(addr, sizet, E820_RAM, E820_RESERVED);
 	printk(KERN_INFO "update e820 for early_reserve_e820\n");
 	update_e820();
+	update_e820_saved();
 
 	return addr;
 }
