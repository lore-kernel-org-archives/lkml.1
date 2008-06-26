Return-Path: <linux-kernel-owner+w=401wt.eu-S1759040AbYFZBFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040AbYFZBFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbYFZBBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:01:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:3760 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654AbYFZBBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:01:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ne+1EKo8itp1spVQoiP5SCTIKZIJ732ph5rUVlPrM89E9VKqwvXNMsQjdxQNg2VSEg
         i8oLf/xau99Ra7GB5az7XrTWL4z+3DJPaufYkY+24FKHF/oj/EDA6ScU2Bdr7uSlcGOC
         8qyi6YlbbLkZmCKtpCZErAgUeDokHrmFttxOs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 10/16] x86: move parse_setup_data back to setup.c
Date: Wed, 25 Jun 2008 17:56:22 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com>
In-Reply-To: <200806251748.06743.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251756.22446.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup.c        |   25 +++++++++++++++++++++++++
 arch/x86/kernel/setup_percpu.c |   25 -------------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -371,6 +371,31 @@ static void __init reserve_initrd(void)
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
 
+void __init parse_setup_data(void)
+{
+	struct setup_data *data;
+	u64 pa_data;
+
+	if (boot_params.hdr.version < 0x0209)
+		return;
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = early_ioremap(pa_data, PAGE_SIZE);
+		switch (data->type) {
+		case SETUP_E820_EXT:
+			parse_e820_ext(data, pa_data);
+			break;
+		default:
+			break;
+		}
+#ifndef CONFIG_DEBUG_BOOT_PARAMS
+		free_early(pa_data, pa_data+sizeof(*data)+data->len);
+#endif
+		pa_data = data->next;
+		early_iounmap(data, PAGE_SIZE);
+	}
+}
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6/arch/x86/kernel/setup_percpu.c
@@ -214,31 +214,6 @@ void __init setup_per_cpu_areas(void)
 
 #endif
 
-void __init parse_setup_data(void)
-{
-	struct setup_data *data;
-	u64 pa_data;
-
-	if (boot_params.hdr.version < 0x0209)
-		return;
-	pa_data = boot_params.hdr.setup_data;
-	while (pa_data) {
-		data = early_ioremap(pa_data, PAGE_SIZE);
-		switch (data->type) {
-		case SETUP_E820_EXT:
-			parse_e820_ext(data, pa_data);
-			break;
-		default:
-			break;
-		}
-#ifndef CONFIG_DEBUG_BOOT_PARAMS
-		free_early(pa_data, pa_data+sizeof(*data)+data->len);
-#endif
-		pa_data = data->next;
-		early_iounmap(data, PAGE_SIZE);
-	}
-}
-
 #ifdef X86_64_NUMA
 
 /*
