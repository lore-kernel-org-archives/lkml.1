Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbYCZQd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbYCZQd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758955AbYCZQdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:33:19 -0400
Received: from anchor-post-31.mail.demon.net ([194.217.242.89]:4257 "EHLO
	anchor-post-31.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756887AbYCZQdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:33:17 -0400
Subject: [patch] usb ohci : fix 2 timers to fire at jiffies + 1s
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: linux-usb <linux-usb@vger.kernel.org>
Cc: dbrownell@users.sourceforge.net, lkml <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <Pine.LNX.4.44L0.0803261136590.6324-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0803261136590.6324-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 16:32:23 +0000
Message-Id: <1206549143.2931.27.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Code inspection discovered in 2 places timers were being
    incorrectly setup using round_jiffies_relative(HZ).
    The timer would then fire at time (0 <= T < HZ).
    
    Fix them to use round_jiffies(jiffies + HZ);
    
    Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---

compiled on latest v2.6.25-rc7-11 git head but not otherwise tested.
Richard

diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index dd4798e..33f1c1c 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -467,7 +467,7 @@ static void unlink_watchdog_func(unsigned long _ohci)
 out:
 	kfree(seen);
 	if (ohci->eds_scheduled)
-		mod_timer(&ohci->unlink_watchdog, round_jiffies_relative(HZ));
+		mod_timer(&ohci->unlink_watchdog, round_jiffies(jiffies + HZ));
 done:
 	spin_unlock_irqrestore(&ohci->lock, flags);
 }
diff --git a/drivers/usb/host/ohci-q.c b/drivers/usb/host/ohci-q.c
index 5181732..9c9f3b5 100644
--- a/drivers/usb/host/ohci-q.c
+++ b/drivers/usb/host/ohci-q.c
@@ -169,7 +169,7 @@ static int ed_schedule (struct ohci_hcd *ohci, struct ed *ed)
 	if (quirk_zfmicro(ohci)
 			&& (ed->type == PIPE_INTERRUPT)
 			&& !(ohci->eds_scheduled++))
-		mod_timer(&ohci->unlink_watchdog, round_jiffies_relative(HZ));
+		mod_timer(&ohci->unlink_watchdog, round_jiffies(jiffies + HZ));
 	wmb ();
 
 	/* we care about rm_list when setting CLE/BLE in case the HC was at


