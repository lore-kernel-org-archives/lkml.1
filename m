Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbYJUUA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbYJUUA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYJUUAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:00:48 -0400
Received: from relay1.sgi.com ([192.48.171.29]:39296 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752219AbYJUUAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:00:47 -0400
Date: Tue, 21 Oct 2008 15:00:46 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Cc: Russ Anderson <rja@sgi.com>
Subject: [PATCH 1/3] x86: Add UV watchlist bios call
Message-ID: <20081021200046.GC32545@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add UV bios calls to allocate and free watchlists.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 arch/x86/kernel/bios_uv.c |   33 +++++++++++++++++++++++++++++++++
 include/asm-x86/uv/bios.h |   17 ++++++++++++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/bios_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/bios_uv.c	2008-10-21 14:55:17.000000000 -0500
+++ linux/arch/x86/kernel/bios_uv.c	2008-10-21 14:55:18.000000000 -0500
@@ -100,6 +100,39 @@ s64 uv_bios_get_sn_info(int fc, int *uvt
 	return ret;
 }
 
+int
+uv_bios_mq_watchlist_alloc(int blade, void *mq, unsigned int mq_size,
+			   unsigned long *intr_mmr_offset)
+{
+	union uv_watchlist_u size_blade;
+	unsigned long addr;
+	u64 watchlist;
+	s64 ret;
+
+	addr = (unsigned long)mq;
+	size_blade.size = mq_size;
+	size_blade.blade = blade;
+
+	/*
+	 * bios returns watchlist number or negative error number.
+	 */
+	ret = (int)uv_bios_call_irqsave(UV_BIOS_WATCHLIST_ALLOC, addr,
+			size_blade.val, (u64)intr_mmr_offset,
+			(u64)&watchlist, 0);
+	if (ret < BIOS_STATUS_SUCCESS)
+		return ret;
+
+	return watchlist;
+}
+EXPORT_SYMBOL_GPL(uv_bios_mq_watchlist_alloc);
+
+int
+uv_bios_mq_watchlist_free(int blade, int watchlist_num)
+{
+	return (int)uv_bios_call_irqsave(UV_BIOS_WATCHLIST_FREE,
+				blade, watchlist_num, 0, 0, 0);
+}
+EXPORT_SYMBOL_GPL(uv_bios_mq_watchlist_free);
 
 s64 uv_bios_freq_base(u64 clock_type, u64 *ticks_per_second)
 {
Index: linux/include/asm-x86/uv/bios.h
===================================================================
--- linux.orig/include/asm-x86/uv/bios.h	2008-10-21 14:55:17.000000000 -0500
+++ linux/include/asm-x86/uv/bios.h	2008-10-21 14:55:18.000000000 -0500
@@ -32,7 +32,9 @@
 enum uv_bios_cmd {
 	UV_BIOS_COMMON,
 	UV_BIOS_GET_SN_INFO,
-	UV_BIOS_FREQ_BASE
+	UV_BIOS_FREQ_BASE,
+	UV_BIOS_WATCHLIST_ALLOC,
+	UV_BIOS_WATCHLIST_FREE
 };
 
 /*
@@ -71,6 +73,15 @@ union partition_info_u {
 	};
 };
 
+union uv_watchlist_u {
+	u64	val;
+	struct {
+		u64	blade	: 16,
+			size	: 32,
+			filler	: 16;
+	};
+};
+
 /*
  * bios calls have 6 parameters
  */
@@ -80,9 +91,13 @@ extern s64 uv_bios_call_reentrant(enum u
 
 extern s64 uv_bios_get_sn_info(int, int *, long *, long *, long *);
 extern s64 uv_bios_freq_base(u64, u64 *);
+extern int uv_bios_mq_watchlist_alloc(int, void *, unsigned int,
+					unsigned long *);
+extern int uv_bios_mq_watchlist_free(int, int);
 
 extern void uv_bios_init(void);
 
+extern unsigned long sn_rtc_cycles_per_second;
 extern int uv_type;
 extern long sn_partition_id;
 extern long sn_coherency_id;
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
