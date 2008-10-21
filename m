Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYJUUBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYJUUBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbYJUUBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:01:30 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50771 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752020AbYJUUB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:01:29 -0400
Date: Tue, 21 Oct 2008 15:01:28 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Cc: Russ Anderson <rja@sgi.com>
Subject: [PATCH 3/3] x86: Add UV reserved page bios call
Message-ID: <20081021200128.GE32545@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add UV bios call to get the address of the reserved page.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 arch/x86/kernel/bios_uv.c |   11 +++++++++++
 include/asm-x86/uv/bios.h |    5 ++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/bios_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/bios_uv.c	2008-10-21 14:55:24.000000000 -0500
+++ linux/arch/x86/kernel/bios_uv.c	2008-10-21 14:55:27.000000000 -0500
@@ -142,6 +142,17 @@ uv_bios_change_memprotect(u64 paddr, u64
 }
 EXPORT_SYMBOL_GPL(uv_bios_change_memprotect);
 
+s64
+uv_bios_reserved_page_pa(u64 buf, u64 *cookie, u64 *addr, u64 *len)
+{
+	s64 ret;
+
+	ret = uv_bios_call_irqsave(UV_BIOS_GET_PARTITION_ADDR, (u64)cookie,
+					(u64)addr, buf, (u64)len, 0);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(uv_bios_reserved_page_pa);
+
 s64 uv_bios_freq_base(u64 clock_type, u64 *ticks_per_second)
 {
 	return uv_bios_call(UV_BIOS_FREQ_BASE, clock_type,
Index: linux/include/asm-x86/uv/bios.h
===================================================================
--- linux.orig/include/asm-x86/uv/bios.h	2008-10-21 14:55:24.000000000 -0500
+++ linux/include/asm-x86/uv/bios.h	2008-10-21 14:55:27.000000000 -0500
@@ -35,13 +35,15 @@ enum uv_bios_cmd {
 	UV_BIOS_FREQ_BASE,
 	UV_BIOS_WATCHLIST_ALLOC,
 	UV_BIOS_WATCHLIST_FREE,
-	UV_BIOS_MEMPROTECT
+	UV_BIOS_MEMPROTECT,
+	UV_BIOS_GET_PARTITION_ADDR
 };
 
 /*
  * Status values returned from a BIOS call.
  */
 enum {
+	BIOS_STATUS_MORE_PASSES		=  1,
 	BIOS_STATUS_SUCCESS		=  0,
 	BIOS_STATUS_UNIMPLEMENTED	= -ENOSYS,
 	BIOS_STATUS_EINVAL		= -EINVAL,
@@ -102,6 +104,7 @@ extern int uv_bios_mq_watchlist_alloc(in
 					unsigned long *);
 extern int uv_bios_mq_watchlist_free(int, int);
 extern s64 uv_bios_change_memprotect(u64, u64, enum uv_memprotect);
+extern s64 uv_bios_reserved_page_pa(u64, u64 *, u64 *, u64 *);
 
 extern void uv_bios_init(void);
 
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
