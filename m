Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZJGWkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZJGWkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbZJGWko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:40:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44039 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbZJGWko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:40:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 8 Oct 2009 00:39:31 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/8] firewire: sbp2: provide fallback if mgt_ORB_timeout is
 missing
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.27888275592fd267@s5r6.in-berlin.de>
Message-ID: <tkrat.41fb97f0834eed97@s5r6.in-berlin.de>
References: <tkrat.27888275592fd267@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Unit_Characteristics entry of an SBP-2 unit directory is not
mandatory as far as I can tell.  If it is missing, we would probably
fail to log in into the target because firewire-sbp2 would not wait for
status after it sent the login request.

The fix moves the cleanup of tgt->mgt_orb_timeout into a place where it
is executed exactly once before login, rather than 0..n times depending
on the target's config ROM.  With targets with one or more
Unit_Characteristics entries, the result is the same as before.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c |   39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

Index: linux-2.6.31/drivers/firewire/sbp2.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/sbp2.c
+++ linux-2.6.31/drivers/firewire/sbp2.c
@@ -188,14 +188,7 @@ static struct fw_device *target_device(s
 /* Impossible login_id, to detect logout attempt before successful login */
 #define INVALID_LOGIN_ID 0x10000
 
-/*
- * Per section 7.4.8 of the SBP-2 spec, a mgt_ORB_timeout value can be
- * provided in the config rom. Most devices do provide a value, which
- * we'll use for login management orbs, but with some sane limits.
- */
-#define SBP2_MIN_LOGIN_ORB_TIMEOUT	5000U	/* Timeout in ms */
-#define SBP2_MAX_LOGIN_ORB_TIMEOUT	40000U	/* Timeout in ms */
-#define SBP2_ORB_TIMEOUT		2000U	/* Timeout in ms */
+#define SBP2_ORB_TIMEOUT		2000U		/* Timeout in ms */
 #define SBP2_ORB_NULL			0x80000000
 #define SBP2_RETRY_LIMIT		0xf		/* 15 retries */
 #define SBP2_CYCLE_LIMIT		(0xc8 << 12)	/* 200 125us cycles */
@@ -1034,7 +1027,6 @@ static int sbp2_scan_unit_dir(struct sbp
 {
 	struct fw_csr_iterator ci;
 	int key, value;
-	unsigned int timeout;
 
 	fw_csr_iterator_init(&ci, directory);
 	while (fw_csr_iterator_next(&ci, &key, &value)) {
@@ -1059,17 +1051,7 @@ static int sbp2_scan_unit_dir(struct sbp
 
 		case SBP2_CSR_UNIT_CHARACTERISTICS:
 			/* the timeout value is stored in 500ms units */
-			timeout = ((unsigned int) value >> 8 & 0xff) * 500;
-			timeout = max(timeout, SBP2_MIN_LOGIN_ORB_TIMEOUT);
-			tgt->mgt_orb_timeout =
-				  min(timeout, SBP2_MAX_LOGIN_ORB_TIMEOUT);
-
-			if (timeout > tgt->mgt_orb_timeout)
-				fw_notify("%s: config rom contains %ds "
-					  "management ORB timeout, limiting "
-					  "to %ds\n", tgt->bus_id,
-					  timeout / 1000,
-					  tgt->mgt_orb_timeout / 1000);
+			tgt->mgt_orb_timeout = (value >> 8 & 0xff) * 500;
 			break;
 
 		case SBP2_CSR_LOGICAL_UNIT_NUMBER:
@@ -1087,6 +1069,22 @@ static int sbp2_scan_unit_dir(struct sbp
 	return 0;
 }
 
+/*
+ * Per section 7.4.8 of the SBP-2 spec, a mgt_ORB_timeout value can be
+ * provided in the config rom. Most devices do provide a value, which
+ * we'll use for login management orbs, but with some sane limits.
+ */
+static void sbp2_clamp_management_orb_timeout(struct sbp2_target *tgt)
+{
+	unsigned int timeout = tgt->mgt_orb_timeout;
+
+	if (timeout > 40000)
+		fw_notify("%s: %ds mgt_ORB_timeout limited to 40s\n",
+			  tgt->bus_id, timeout / 1000);
+
+	tgt->mgt_orb_timeout = clamp_val(timeout, 5000, 40000);
+}
+
 static void sbp2_init_workarounds(struct sbp2_target *tgt, u32 model,
 				  u32 firmware_revision)
 {
@@ -1171,6 +1169,7 @@ static int sbp2_probe(struct device *dev
 			       &firmware_revision) < 0)
 		goto fail_tgt_put;
 
+	sbp2_clamp_management_orb_timeout(tgt);
 	sbp2_init_workarounds(tgt, model, firmware_revision);
 
 	/*

-- 
Stefan Richter
-=====-==--= =-=- -=---
http://arcgraph.de/sr/

