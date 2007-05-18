Return-Path: <linux-kernel-owner+w=401wt.eu-S1762922AbXERRI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762922AbXERRI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 13:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762089AbXERRIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 13:08:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524AbXERRIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 13:08:49 -0400
Message-ID: <464DDD29.3000009@redhat.com>
Date: Sat, 19 May 2007 01:06:49 +0800
From: Eugene Teo <eteo@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org
Subject: [2.6 patch] drivers/net/wireless/libertas/fw.c: fix use-before-check
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NULL checks should be performed before the dereference.

Spotted by the Coverity checker.

Signed-off-by: Eugene Teo <eteo@redhat.com>

diff --git a/drivers/net/wireless/libertas/fw.c b/drivers/net/wireless/libertas/fw.c
index 441123c..5c63c9b 100644
--- a/drivers/net/wireless/libertas/fw.c
+++ b/drivers/net/wireless/libertas/fw.c
@@ -333,18 +333,22 @@ static void command_timer_fn(unsigned long data)
        unsigned long flags;

        ptempnode = adapter->cur_cmd;
+       if (ptempnode == NULL) {
+               lbs_pr_debug(1, "PTempnode Empty\n");
+               return;
+       }
+
        cmd = (struct cmd_ds_command *)ptempnode->bufvirtualaddr;
+       if (!cmd) {
+               lbs_pr_debug(1, "cmd is NULL\n");
+               return;
+       }

        lbs_pr_info("command_timer_fn fired (%x)\n", cmd->command);

        if (!adapter->fw_ready)
                return;

-       if (ptempnode == NULL) {
-               lbs_pr_debug(1, "PTempnode Empty\n");
-               return;
-       }
-
        spin_lock_irqsave(&adapter->driver_lock, flags);
        adapter->cur_cmd = NULL;
        spin_unlock_irqrestore(&adapter->driver_lock, flags);
