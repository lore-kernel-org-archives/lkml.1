Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYGLMvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYGLMvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 08:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYGLMvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 08:51:35 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49863 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbYGLMve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 08:51:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 12 Jul 2008 14:51:18 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 4/4] firewire: warn on unfinished transactions during card
 removal
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3186168349c88b15@s5r6.in-berlin.de>
Message-ID: <tkrat.c73716c44f10b8fb@s5r6.in-berlin.de>
References: <tkrat.3186168349c88b15@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After card->done and card->work are completed, any remaining pending
request would be a bug.  We cannot safely complete a transaction at
that point anymore.

IOW card users must not drop their last fw_card reference (usually
indirect references through fw_device references) before their last
outbound transaction through that card was finished.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -539,7 +539,7 @@ fw_core_remove_card(struct fw_card *card
 	wait_for_completion(&card->done);
 
 	cancel_delayed_work_sync(&card->work);
-	fw_flush_transactions(card);
+	WARN_ON(!list_empty(&card->transaction_list));
 	del_timer_sync(&card->flush_timer);
 }
 EXPORT_SYMBOL(fw_core_remove_card);

-- 
Stefan Richter
-=====-==--- -=== -==--
http://arcgraph.de/sr/

