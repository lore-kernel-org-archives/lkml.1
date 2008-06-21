Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYFUVrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYFUVrj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 17:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbYFUVrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 17:47:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:64944 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbYFUVrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 17:47:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=KLOmtPIrCsihF5UTrVhVaSRWi2/SHcLLrm9pfufl6Dvcc6v+kFkpCsrZH1iLlYMbSi
         J2kUwCVAfVl8pXOZZGycQNR1wI3wKQJatUFZ/uK3y8mm3CE4l6Zq73Sjp6CUrp/tsA0l
         N7v7CWt7hwQD7+lrLZrvCFYk/SaiYO4RFKbd8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: add e820_remove_range
Date: Sat, 21 Jun 2008 14:48:05 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806211443.39735.yhlu.kernel@gmail.com>
In-Reply-To: <200806211443.39735.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806211448.05690.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so could add real hole in e820
agp check is using request_mem_region. and could fail if e820 reserved...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/aperture_64.c |    4 ++--
 arch/x86/kernel/e820.c        |   35 +++++++++++++++++++++++++++++++++++
 include/asm-x86/e820.h        |    2 ++
 3 files changed, 39 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -429,6 +429,41 @@ u64 __init e820_update_range(u64 start, 
 	return real_updated_size;
 }
 
+/* make e820 not cover the range */
+u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
+			     int checktype)
+{
+	int i;
+	u64 real_removed_size = 0;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		u64 final_start, final_end;
+
+		if (checktype && ei->type != old_type)
+			continue;
+		/* totally covered? */
+		if (ei->addr >= start &&
+		    (ei->addr + ei->size) <= (start + size)) {
+			real_removed_size += ei->size;
+			memset(ei, 0, sizeof(struct e820entry));
+			continue;
+		}
+		/* partially covered */
+		final_start = max(start, ei->addr);
+		final_end = min(start + size, ei->addr + ei->size);
+		if (final_start >= final_end)
+			continue;
+		real_removed_size += final_end - final_start;
+
+		ei->size -= final_end - final_start;
+		if (ei->addr < final_start)
+			continue;
+		ei->addr = final_end;
+	}
+	return real_removed_size;
+}
+
 void __init update_e820(void)
 {
 	int nr_map;
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -67,6 +67,8 @@ sanitize_e820_map(struct e820entry *bios
 extern int copy_e820_map(struct e820entry *biosmap, int nr_map);
 extern u64 e820_update_range(u64 start, u64 size, unsigned old_type,
 			       unsigned new_type);
+extern u64 e820_remove_range(u64 start, u64 size, unsigned old_type,
+			     int checktype);
 extern void update_e820(void);
 extern void e820_setup_gap(void);
 struct setup_data;
Index: linux-2.6/arch/x86/kernel/aperture_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/aperture_64.c
+++ linux-2.6/arch/x86/kernel/aperture_64.c
@@ -326,9 +326,9 @@ void __init early_gart_iommu_check(void)
 	if (gart_fix_e820 && !fix && aper_enabled) {
 		if (e820_any_mapped(aper_base, aper_base + aper_size,
 				    E820_RAM)) {
-			/* reserve it, so we can reuse it in second kernel */
+			/* remove it, so we can reuse it in second kernel */
 			printk(KERN_INFO "update e820 for GART\n");
-			e820_add_region(aper_base, aper_size, E820_RESERVED);
+			e820_remove_range(aper_base, aper_size, E820_RAM, 1);
 			update_e820();
 		}
 	}
