Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab0CBXxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:53:44 -0500
Received: from kroah.org ([198.145.64.141]:38617 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab0CBX3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:31 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Frans Pop <elendil@planet.nl>, Larry Finger <Larry.Finger@lwfinger.net>,
       Len Brown <lenb@kernel.org>, Helge Deller <deller@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 32/62] x86: move hp-wmi's probe function to .devinit.text
Date: Tue,  2 Mar 2010 15:28:31 -0800
Message-Id: <1267572541-410-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

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
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/hp-wmi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 3aa57da..7ccf33c 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -57,7 +57,7 @@ enum hp_wmi_radio {
 	HPWMI_WWAN = 2,
 };
 
-static int __init hp_wmi_bios_setup(struct platform_device *device);
+static int __devinit hp_wmi_bios_setup(struct platform_device *device);
 static int __exit hp_wmi_bios_remove(struct platform_device *device);
 static int hp_wmi_resume_handler(struct device *device);
 
@@ -447,7 +447,7 @@ static void cleanup_sysfs(struct platform_device *device)
 	device_remove_file(&device->dev, &dev_attr_tablet);
 }
 
-static int __init hp_wmi_bios_setup(struct platform_device *device)
+static int __devinit hp_wmi_bios_setup(struct platform_device *device)
 {
 	int err;
 	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
-- 
1.7.0.1

