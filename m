Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYBCWLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYBCWLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYBCWK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:10:57 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47858 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbYBCWK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:10:57 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 3 Feb 2008 23:10:47 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 6/9] firewire: fw-sbp2: don't add scsi_device twice
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
Message-ID: <tkrat.2ef253adcedcb9ea@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a reconnect failed but re-login succeeded, __scsi_add_device was
called again.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -741,6 +741,12 @@ static void sbp2_login(struct work_struc
 	PREPARE_DELAYED_WORK(&lu->work, sbp2_reconnect);
 	sbp2_agent_reset(lu);
 
+	/* This was a re-login. */
+	if (lu->sdev) {
+		sbp2_cancel_orbs(lu);
+		goto out;
+	}
+
 	if (lu->tgt->workarounds & SBP2_WORKAROUND_DELAY_INQUIRY)
 		ssleep(SBP2_INQUIRY_DELAY);
 

-- 
Stefan Richter
-=====-==--- --=- ---==
http://arcgraph.de/sr/

