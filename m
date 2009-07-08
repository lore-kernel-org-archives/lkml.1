Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZGHMPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZGHMPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 08:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZGHMPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 08:15:37 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:55980 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752310AbZGHMPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 08:15:37 -0400
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] hp-wmi: switch driver to dev_pm_ops
Date: Wed, 8 Jul 2009 14:15:33 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907081415.34568.elendil@planet.nl>
X-OriginalArrivalTime: 08 Jul 2009 12:15:35.0305 (UTC) FILETIME=[CC015790:01C9FFC5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gets rid of the following warning:
Platform driver 'hp-wmi' needs updating - please use dev_pm_ops

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---

I tested that the resume handler still works on my HP 2510p notebook.

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index ca50856..7c4a22b 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -53,7 +53,7 @@ MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE91-3D44E2C707E4");
 
 static int __init hp_wmi_bios_setup(struct platform_device *device);
 static int __exit hp_wmi_bios_remove(struct platform_device *device);
-static int hp_wmi_resume_handler(struct platform_device *device);
+static int hp_wmi_resume_handler(struct device *device);
 
 struct bios_args {
 	u32 signature;
@@ -94,14 +94,18 @@ static struct rfkill *wifi_rfkill;
 static struct rfkill *bluetooth_rfkill;
 static struct rfkill *wwan_rfkill;
 
+static struct dev_pm_ops hp_wmi_pm_ops = {
+	.resume  = hp_wmi_resume_handler,
+};
+
 static struct platform_driver hp_wmi_driver = {
 	.driver = {
-		   .name = "hp-wmi",
-		   .owner = THIS_MODULE,
+		.name = "hp-wmi",
+		.owner = THIS_MODULE,
+		.pm = &hp_wmi_pm_ops,
 	},
 	.probe = hp_wmi_bios_setup,
 	.remove = hp_wmi_bios_remove,
-	.resume = hp_wmi_resume_handler,
 };
 
 static int hp_wmi_perform_query(int query, int write, int value)
@@ -512,7 +516,7 @@ static int __exit hp_wmi_bios_remove(struct platform_device *device)
 	return 0;
 }
 
-static int hp_wmi_resume_handler(struct platform_device *device)
+static int hp_wmi_resume_handler(struct device *device)
 {
 	/*
 	 * Hardware state may have changed while suspended, so trigger
