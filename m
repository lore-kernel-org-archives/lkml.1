Return-Path: <linux-kernel-owner+w=401wt.eu-S934430AbZJMWOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934430AbZJMWOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761546AbZJMWOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:14:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:62322 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761524AbZJMWOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:14:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PJZ7QIBpvNW6lItQgWZWwIY2/2XSNrHePoOE4VtDr0J2USqpwLHi99ZZCFF9iwNe1K
         BNuiFzUYDo4U2Aql0yB5Fcd0CiCFynHQoE9UunWbD0rL9ovJbEdBW1xGLfXPvayuU662
         1ZOaXD7V497TsTlXB5B1DvK/ANfiVDQjiQWVs=
From: Paul Fertser <fercerpav@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Nelson Castillo <arhuaco@freaks-unidos.net>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 2/7] mfd: pcf50633: make suspend/resume belong to i2c_driver
Date: Wed, 14 Oct 2009 02:12:31 +0400
Message-Id: <1255471956-29201-2-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1255471956-29201-1-git-send-email-fercerpav@gmail.com>
References: <1255471956-29201-1-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

When not using the i2c suspend/resume callbacks the i2c client resumed
before the i2c master.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/mfd/pcf50633-core.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 6efe5c3..a844445 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -485,13 +485,13 @@ pcf50633_client_dev_register(struct pcf50633 *pcf, const char *name,
 }
 
 #ifdef CONFIG_PM
-static int pcf50633_suspend(struct device *dev, pm_message_t state)
+static int pcf50633_suspend(struct i2c_client *client, pm_message_t state)
 {
 	struct pcf50633 *pcf;
 	int ret = 0, i;
 	u8 res[5];
 
-	pcf = dev_get_drvdata(dev);
+	pcf = i2c_get_clientdata(client);
 
 	/* Make sure our interrupt handlers are not called
 	 * henceforth */
@@ -526,12 +526,12 @@ out:
 	return ret;
 }
 
-static int pcf50633_resume(struct device *dev)
+static int pcf50633_resume(struct i2c_client *client)
 {
 	struct pcf50633 *pcf;
 	int ret;
 
-	pcf = dev_get_drvdata(dev);
+	pcf = i2c_get_clientdata(client);
 
 	/* Write the saved mask registers */
 	ret = pcf50633_write_block(pcf, PCF50633_REG_INT1M,
@@ -689,12 +689,12 @@ static struct i2c_device_id pcf50633_id_table[] = {
 static struct i2c_driver pcf50633_driver = {
 	.driver = {
 		.name	= "pcf50633",
-		.suspend = pcf50633_suspend,
-		.resume	= pcf50633_resume,
 	},
 	.id_table = pcf50633_id_table,
 	.probe = pcf50633_probe,
 	.remove = __devexit_p(pcf50633_remove),
+	.suspend = pcf50633_suspend,
+	.resume	= pcf50633_resume,
 };
 
 static int __init pcf50633_init(void)
-- 
1.6.0.6

