Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944Ab0CMJoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 04:44:22 -0500
Received: from ist.d-labs.de ([213.239.218.44]:39277 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab0CMJoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 04:44:19 -0500
From: florian@mickler.org
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>, Valdis.Kletnieks@vt.edu,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Florian Mickler <florian@mickler.org>
Subject: [PATCH] rename new rfkill sysfs knobs
Date: Sat, 13 Mar 2010 10:44:07 +0100
Message-Id: <1268473447-28669-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <20100313104128.79aa2846@schatten.dmk.lab>
References: <20100313104128.79aa2846@schatten.dmk.lab>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames the (never officially released) sysfs-knobs
"blocked_hw" and "blocked_sw" to "hard" and "soft", as the hardware vs
software conotation is misleading.

It also gets rid of not needed locks around u32-read-access.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 Documentation/ABI/stable/sysfs-class-rfkill |   10 +++++-----
 net/rfkill/core.c                           |   17 +++++------------
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-class-rfkill b/Documentation/ABI/stable/sysfs-class-rfkill
index b91c3f3..097f522 100644
--- a/Documentation/ABI/stable/sysfs-class-rfkill
+++ b/Documentation/ABI/stable/sysfs-class-rfkill
@@ -4,7 +4,7 @@ For details to this subsystem look at Documentation/rfkill.txt.
 
 For the deprecated /sys/class/rfkill/*/state and
 /sys/class/rfkill/*/claim knobs of this interface look in
-Documentation/ABI/obsolte/sysfs-class-rfkill.
+Documentation/ABI/obsolete/sysfs-class-rfkill.
 
 What: 		/sys/class/rfkill
 Date:		09-Jul-2007
@@ -42,8 +42,8 @@ Values: 	A numeric value.
 		1: true
 
 
-What:		/sys/class/rfkill/rfkill[0-9]+/blocked_hw
-Date:		23-Feb-2010
+What:		/sys/class/rfkill/rfkill[0-9]+/hard
+Date:		12-March-2010
 KernelVersion	v2.6.34
 Contact:	linux-wireless@vger.kernel.org
 Description: 	Current hardblock state. This file is read only.
@@ -55,8 +55,8 @@ Values: 	A numeric value.
 			the driver's control.
 
 
-What:		/sys/class/rfkill/rfkill[0-9]+/blocked_sw
-Date:		23-Feb-2010
+What:		/sys/class/rfkill/rfkill[0-9]+/soft
+Date:		12-March-2010
 KernelVersion	v2.6.34
 Contact:	linux-wireless@vger.kernel.org
 Description:	Current softblock state. This file is read and write.
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 5f33151..60830f6 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -628,7 +628,7 @@ static ssize_t rfkill_persistent_show(struct device *dev,
 	return sprintf(buf, "%d\n", rfkill->persistent);
 }
 
-static ssize_t rfkill_blocked_hw_show(struct device *dev,
+static ssize_t rfkill_hard_show(struct device *dev,
 				 struct device_attribute *attr,
 				 char *buf)
 {
@@ -636,14 +636,12 @@ static ssize_t rfkill_blocked_hw_show(struct device *dev,
 	unsigned long flags;
 	u32 state;
 
-	spin_lock_irqsave(&rfkill->lock, flags);
 	state = rfkill->state;
-	spin_unlock_irqrestore(&rfkill->lock, flags);
 
 	return sprintf(buf, "%d\n", (state & RFKILL_BLOCK_HW) ? 1 : 0 );
 }
 
-static ssize_t rfkill_blocked_sw_show(struct device *dev,
+static ssize_t rfkill_soft_show(struct device *dev,
 				 struct device_attribute *attr,
 				 char *buf)
 {
@@ -651,14 +649,12 @@ static ssize_t rfkill_blocked_sw_show(struct device *dev,
 	unsigned long flags;
 	u32 state;
 
-	spin_lock_irqsave(&rfkill->lock, flags);
 	state = rfkill->state;
-	spin_unlock_irqrestore(&rfkill->lock, flags);
 
 	return sprintf(buf, "%d\n", (state & RFKILL_BLOCK_SW) ? 1 : 0 );
 }
 
-static ssize_t rfkill_blocked_sw_store(struct device *dev,
+static ssize_t rfkill_soft_store(struct device *dev,
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
@@ -701,9 +697,7 @@ static ssize_t rfkill_state_show(struct device *dev,
 	unsigned long flags;
 	u32 state;
 
-	spin_lock_irqsave(&rfkill->lock, flags);
 	state = rfkill->state;
-	spin_unlock_irqrestore(&rfkill->lock, flags);
 
 	return sprintf(buf, "%d\n", user_state_from_blocked(state));
 }
@@ -755,9 +749,8 @@ static struct device_attribute rfkill_dev_attrs[] = {
 	__ATTR(persistent, S_IRUGO, rfkill_persistent_show, NULL),
 	__ATTR(state, S_IRUGO|S_IWUSR, rfkill_state_show, rfkill_state_store),
 	__ATTR(claim, S_IRUGO|S_IWUSR, rfkill_claim_show, rfkill_claim_store),
-	__ATTR(sw, S_IRUGO|S_IWUSR, rfkill_blocked_sw_show,
-			rfkill_blocked_sw_store),
-	__ATTR(hw, S_IRUGO, rfkill_blocked_hw_show, NULL),
+	__ATTR(soft, S_IRUGO|S_IWUSR, rfkill_soft_show, rfkill_soft_store),
+	__ATTR(hard, S_IRUGO, rfkill_hard_show, NULL),
 	__ATTR_NULL
 };
 
-- 
1.6.6.1

