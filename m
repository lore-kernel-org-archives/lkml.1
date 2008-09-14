Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYINIfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYINIfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 04:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYINIfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 04:35:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45785 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbYINIfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 04:35:05 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Sep 2008 10:35:05 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: time out in fw_core_remove_card
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.b3c43c8b09b72285@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows "modprobe -r firewire-ohci" (or card unbinding in general)
to proceed after 40 seconds even if there is a reference counting bug or
other shutdown bug in upper layers.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -16,6 +16,7 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include <linux/bug.h>
 #include <linux/completion.h>
 #include <linux/crc-itu-t.h>
 #include <linux/delay.h>
@@ -508,7 +509,8 @@ fw_core_remove_card(struct fw_card *card
 
 	/* Wait for all users, especially device workqueue jobs, to finish. */
 	fw_card_put(card);
-	wait_for_completion(&card->done);
+	WARN(wait_for_completion_timeout(&card->done, 40 * HZ) == 0,
+	     KBUILD_MODNAME ": forced card shutdown with references held\n");
 
 	cancel_delayed_work_sync(&card->work);
 	WARN_ON(!list_empty(&card->transaction_list));

-- 
Stefan Richter
-=====-==--- =--= -===-
http://arcgraph.de/sr/

