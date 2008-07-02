Return-Path: <linux-kernel-owner+w=401wt.eu-S1762324AbYGBDDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762324AbYGBDDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 23:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759697AbYGBDCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 23:02:46 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:57589 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759520AbYGBDCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 23:02:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=QINR7aBmFqR5nO8jgpjTfzRORusUbRltGHWuZg6leGMeBwUahtWImxpJVW5CRiQp87
         o4FQz0i2c5HAKFp6i+HWw/wMGUDV/kfszL3cuZ6a/Zx0ljIdgIe4XAUYHDbgNlwP4g9Z
         VAUsbXKKo30Kzz6boslFTuVpEjdXE8YxBMFVA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: not printout if not finding setup_data
Date: Tue, 1 Jul 2008 20:04:10 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200806301834.59156.yhlu.kernel@gmail.com>
In-Reply-To: <200806301834.59156.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807012004.10789.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -399,6 +399,7 @@ static void __init reserve_setup_data(vo
 	struct setup_data *data;
 	u64 pa_data;
 	char buf[32];
+	int found = 0;
 
 	if (boot_params.hdr.version < 0x0209)
 		return;
@@ -409,9 +410,13 @@ static void __init reserve_setup_data(vo
 		reserve_early(pa_data, pa_data+sizeof(*data)+data->len, buf);
 		e820_update_range(pa_data, sizeof(*data)+data->len,
 			 E820_RAM, E820_RESERVED_KERN);
+		found = 1;
 		pa_data = data->next;
 		early_iounmap(data, sizeof(*data));
 	}
+	if (!found)
+		return;
+
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 	printk(KERN_INFO "extended physical RAM map:\n");
 	e820_print_map("reserve setup_data");
