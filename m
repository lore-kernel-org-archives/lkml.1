Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYGCSix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYGCSix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 14:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbYGCSio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 14:38:44 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:63483 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbYGCSin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:38:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=uXxkezRA3JfIrQUfxRIR3Q0SCFfOc/UybmixjQ5uIINb6IvSTo3iMp35pRVRa6Plab
         W8/QMaD9TcbBIlQzL8loHihD0mF0NhpzJr71vHvQn7oJ796/GqGyfw6wB2mcLMkMnrPL
         JjkiwEydyehtmV5Mr4603wvy2Hc+bzm50GInA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Bernhard Walle <bwalle@suse.de>,
       Ying Huang <ying.huang@intel.com>
Subject: [PATCH] x86: make e820_saved have update from setup_data
Date: Thu, 3 Jul 2008 11:37:13 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807031135.37465.yhlu.kernel@gmail.com>
In-Reply-To: <200807031135.37465.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807031137.13984.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


seperate reserve_setup_data into e820_reserved_setup_data,
and reserve_early_setup_data.

So could use e820_reserved_setup_data to backup e820 with setup_data

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -394,11 +394,10 @@ static void __init parse_setup_data(void
 	}
 }
 
-static void __init reserve_setup_data(void)
+static void __init e820_reserve_setup_data(void)
 {
 	struct setup_data *data;
 	u64 pa_data;
-	char buf[32];
 	int found = 0;
 
 	if (boot_params.hdr.version < 0x0209)
@@ -406,8 +405,6 @@ static void __init reserve_setup_data(vo
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
 		data = early_ioremap(pa_data, sizeof(*data));
-		sprintf(buf, "setup data %x", data->type);
-		reserve_early(pa_data, pa_data+sizeof(*data)+data->len, buf);
 		e820_update_range(pa_data, sizeof(*data)+data->len,
 			 E820_RAM, E820_RESERVED_KERN);
 		found = 1;
@@ -418,10 +415,29 @@ static void __init reserve_setup_data(vo
 		return;
 
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	memcpy(&e820_saved, &e820, sizeof(struct e820map));
 	printk(KERN_INFO "extended physical RAM map:\n");
 	e820_print_map("reserve setup_data");
 }
 
+static void __init reserve_early_setup_data(void)
+{
+	struct setup_data *data;
+	u64 pa_data;
+	char buf[32];
+
+	if (boot_params.hdr.version < 0x0209)
+		return;
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = early_ioremap(pa_data, sizeof(*data));
+		sprintf(buf, "setup data %x", data->type);
+		reserve_early(pa_data, pa_data+sizeof(*data)+data->len, buf);
+		pa_data = data->next;
+		early_iounmap(data, sizeof(*data));
+	}
+}
+
 /*
  * --------- Crashkernel reservation ------------------------------
  */
@@ -626,6 +642,8 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_memory_map();
 	parse_setup_data();
+	/* update the e820_saved too */
+	e820_reserve_setup_data();
 
 	copy_edd();
 
@@ -656,7 +674,7 @@ void __init setup_arch(char **cmdline_p)
 	parse_early_param();
 
 	/* after early param, so could get panic from serial */
-	reserve_setup_data();
+	reserve_early_setup_data();
 
 	if (acpi_mps_check()) {
 #ifdef CONFIG_X86_LOCAL_APIC
