Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYJUVUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYJUVUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYJUVUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:20:33 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59016 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752466AbYJUVUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:20:32 -0400
Date: Tue, 21 Oct 2008 16:20:31 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Cc: Dimitri Sivanich <sivanich@sgi.com>
Subject: [PATCH 2/3] SGI RTC: add bios framework for RTC timer operations
Message-ID: <20081021212031.GB4037@sgi.com>
References: <20081021211740.GA3936@sgi.com> <20081021211921.GA4037@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021211921.GA4037@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a bios call framework for implementing SGI RTC timer
functions.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

Index: linux/arch/x86/kernel/bios_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/bios_uv.c	2008-10-21 12:09:46.000000000 -0500
+++ linux/arch/x86/kernel/bios_uv.c	2008-10-21 12:10:46.000000000 -0500
@@ -160,6 +160,66 @@ s64 uv_bios_freq_base(u64 clock_type, u6
 }
 EXPORT_SYMBOL_GPL(uv_bios_freq_base);
 
+int uv_bios_rtct(enum uv_bios_rtct_cmd which, void *a1, void *a2, void *a3,
+			void *a4, void *a5)
+{
+	int rc = 0;
+
+	switch (which) {
+	case UV_RTC_MASK:
+		rc = uv_bios_call(UV_BIOS_RTC_MASK, (u64)a1, 0, 0, 0, 0);
+		break;
+	case UV_RTC_READ:
+		rc = uv_bios_call(UV_BIOS_RTC_READ, (u64)a1, 0, 0, 0, 0);
+		break;
+	case UV_RTC_EVT_INIT:
+		rc = uv_bios_call(UV_BIOS_RTC_EVT_INIT, (u64)a1, (u64)a2,
+				(u64)a3, (u64)a4, (u64)a5);
+		break;
+	case UV_RTC_EVT_SET:
+		{
+		u64 apicid = per_cpu(x86_cpu_to_apicid, *(int *)a1);
+		rc = uv_bios_call(UV_BIOS_RTC_EVT_SET, apicid, (u64)a2, 0, 0,
+				0);
+		}
+		break;
+	case UV_RTC_EVT_UNSET:
+		{
+		u64 apicid = per_cpu(x86_cpu_to_apicid, *(int *)a1);
+		rc = uv_bios_call(UV_BIOS_RTC_EVT_UNSET, apicid, 0, 0, 0, 0);
+		}
+		break;
+	case UV_RTC_EVT_ACK:
+		{
+		u64 apicid = per_cpu(x86_cpu_to_apicid, *(int *)a1);
+		rc = uv_bios_call(UV_BIOS_RTC_EVT_ACK, apicid, 0, 0, 0, 0);
+		}
+		break;
+	case UV_RTC_EVT_START:
+		{
+		u64 apicid = per_cpu(x86_cpu_to_apicid, *(int *)a1);
+		rc = uv_bios_call(UV_BIOS_RTC_EVT_START, apicid, 0, 0, 0, 0);
+		}
+		break;
+	case UV_RTC_EVT_STOP:
+		{
+		u64 apicid = per_cpu(x86_cpu_to_apicid, *(int *)a1);
+		rc = uv_bios_call(UV_BIOS_RTC_EVT_STOP, apicid, 0, 0, 0, 0);
+		}
+		break;
+	case UV_RTC_EVT_RESUME:
+		{
+		u64 apicid = per_cpu(x86_cpu_to_apicid, *(int *)a1);
+		rc = uv_bios_call(UV_BIOS_RTC_EVT_RESUME, apicid, 0, 0, 0, 0);
+		}
+		break;
+	default:
+		rc = -1;
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(uv_bios_rtct);
 
 #ifdef CONFIG_EFI
 void uv_bios_init(void)
Index: linux/include/asm-x86/uv/bios.h
===================================================================
--- linux.orig/include/asm-x86/uv/bios.h	2008-10-21 12:09:46.000000000 -0500
+++ linux/include/asm-x86/uv/bios.h	2008-10-21 12:10:46.000000000 -0500
@@ -36,7 +36,16 @@ enum uv_bios_cmd {
 	UV_BIOS_WATCHLIST_ALLOC,
 	UV_BIOS_WATCHLIST_FREE,
 	UV_BIOS_MEMPROTECT,
-	UV_BIOS_GET_PARTITION_ADDR
+	UV_BIOS_GET_PARTITION_ADDR,
+	UV_BIOS_RTC_MASK,
+	UV_BIOS_RTC_READ,
+	UV_BIOS_RTC_EVT_INIT,
+	UV_BIOS_RTC_EVT_SET,
+	UV_BIOS_RTC_EVT_UNSET,
+	UV_BIOS_RTC_EVT_ACK,
+	UV_BIOS_RTC_EVT_START,
+	UV_BIOS_RTC_EVT_STOP,
+	UV_BIOS_RTC_EVT_RESUME
 };
 
 /*
@@ -66,6 +75,22 @@ enum {
 	BIOS_FREQ_BASE_REALTIME_CLOCK = 2
 };
 
+/*
+ * Values for the BIOS rtct calls.  It is passed as the first argument
+ * in the uv_bios_rtct call.
+ */
+enum uv_bios_rtct_cmd {
+	UV_RTC_MASK,
+	UV_RTC_READ,
+	UV_RTC_EVT_INIT,
+	UV_RTC_EVT_SET,
+	UV_RTC_EVT_UNSET,
+	UV_RTC_EVT_ACK,
+	UV_RTC_EVT_START,
+	UV_RTC_EVT_STOP,
+	UV_RTC_EVT_RESUME
+};
+
 union partition_info_u {
 	u64	val;
 	struct {
@@ -106,6 +131,9 @@ extern int uv_bios_mq_watchlist_free(int
 extern s64 uv_bios_change_memprotect(u64, u64, enum uv_memprotect);
 extern s64 uv_bios_reserved_page_pa(u64, u64 *, u64 *, u64 *);
 
+extern int uv_bios_rtct(enum uv_bios_rtct_cmd, void *, void *, void *,
+					void *, void *);
+
 extern void uv_bios_init(void);
 
 extern unsigned long sn_rtc_cycles_per_second;
