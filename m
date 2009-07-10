Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbZGJTmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbZGJTmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZGJTlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:41:51 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:47579 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbZGJTlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:41:50 -0400
Subject: [PATCH 2.6.31] rfkill: allow toggling soft state in sysfs again
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Thiemo Nagel <thiemo.nagel@ph.tum.de>,
       Corentin Chary <corentin.chary@gmail.com>,
       debian-eeepc-devel@lists.alioth.debian.org,
       acpi4asus-user@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
In-Reply-To: <507E3B9268%linux@youmustbejoking.demon.co.uk>
References: <4A5716AA.5000903@ph.tum.de>
	 <71cd59b00907100545v6f440a19xfc3668826eb1e509@mail.gmail.com>
	 <4A5743AB.6090303@ph.tum.de>
	 <71cd59b00907100646h5e0283fcyce5874cc4a19106b@mail.gmail.com>
	 <4A575119.9070505@ph.tum.de> <507E3B9268%linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 21:41:39 +0200
Message-Id: <1247254899.21972.9.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently there actually _are_ tools that try to set
this in sysfs even though it wasn't supposed to be used
this way without claiming first. Guess what: now that
I've cleaned it all up it doesn't matter and we can
simply allow setting the soft-block state in sysfs.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
*shrug*, I don't like it, but whatever...

Please test & report.

 net/rfkill/core.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- wireless-testing.orig/net/rfkill/core.c	2009-07-10 21:29:10.000000000 +0200
+++ wireless-testing/net/rfkill/core.c	2009-07-10 21:36:31.000000000 +0200
@@ -648,15 +648,26 @@ static ssize_t rfkill_state_store(struct
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
-	/*
-	 * The intention was that userspace can only take control over
-	 * a given device when/if rfkill-input doesn't control it due
-	 * to user_claim. Since user_claim is currently unsupported,
-	 * we never support changing the state from userspace -- this
-	 * can be implemented again later.
-	 */
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
+	if (state != RFKILL_USER_STATE_SOFT_BLOCKED &&
+	    state != RFKILL_USER_STATE_UNBLOCKED)
+		return -EINVAL;
+
+	mutex_lock(&rfkill_global_mutex);
+	rfkill_set_block(rfkill, state == RFKILL_USER_STATE_SOFT_BLOCKED);
+	mutex_unlock(&rfkill_global_mutex);
 
-	return -EPERM;
+	return err ?: count;
 }
 
 static ssize_t rfkill_claim_show(struct device *dev,


