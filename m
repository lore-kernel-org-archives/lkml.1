Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416Ab0CLSEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 13:04:10 -0500
Received: from ist.d-labs.de ([213.239.218.44]:50442 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934354Ab0CLSEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 13:04:04 -0500
From: florian@mickler.org
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Marcel Holtmann" <marcel@holtmann.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Florian Mickler <florian@mickler.org>
Subject: [PATCH 2/2] enhance sysfs rfkill interface
Date: Fri, 12 Mar 2010 19:03:08 +0100
Message-Id: <1268416988-24862-3-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1268416988-24862-2-git-send-email-florian@mickler.org>
References: <1268416988-24862-1-git-send-email-florian@mickler.org>
 <1268416988-24862-2-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit introduces two new sysfs knobs.

/sys/class/rfkill/rfkill[0-9]+/hard: (ro)
	hardblock kill state
/sys/class/rfkill/rfkill[0-9]+/soft: (rw)
	softblock kill state

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 Documentation/ABI/stable/sysfs-class-rfkill |   25 ++++++++++++
 net/rfkill/core.c                           |   57 +++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-class-rfkill b/Documentation/ABI/stable/sysfs-class-rfkill
index 3884344..097f522 100644
--- a/Documentation/ABI/stable/sysfs-class-rfkill
+++ b/Documentation/ABI/stable/sysfs-class-rfkill
@@ -40,3 +40,28 @@ Description: 	Whether the soft blocked state is initialised from non-volatile
 Values: 	A numeric value.
 		0: false
 		1: true
+
+
+What:		/sys/class/rfkill/rfkill[0-9]+/hard
+Date:		12-March-2010
+KernelVersion	v2.6.34
+Contact:	linux-wireless@vger.kernel.org
+Description: 	Current hardblock state. This file is read only.
+Values: 	A numeric value.
+		0: inactive
+			The transmitter is (potentially) active.
+		1: active
+			The transmitter is forced off by something outside of
+			the driver's control.
+
+
+What:		/sys/class/rfkill/rfkill[0-9]+/soft
+Date:		12-March-2010
+KernelVersion	v2.6.34
+Contact:	linux-wireless@vger.kernel.org
+Description:	Current softblock state. This file is read and write.
+Values: 	A numeric value.
+		0: inactive
+			The transmitter is (potentially) active.
+		1: active
+			The transmitter is turned off by software.
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index c218e07..38a0358 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -628,6 +628,61 @@ static ssize_t rfkill_persistent_show(struct device *dev,
 	return sprintf(buf, "%d\n", rfkill->persistent);
 }
 
+static ssize_t rfkill_hard_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct rfkill *rfkill = to_rfkill(dev);
+	unsigned long flags;
+	u32 state;
+
+	spin_lock_irqsave(&rfkill->lock, flags);
+	state = rfkill->state;
+	spin_unlock_irqrestore(&rfkill->lock, flags);
+
+	return sprintf(buf, "%d\n", (state & RFKILL_BLOCK_HW) ? 1 : 0 );
+}
+
+static ssize_t rfkill_soft_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct rfkill *rfkill = to_rfkill(dev);
+	unsigned long flags;
+	u32 state;
+
+	spin_lock_irqsave(&rfkill->lock, flags);
+	state = rfkill->state;
+	spin_unlock_irqrestore(&rfkill->lock, flags);
+
+	return sprintf(buf, "%d\n", (state & RFKILL_BLOCK_SW) ? 1 : 0 );
+}
+
+static ssize_t rfkill_soft_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct rfkill *rfkill = to_rfkill(dev);
+	unsigned long state;
+	int err;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	err = strict_strtoul(buf, 0, &state);
+	if (err)
+		return err;
+
+	if (state > 1 )
+		return -EINVAL;
+
+	mutex_lock(&rfkill_global_mutex);
+	rfkill_set_block(rfkill, state);
+	mutex_unlock(&rfkill_global_mutex);
+
+	return err ?: count;
+}
+
 static u8 user_state_from_blocked(unsigned long state)
 {
 	if (state & RFKILL_BLOCK_HW)
@@ -700,6 +755,8 @@ static struct device_attribute rfkill_dev_attrs[] = {
 	__ATTR(persistent, S_IRUGO, rfkill_persistent_show, NULL),
 	__ATTR(state, S_IRUGO|S_IWUSR, rfkill_state_show, rfkill_state_store),
 	__ATTR(claim, S_IRUGO|S_IWUSR, rfkill_claim_show, rfkill_claim_store),
+	__ATTR(soft, S_IRUGO|S_IWUSR, rfkill_soft_show, rfkill_soft_store),
+	__ATTR(hard, S_IRUGO, rfkill_hard_show, NULL),
 	__ATTR_NULL
 };
 
-- 
1.6.6.1

