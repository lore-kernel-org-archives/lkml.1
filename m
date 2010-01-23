Return-Path: <linux-kernel-owner+w=401wt.eu-S1751832Ab0AWUjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab0AWUjh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143Ab0AWUjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:39:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50544 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab0AWUf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:35:57 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Frans Pop <elendil@planet.nl>,
       Larry Finger <Larry.Finger@lwfinger.net>, Len Brown <lenb@kernel.org>,
       Helge Deller <deller@gmx.de>, Matthew Garrett <mjg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 13/29] move hp-wmi's probe function to .devinit.text
Date: Sat, 23 Jan 2010 21:35:21 +0100
Message-Id: <1264278937-19675-13-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pointer to hp_wmi_bios_setup is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Frans Pop <elendil@planet.nl>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/platform/x86/hp-wmi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index ad4c414..5c7259a 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -57,7 +57,7 @@ enum hp_wmi_radio {
 	HPWMI_WWAN = 2,
 };
 
-static int __init hp_wmi_bios_setup(struct platform_device *device);
+static int __devinit hp_wmi_bios_setup(struct platform_device *device);
 static int __exit hp_wmi_bios_remove(struct platform_device *device);
 static int hp_wmi_resume_handler(struct device *device);
 
@@ -446,7 +446,7 @@ static void cleanup_sysfs(struct platform_device *device)
 	device_remove_file(&device->dev, &dev_attr_tablet);
 }
 
-static int __init hp_wmi_bios_setup(struct platform_device *device)
+static int __devinit hp_wmi_bios_setup(struct platform_device *device)
 {
 	int err;
 	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
-- 
1.6.6

