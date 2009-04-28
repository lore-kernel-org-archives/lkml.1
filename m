Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZD1Izx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZD1Izx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbZD1IzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:55:22 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:41686 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbZD1IzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:55:20 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Matt Reimer <mreimer@vpop.net>, Anton Vorontsov <cbou@mail.ru>
Subject: [PATCH 2/3] w1: ds2760: add support for EEPROM read and write
Date: Tue, 28 Apr 2009 10:55:01 +0200
Message-Id: <1240908902-24646-2-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240908902-24646-1-git-send-email-daniel@caiaq.de>
References: <1240908902-24646-1-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to modify the DS2762's status registers and to add support for
sleep mode, there is need for functions to write the internal EEPROM.

Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Anton Vorontsov <cbou@mail.ru>
Signed-off-by: Daniel Mack <daniel@caiaq.de>
---
 drivers/w1/slaves/w1_ds2760.c |   28 ++++++++++++++++++++++++++++
 drivers/w1/slaves/w1_ds2760.h |    2 ++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/slaves/w1_ds2760.c b/drivers/w1/slaves/w1_ds2760.c
index 1f09d4e..5ad7a0b 100644
--- a/drivers/w1/slaves/w1_ds2760.c
+++ b/drivers/w1/slaves/w1_ds2760.c
@@ -68,6 +68,34 @@ int w1_ds2760_write(struct device *dev, char *buf, int addr, size_t count)
 	return w1_ds2760_io(dev, buf, addr, count, 1);
 }
 
+static int w1_ds2760_eeprom_cmd(struct device *dev, int addr, int cmd)
+{
+	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
+
+	if (!dev)
+		return -EINVAL;
+
+	mutex_lock(&sl->master->mutex);
+
+	if (w1_reset_select_slave(sl) == 0) {
+		w1_write_8(sl->master, cmd);
+		w1_write_8(sl->master, addr);
+	}
+
+	mutex_unlock(&sl->master->mutex);
+	return 0;
+}
+
+int w1_ds2760_store_eeprom(struct device *dev, int addr)
+{
+	return w1_ds2760_eeprom_cmd(dev, addr, W1_DS2760_COPY_DATA);
+}
+
+int w1_ds2760_recall_eeprom(struct device *dev, int addr)
+{
+	return w1_ds2760_eeprom_cmd(dev, addr, W1_DS2760_RECALL_DATA);
+}
+
 static ssize_t w1_ds2760_read_bin(struct kobject *kobj,
 				  struct bin_attribute *bin_attr,
 				  char *buf, loff_t off, size_t count)
diff --git a/drivers/w1/slaves/w1_ds2760.h b/drivers/w1/slaves/w1_ds2760.h
index f130242..ea39419 100644
--- a/drivers/w1/slaves/w1_ds2760.h
+++ b/drivers/w1/slaves/w1_ds2760.h
@@ -46,5 +46,7 @@ extern int w1_ds2760_read(struct device *dev, char *buf, int addr,
 			  size_t count);
 extern int w1_ds2760_write(struct device *dev, char *buf, int addr,
 			   size_t count);
+extern int w1_ds2760_store_eeprom(struct device *dev, int addr);
+extern int w1_ds2760_recall_eeprom(struct device *dev, int addr);
 
 #endif /* !__w1_ds2760_h__ */
-- 
1.6.2.1

