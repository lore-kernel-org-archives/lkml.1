Return-Path: <linux-kernel-owner+w=401wt.eu-S1030308AbXBZQJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030308AbXBZQJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030309AbXBZQJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:09:19 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:34702 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030308AbXBZQJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:09:17 -0500
To: linux-kernel@vger.kernel.org
CC: sparclinux@vger.kernel.org, devel@openvz.org
From: Monakhov Dmitriy <dmonakhov@openvz.org>
Subject: [PATCH 3/3] SPARC: Handle request_irq() failure
Date: Mon, 26 Feb 2007 19:09:27 +0300
Message-ID: <87y7mkq4so.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [194.85.82.65]); Mon, 26 Feb 2007 19:09:17 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
---
 drivers/sbus/char/uctrl.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/sbus/char/uctrl.c b/drivers/sbus/char/uctrl.c
index 45cf5bc..6b96aa3 100644
--- a/drivers/sbus/char/uctrl.c
+++ b/drivers/sbus/char/uctrl.c
@@ -364,6 +364,7 @@ static int __init ts102_uctrl_init(void)
 	struct linux_prom_irqs tmp_irq[2];
         unsigned int vaddr[2] = { 0, 0 };
 	int tmpnode, uctrlnode = prom_getchild(prom_root_node);
+	int err;
 
 	tmpnode = prom_searchsiblings(uctrlnode, "obio");
 
@@ -389,7 +390,12 @@ static int __init ts102_uctrl_init(void)
 	if(!driver->irq) 
 		driver->irq = tmp_irq[0].pri;
 
-	request_irq(driver->irq, uctrl_interrupt, 0, "uctrl", driver);
+	err = request_irq(driver->irq, uctrl_interrupt, 0, "uctrl", driver);
+	if (err) {
+		printk(KERN_ERR "%s: unable to request irq  %d\n",
+				__FUNCTION__, driver->irq);
+		return -EBUSY;
+	}
 
 	if (misc_register(&uctrl_dev)) {
 		printk("%s: unable to get misc minor %d\n",
-- 
1.5.0.1


