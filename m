Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYCZCMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYCZCMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 22:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYCZCMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 22:12:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:55077 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbYCZCMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 22:12:41 -0400
Message-ID: <47E9B115.9060109@windriver.com>
Date: Wed, 26 Mar 2008 10:12:37 +0800
From: yshi <yang.shi@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: jgarzik@pobox.com
CC: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Improvev netconsole support for RTL8139 NIC driver
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2008 02:12:32.0767 (UTC) FILETIME=[D9CB70F0:01C88EE6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current RTL8139 NIC driver, spin_lock()/spin_unlock() is used
for irq handler. But for netconsole/netpoll, it prefers
spin_lock_irqsave()/spin_unlcok_irqrestore(). So this patch fixed
this problem to improve netconsole/netpoll support.

Signed-off-by: Yang Shi <yang.shi@windriver.com>
---
 b/drivers/net/8139too.c |    9 +++++++++
 1 file changed, 9 insertions(+)
---

--- a/drivers/net/8139too.c
+++ b/drivers/net/8139too.c
@@ -2136,8 +2136,13 @@ static irqreturn_t rtl8139_interrupt (in
        u16 status, ackstat;
        int link_changed = 0; /* avoid bogus "uninit" warning */
        int handled = 0;
+#ifdef CONFIG_NET_POLL_CONTROLLER
+       unsigned long flags;

+       spin_lock_irqsave (&tp->lock, flags);
+#else
        spin_lock (&tp->lock);
+#endif
        status = RTL_R16 (IntrStatus);

        /* shared irq? */
@@ -2185,7 +2190,11 @@ static irqreturn_t rtl8139_interrupt (in
                        RTL_W16 (IntrStatus, TxErr);
        }
  out:
+#ifdef CONFIG_NET_POLL_CONTROLLER
+       spin_unlock_irqrestore (&tp->lock, flags);
+#else
        spin_unlock (&tp->lock);
+#endif

        DPRINTK ("%s: exiting interrupt, intr_status=%#4.4x.\n",
                 dev->name, RTL_R16 (IntrStatus));

