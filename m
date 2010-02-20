Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab0BTVll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 16:41:41 -0500
Received: from ist.d-labs.de ([213.239.218.44]:55205 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510Ab0BTVl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 16:41:28 -0500
From: florian@mickler.org
To: linux-wireless@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Florian Mickler <florian@mickler.org>
Subject: [PATCH 2/2] enhance /sys/class/rfkill/<rfkill>/state interface
Date: Sat, 20 Feb 2010 22:40:45 +0100
Message-Id: <1266702045-6062-3-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1266702045-6062-1-git-send-email-florian@mickler.org>
References: <1266702045-6062-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new state-value RFKILL_STATE_SOFT_AND_HARD_BLOCKED
which is returned only through the sysfs state file.
The other interfaces are designed so that they don't need this extra
state.

This allows the sysfs to represent all possible states an rfkill driver can
have.

Signed-off-by: Florian Mickler <florian@mickler.org>
---

After stumbling over this arbitrary limitation of sys/class/rfkill/*/state I
wondered what would hinder this patch?

Documentation/ABI/stable/sysfs-class-rfkill |    7 ++++---
 include/linux/rfkill.h                      |    3 +++
 net/rfkill/core.c                           |    9 ++++++++-
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-class-rfkill b/Documentation/ABI/stable/sysfs-class-rfkill
index 53a4287..0cda9b3 100644
--- a/Documentation/ABI/stable/sysfs-class-rfkill
+++ b/Documentation/ABI/stable/sysfs-class-rfkill
@@ -42,9 +42,7 @@ What:		/sys/class/rfkill/rfkill[0-9]+/state
 Date:		09-Jul-2007
 KernelVersion	v2.6.22
 Contact:	linux-wireless@vger.kernel.org
-Description: 	Current state of the transmitter. This file is deprecated
-		because it can only properly show three of the four possible
-		states, soft-and-hard-blocked is missing.
+Description: 	Current state of the transmitter.
 Values: 	A numeric value.
 		0: RFKILL_STATE_SOFT_BLOCKED
 			transmitter is turned off by software
@@ -53,6 +51,9 @@ Values: 	A numeric value.
 		2: RFKILL_STATE_HARD_BLOCKED
 			transmitter is forced off by something outside of
 			the driver's control.
+		3: RFKILL_STATE_SOFT_AND_HARD_BLOCKED
+			transmitter is blocked by something outside of 
+			the driver's control as well as turned off by software
 
 
 What:		/sys/class/rfkill/rfkill[0-9]+/claim
diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 97059d0..b09a655 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -25,6 +25,8 @@
 #define RFKILL_STATE_SOFT_BLOCKED	0
 #define RFKILL_STATE_UNBLOCKED		1
 #define RFKILL_STATE_HARD_BLOCKED	2
+/* only used for sysfs */
+#define RFKILL_STATE_SOFT_AND_HARD_BLOCKED 3
 
 /**
  * enum rfkill_type - type of rfkill switch.
@@ -109,6 +111,7 @@ enum rfkill_user_states {
 	RFKILL_USER_STATE_SOFT_BLOCKED	= RFKILL_STATE_SOFT_BLOCKED,
 	RFKILL_USER_STATE_UNBLOCKED	= RFKILL_STATE_UNBLOCKED,
 	RFKILL_USER_STATE_HARD_BLOCKED	= RFKILL_STATE_HARD_BLOCKED,
+	RFKILL_USER_STATE_SOFT_AND_HARD_BLOCKED = RFKILL_STATE_SOFT_AND_HARD_BLOCKED,
 };
 #undef RFKILL_STATE_SOFT_BLOCKED
 #undef RFKILL_STATE_UNBLOCKED
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index c218e07..6d40297 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -645,12 +645,19 @@ static ssize_t rfkill_state_show(struct device *dev,
 	struct rfkill *rfkill = to_rfkill(dev);
 	unsigned long flags;
 	u32 state;
+	int user_state;
 
 	spin_lock_irqsave(&rfkill->lock, flags);
 	state = rfkill->state;
 	spin_unlock_irqrestore(&rfkill->lock, flags);
 
-	return sprintf(buf, "%d\n", user_state_from_blocked(state));
+	if (( state & RFKILL_BLOCK_HW ) && ( state & RFKILL_BLOCK_SW ))
+		user_state = RFKILL_USER_STATE_SOFT_AND_HARD_BLOCKED;
+	else
+		user_state = user_state_from_blocked(state);
+
+	return sprintf(buf, "%d\n", user_state);
+
 }
 
 static ssize_t rfkill_state_store(struct device *dev,
-- 
1.6.6.1

