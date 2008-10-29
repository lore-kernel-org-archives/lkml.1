Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbYJ2W7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbYJ2W7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbYJ2Wqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:46:30 -0400
Received: from kroah.org ([198.145.64.141]:56286 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756019AbYJ2WqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:46:15 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: "vijaykumar@bravegnu.org" <vijaykumar@bravegnu.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 43/49] Staging: poch: Fix user space protocol syncing
Date: Wed, 29 Oct 2008 15:40:10 -0700
Message-Id: <1225320016-21803-43-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: vijaykumar@bravegnu.org <vijaykumar@bravegnu.org>

Always set the user space offset from kernel space, to indicate group
transmitted/received.

Signed-off-by: Vijay Kumar <vijaykumar@bravegnu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/poch/poch.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/poch/poch.c b/drivers/staging/poch/poch.c
index 0a3eca1..3ecbd7c 100644
--- a/drivers/staging/poch/poch.c
+++ b/drivers/staging/poch/poch.c
@@ -948,14 +948,7 @@ static int poch_channel_available(struct channel_info *channel)
 	spin_lock_irq(&channel->group_offsets_lock);
 
 	for (i = 0; i < channel->group_count; i++) {
-		if (channel->dir == CHANNEL_DIR_RX
-		    && channel->header->group_offsets[i] == -1) {
-			spin_unlock_irq(&channel->group_offsets_lock);
-			return 1;
-		}
-
-		if (channel->dir == CHANNEL_DIR_TX
-		    && channel->header->group_offsets[i] != -1) {
+		if (channel->header->group_offsets[i] != -1) {
 			spin_unlock_irq(&channel->group_offsets_lock);
 			return 1;
 		}
@@ -1103,10 +1096,7 @@ static void poch_irq_dma(struct channel_info *channel)
 
 	for (i = 0; i < groups_done; i++) {
 		j = (prev_transfer + i) % channel->group_count;
-		if (channel->dir == CHANNEL_DIR_RX)
-			group_offsets[j] = -1;
-		else
-			group_offsets[j] = groups[j].user_offset;
+		group_offsets[j] = groups[j].user_offset;
 	}
 
 	spin_unlock(&channel->group_offsets_lock);
-- 
1.6.0.2

