Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab0BXLGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 06:06:07 -0500
Received: from ist.d-labs.de ([213.239.218.44]:49548 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719Ab0BXLFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 06:05:55 -0500
From: florian@mickler.org
To: "Marcel Holtmann" <marcel@holtmann.org>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Florian Mickler <florian@mickler.org>
Subject: [PATCH v2 2/2] enhance sysfs rfkill interface
Date: Wed, 24 Feb 2010 12:05:17 +0100
Message-Id: <1267009517-5017-3-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1266704345.32739.0.camel@jlt3.sipsolutions.net>
References: <1266704345.32739.0.camel@jlt3.sipsolutions.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit introduces two new sysfs knobs.

/sys/class/rfkill/rfkill[0-9]+/hw: (ro)
	hardblock kill state
/sys/class/rfkill/rfkill[0-9]+/sw: (rw)
	softblock kill state

Signed-off-by: Florian Mickler <florian@mickler.org>
---

I am not shure about those names.
Other alternatives: 
[hs]w_block
block_[hs]w
block[sh]w
soft/hard

...


 Documentation/ABI/stable/sysfs-class-rfkill |   25 ++++++++++++
 net/rfkill/core.c                           |   57 +++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-class-rfkill b/Documentation/ABI/stable/sysfs-class-rfkill
index 97d5064..ccbbba2 100644
--- a/Documentation/ABI/stable/sysfs-class-rfkill
+++ b/Documentation/ABI/stable/sysfs-class-rfkill
@@ -40,3 +40,28 @@ Description: 	Whether the soft blocked state is initialised from non-volatile
 Values: 	A numeric value.
 		0: false
 		1: true
+
+
+What:		/sys/class/rfkill/rfkill[0-9]+/hw
+Date:		23-Feb-2010
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
+What:		/sys/class/rfkill/rfkill[0-9]+/sw
+Date:		23-Feb-2010
+KernelVersion	v2.6.34
+Contact:	linux-wireless@vger.kernel.org
+Description:	Current softblock state. This file is read and write.
+Values: 	A numeric value.
+		0: inactive
+			The transmitter is (potentially) active.
+		1: active
+			The transmitter is turned off by software.
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index c218e07..b91e192 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -628,6 +628,61 @@ static ssize_t rfkill_persistent_show(struct device *dev,
 	return sprintf(buf, "%d\n", rfkill->persistent);
 }
 
+static ssize_t rfkill_hw_show(struct device *dev,
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
+static ssize_t rfkill_sw_show(struct device *dev,
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
+static ssize_t rfkill_sw_store(struct device *dev,
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
+	__ATTR(sw, S_IRUGO|S_IWUSR, rfkill_sw_show, rfkill_sw_store),
+	__ATTR(hw, S_IRUGO, rfkill_hw_show, NULL),
 	__ATTR_NULL
 };
 
-- 
1.6.6.1

