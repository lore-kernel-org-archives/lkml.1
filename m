Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbYLARFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbYLARFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 12:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYLAREz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 12:04:55 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58164 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbYLAREy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 12:04:54 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 1 Dec 2008 18:03:59 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] ieee1394 updates
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.26f0075691049689@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

the following updates:

Stefan Richter (4):
      ieee1394: sbp2: another iPod mini quirk entry
      firewire: fw-sbp2: another iPod mini quirk entry
      ieee1394: fix list corruption (reported at module removal)
      ieee1394: sbp2: fix race condition in state change

 drivers/firewire/fw-sbp2.c   |    5 +++++
 drivers/ieee1394/highlevel.c |   25 ++++++++++++-------------
 drivers/ieee1394/hosts.h     |    4 ++++
 drivers/ieee1394/sbp2.c      |   14 ++++++++++----
 4 files changed, 31 insertions(+), 17 deletions(-)


commit 2642b11295ebcc94843045933061bfbb263fce7f
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Nov 29 14:55:47 2008 +0100

    ieee1394: sbp2: fix race condition in state change
    
    An intermediate transition from _RUNNING to _IN_SHUTDOWN could have been
    missed by the former code.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 3f5dbcb..a373c18 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -895,12 +895,13 @@ static void sbp2_host_reset(struct hpsb_host *host)
 		return;
 
 	read_lock_irqsave(&sbp2_hi_logical_units_lock, flags);
+
 	list_for_each_entry(lu, &hi->logical_units, lu_list)
-		if (likely(atomic_read(&lu->state) !=
-			   SBP2LU_STATE_IN_SHUTDOWN)) {
-			atomic_set(&lu->state, SBP2LU_STATE_IN_RESET);
+		if (atomic_cmpxchg(&lu->state,
+				   SBP2LU_STATE_RUNNING, SBP2LU_STATE_IN_RESET)
+		    == SBP2LU_STATE_RUNNING)
 			scsi_block_requests(lu->shost);
-		}
+
 	read_unlock_irqrestore(&sbp2_hi_logical_units_lock, flags);
 }
 

commit e47c1feb17e61ef4e2f245c0af0c5a8e2a7798b2
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Wed Nov 26 01:34:25 2008 +0100

    ieee1394: fix list corruption (reported at module removal)
    
    If there is more than one FireWire controller present, dummy_zero_addr
    and dummy_max_addr were added multiple times to different lists, thus
    corrupting the lists.  Fix this by allocating them dynamically per host
    instead of just once globally.
    
    (Perhaps a better address space allocation algorithm could rid us of the
    two dummy address spaces.)
    
    Fixes http://bugzilla.kernel.org/show_bug.cgi?id=10129 .
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/highlevel.c b/drivers/ieee1394/highlevel.c
index 918ffc4..272543a 100644
--- a/drivers/ieee1394/highlevel.c
+++ b/drivers/ieee1394/highlevel.c
@@ -46,10 +46,6 @@ static DEFINE_RWLOCK(hl_irqs_lock);
 
 static DEFINE_RWLOCK(addr_space_lock);
 
-/* addr_space list will have zero and max already included as bounds */
-static struct hpsb_address_ops dummy_ops = { NULL, NULL, NULL, NULL };
-static struct hpsb_address_serve dummy_zero_addr, dummy_max_addr;
-
 
 static struct hl_host_info *hl_get_hostinfo(struct hpsb_highlevel *hl,
 					    struct hpsb_host *host)
@@ -481,20 +477,23 @@ int hpsb_unregister_addrspace(struct hpsb_highlevel *hl, struct hpsb_host *host,
 	return retval;
 }
 
+static struct hpsb_address_ops dummy_ops;
+
+/* dummy address spaces as lower and upper bounds of the host's a.s. list */
 static void init_hpsb_highlevel(struct hpsb_host *host)
 {
-	INIT_LIST_HEAD(&dummy_zero_addr.host_list);
-	INIT_LIST_HEAD(&dummy_zero_addr.hl_list);
-	INIT_LIST_HEAD(&dummy_max_addr.host_list);
-	INIT_LIST_HEAD(&dummy_max_addr.hl_list);
+	INIT_LIST_HEAD(&host->dummy_zero_addr.host_list);
+	INIT_LIST_HEAD(&host->dummy_zero_addr.hl_list);
+	INIT_LIST_HEAD(&host->dummy_max_addr.host_list);
+	INIT_LIST_HEAD(&host->dummy_max_addr.hl_list);
 
-	dummy_zero_addr.op = dummy_max_addr.op = &dummy_ops;
+	host->dummy_zero_addr.op = host->dummy_max_addr.op = &dummy_ops;
 
-	dummy_zero_addr.start = dummy_zero_addr.end = 0;
-	dummy_max_addr.start = dummy_max_addr.end = ((u64) 1) << 48;
+	host->dummy_zero_addr.start = host->dummy_zero_addr.end = 0;
+	host->dummy_max_addr.start = host->dummy_max_addr.end = ((u64) 1) << 48;
 
-	list_add_tail(&dummy_zero_addr.host_list, &host->addr_space);
-	list_add_tail(&dummy_max_addr.host_list, &host->addr_space);
+	list_add_tail(&host->dummy_zero_addr.host_list, &host->addr_space);
+	list_add_tail(&host->dummy_max_addr.host_list, &host->addr_space);
 }
 
 void highlevel_add_host(struct hpsb_host *host)
diff --git a/drivers/ieee1394/hosts.h b/drivers/ieee1394/hosts.h
index e4e8aeb..dd22995 100644
--- a/drivers/ieee1394/hosts.h
+++ b/drivers/ieee1394/hosts.h
@@ -13,6 +13,7 @@ struct module;
 
 #include "ieee1394_types.h"
 #include "csr.h"
+#include "highlevel.h"
 
 struct hpsb_packet;
 struct hpsb_iso;
@@ -72,6 +73,9 @@ struct hpsb_host {
 	struct { DECLARE_BITMAP(map, 64); } tl_pool[ALL_NODES];
 
 	struct csr_control csr;
+
+	struct hpsb_address_serve dummy_zero_addr;
+	struct hpsb_address_serve dummy_max_addr;
 };
 
 enum devctl_cmd {

commit 031bb27c4bf77c2f60b3f3dea8cce63ef0d1fba9
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Nov 22 12:38:58 2008 +0100

    firewire: fw-sbp2: another iPod mini quirk entry
    
    Add another model ID of a broken firmware to prevent early I/O errors
    by acesses at the end of the disk.  Reported at linux1394-user,
    http://marc.info/?t=122670842900002
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 97df6da..e54403e 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -372,6 +372,11 @@ static const struct {
 	},
 	/* iPod mini */ {
 		.firmware_revision	= 0x0a2700,
+		.model			= 0x000022,
+		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
+	},
+	/* iPod mini */ {
+		.firmware_revision	= 0x0a2700,
 		.model			= 0x000023,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
 	},

commit 9e0de91011ef6fe6eb3bb63f7ea15f586955660a
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Nov 22 12:38:24 2008 +0100

    ieee1394: sbp2: another iPod mini quirk entry
    
    Add another model ID of a broken firmware to prevent early I/O errors
    by acesses at the end of the disk.  Reported at linux1394-user,
    http://marc.info/?t=122670842900002
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index c52f6e6..3f5dbcb 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -402,6 +402,11 @@ static const struct {
 	},
 	/* iPod mini */ {
 		.firmware_revision	= 0x0a2700,
+		.model_id		= 0x000022,
+		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
+	},
+	/* iPod mini */ {
+		.firmware_revision	= 0x0a2700,
 		.model_id		= 0x000023,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
 	},


Thanks,
-- 
Stefan Richter
-=====-==--- ==-- ----=
http://arcgraph.de/sr/


