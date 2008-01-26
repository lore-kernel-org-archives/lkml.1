Return-Path: <linux-kernel-owner+w=401wt.eu-S1757170AbYAZQoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbYAZQoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYAZQoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 11:44:03 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58196 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbYAZQoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 11:44:01 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 Jan 2008 17:43:23 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/3] firewire: fw-sbp2: fix logout before login retry
To: linux1394-devel@lists.sourceforge.net
cc: Jarod Wilson <jwilson@redhat.com>,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.1198d1dd6ae8d623@s5r6.in-berlin.de>
Message-ID: <tkrat.9c497ea379f28950@s5r6.in-berlin.de>
References: <tkrat.1198d1dd6ae8d623@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a "can't recognize device" kind of bug.

If the SCSI INQUIRY failed and hence __scsi_add_device failed due to a
bus reset, we tried a logout and then waited for the already scheduled
login work to happen.  So far so good, but the generation used for the
logout was outdated, hence the logout never reached the target.  The
target might therefore deny the subsequent relogin attempt, which would
also leave the target inaccessible.

Therefore fetch a fresh device->generation for the logout.  Use memory
barriers to prevent our plan being foiled by compiler or hardware
optimizations.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -716,7 +716,11 @@ static void sbp2_login(struct work_struc
 	sdev = __scsi_add_device(shost, 0, 0,
 				 scsilun_to_int(&eight_bytes_lun), lu);
 	if (IS_ERR(sdev)) {
-		sbp2_send_management_orb(lu, node_id, generation,
+		smp_rmb(); /* generation may have changed */
+		generation = device->generation;
+		smp_rmb(); /* node_id must not be older than generation */
+
+		sbp2_send_management_orb(lu, device->node_id, generation,
 				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
 		/*
 		 * Set this back to sbp2_login so we fall back and

-- 
Stefan Richter
-=====-==--- ---= ==-=-
http://arcgraph.de/sr/

