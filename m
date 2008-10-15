Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYJOUO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYJOUO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbYJOUOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:14:22 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51983 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756136AbYJOUOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:14:20 -0400
Date: Wed, 15 Oct 2008 15:14:19 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Cc: Russ Anderson <rja@sgi.com>, Huang Ying <ying.huang@intel.com>,
       Jack Steiner <steiner@sgi.com>
Subject: [PATCH 6/7] x86: Add UV memory protection bios call
Message-ID: <20081015201419.GG197213@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 6/7] x86: Add UV memory protection bios call

Call to change memory protections on UV.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 arch/x86/kernel/bios_uv.c |    8 ++++++++
 include/asm-x86/uv/bios.h |   10 +++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/bios_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/bios_uv.c	2008-10-15 09:56:28.000000000 -0500
+++ linux/arch/x86/kernel/bios_uv.c	2008-10-15 09:56:29.000000000 -0500
@@ -134,6 +134,14 @@ uv_bios_mq_watchlist_free(int blade, int
 }
 EXPORT_SYMBOL_GPL(uv_bios_mq_watchlist_free);
 
+s64
+uv_bios_change_memprotect(u64 paddr, u64 len, enum uv_memprotect perms)
+{
+	return uv_bios_call_irqsave(UV_BIOS_MEMPROTECT, paddr, len,
+					perms, 0, 0);
+}
+EXPORT_SYMBOL_GPL(uv_bios_change_memprotect);
+
 s64 uv_bios_freq_base(u64 clock_type, u64 *ticks_per_second)
 {
 	return uv_bios_call(UV_BIOS_FREQ_BASE, clock_type,
Index: linux/include/asm-x86/uv/bios.h
===================================================================
--- linux.orig/include/asm-x86/uv/bios.h	2008-10-15 09:56:28.000000000 -0500
+++ linux/include/asm-x86/uv/bios.h	2008-10-15 09:56:29.000000000 -0500
@@ -34,7 +34,8 @@ enum uv_bios_cmd {
 	UV_BIOS_GET_SN_INFO,
 	UV_BIOS_FREQ_BASE,
 	UV_BIOS_WATCHLIST_ALLOC,
-	UV_BIOS_WATCHLIST_FREE
+	UV_BIOS_WATCHLIST_FREE,
+	UV_BIOS_MEMPROTECT
 };
 
 /*
@@ -82,6 +83,12 @@ union uv_watchlist_u {
 	};
 };
 
+enum uv_memprotect {
+	UV_MEMPROT_RESTRICT_ACCESS,
+	UV_MEMPROT_ALLOW_AMO,
+	UV_MEMPROT_ALLOW_RW
+};
+
 /*
  * bios calls have 6 parameters
  */
@@ -94,6 +101,7 @@ extern s64 uv_bios_freq_base(u64, u64 *)
 extern int uv_bios_mq_watchlist_alloc(int, void *, unsigned int,
 					unsigned long *);
 extern int uv_bios_mq_watchlist_free(int, int);
+extern s64 uv_bios_change_memprotect(u64, u64, enum uv_memprotect);
 
 extern void uv_bios_init(void);
 
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
