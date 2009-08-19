Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbZHSRvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbZHSRvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 13:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbZHSRvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 13:51:51 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:13998 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbZHSRvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 13:51:50 -0400
Date: Wed, 19 Aug 2009 11:51:50 -0600
From: David Altobelli <david.altobelli@hp.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, david.altobelli@hp.com
Subject: [PATCH] hpilo: add locking comment
Message-ID: <20090819175150.GA7053@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add explanation about lock nesting and purpose of each lock in hpilo.

This applies on top of a set of patches I sent out to add polling to hpilo.

Please CC me on any replies, and thanks,
Dave

Signed-off-by: David Altobelli <david.altobelli@hp.com>
---
--- linux-2.6.30.3/drivers/misc/hpilo.h.orig	2009-08-19 10:38:23.000000000 -0500
+++ linux-2.6.30.3/drivers/misc/hpilo.h	2009-08-19 11:06:36.000000000 -0500
@@ -44,9 +44,20 @@ struct ilo_hwinfo {
 
 	struct pci_dev *ilo_dev;
 
+	/*
+	 * open_lock      serializes ccb_cnt during open and close
+	 * [ irq disabled ]
+	 * -> alloc_lock  used when adding/removing/searching ccb_alloc,
+	 *                which represents all ccbs open on the device
+	 * --> fifo_lock  controls access to fifo queues shared with hw
+	 *
+	 * Locks must be taken in this order, but open_lock and alloc_lock
+	 * are optional, they do not need to be held in order to take a
+	 * lower level lock.
+	 */
+	spinlock_t open_lock;
 	spinlock_t alloc_lock;
 	spinlock_t fifo_lock;
-	spinlock_t open_lock;
 
 	struct cdev cdev;
 };
