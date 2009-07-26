Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbZGZNxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbZGZNxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 09:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbZGZNxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 09:53:37 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:22698 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbZGZNxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 09:53:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QznguFHZ34upXOAiAa0iF18umLrdE2dB+msoU19wDuHCVQ3EmB8U8K9MoySS5puhwb
         8wYNiTMwV2D4xxuixr8B0b3jC2qhGOM4U1VOQoeuNHvT8W+e0OWMy3yLm2Stm5eSYuz/
         3HBFHlYZUzxmMJjuWpI+XhRS2EbCwLGjQRwSk=
Subject: Re: [PATCH 1/1] acer-wmi: switch driver to dev_pm_ops
From: Arnaud Faucher <arnaud.faucher@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Frans Pop <elendil@planet.nl>,
       "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
       Manuel Lauss <manuel.lauss@gmail.com>, Erik Ekman <erik@kryo.se>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <200907252204.44875.rjw@sisk.pl>
References: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com>
	 <20090725174311.GB14062@dtor-d630.eng.vmware.com>
	 <200907252204.44875.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 26 Jul 2009 09:53:33 -0400
Message-Id: <1248616413.3922.7.camel@green>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.4.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gets rid of the following warning:
Platform driver 'acer-wmi' needs updating - please use dev_pm_ops

Take 2, thanks to Dmitry, Rafael and Frans for pointing out PM issue on
hibernation when using dev_pm_ops blindly.

This patch was tested against suspendand hibernation (Acer mail led
status).

Signed-off-by: Arnaud Faucher <arnaud.faucher@gmail.com>
---
 drivers/platform/x86/acer-wmi.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c
b/drivers/platform/x86/acer-wmi.c
index be2fd6f..29374bc 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1152,8 +1152,7 @@ static int acer_platform_remove(struct
platform_device *device)
 	return 0;
 }
 
-static int acer_platform_suspend(struct platform_device *dev,
-pm_message_t state)
+static int acer_platform_suspend(struct device *dev)
 {
 	u32 value;
 	struct acer_data *data = &interface->data;
@@ -1174,7 +1173,7 @@ pm_message_t state)
 	return 0;
 }
 
-static int acer_platform_resume(struct platform_device *device)
+static int acer_platform_resume(struct device *dev)
 {
 	struct acer_data *data = &interface->data;
 
@@ -1190,15 +1189,23 @@ static int acer_platform_resume(struct
platform_device *device)
 	return 0;
 }
 
+static struct dev_pm_ops acer_platform_pm_ops = {
+	.suspend = acer_platform_suspend,
+	.resume = acer_platform_resume,
+	.freeze = acer_platform_suspend,
+	.thaw = acer_platform_resume,
+	.poweroff = acer_platform_suspend,
+	.restore = acer_platform_resume,
+};
+
 static struct platform_driver acer_platform_driver = {
 	.driver = {
 		.name = "acer-wmi",
 		.owner = THIS_MODULE,
+		.pm = &acer_platform_pm_ops,
 	},
 	.probe = acer_platform_probe,
 	.remove = acer_platform_remove,
-	.suspend = acer_platform_suspend,
-	.resume = acer_platform_resume,
 };
 
 static struct platform_device *acer_platform_device;
-- 
1.6.3.3


