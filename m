Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbXLDJtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbXLDJtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 04:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbXLDJtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 04:49:23 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:53867 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbXLDJtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 04:49:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:x-mimeole;
        b=qyni0v/LhdL9Y5iSPqtLB6+HWgvtQn9SJiIFfXkATPZ5y/YEHWH1JIFmPHQZfMcnua5MSymJIOAUssOnsxEiepGpE0bfTJbrb45/q8xsIz4k5SV6ohZ0TH8daXM8BtMeWX94HT3fP/ED8/IebghxdfNybvA2Gyzma0h2qfzFgig=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <netdev@vger.kernel.org>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: NET: ASSERT_RTNL in __dev_set_promiscuity makes debug warning
Date: Tue, 4 Dec 2007 18:48:24 +0900
Message-ID: <000001c8365a$e0e500c0$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acg2WqnJqlBt2MhzT0m6+kks5K+lxg==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
dev_set_rx_mode calls __dev_set_rx_mode with softirq disabled (by netif_tx_lock_bh)
therefore __dev_set_promiscuity can be called with softirq disabled.
It will cause in_interrupt() to return true and ASSERT_RTNL warning.
Is there a good solution to fix it besides blowing ASSERT_RTNL up?

Thanks.
Joonwoo

---
diff --git a/net/core/dev.c b/net/core/dev.c
index 86d6261..6f8e72f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2747,8 +2747,6 @@ static void __dev_set_promiscuity(struct net_device *dev, int inc)
 {
 	unsigned short old_flags = dev->flags;
 
-	ASSERT_RTNL();
-
 	if ((dev->promiscuity += inc) == 0)
 		dev->flags &= ~IFF_PROMISC;
 	else
---

message from e1000 (netdev->set_rx_mode is NULL) + vlan device mac address chage.

WARNING: at kernel/mutex.c:324 __mutex_trylock_slowpath()
Pid: 4523, comm: ifconfig Not tainted 2.6.24-rc3 #179
 [<c400544a>] show_trace_log_lvl+0x1a/0x30
 [<c4005fa2>] show_trace+0x12/0x20
 [<c400679e>] dump_stack+0x6e/0x80
 [<c43b084d>] mutex_trylock+0xcd/0x130
 [<c42dccfd>] rtnl_trylock+0xd/0x10
 [<c42d1f49>] __dev_set_promiscuity+0x19/0x130
 [<c42d20b4>] __dev_set_rx_mode+0x54/0x90
 [<c42d2151>] dev_unicast_add+0x61/0xb0
 [<c438c764>] vlan_set_mac_address+0x104/0x150
 [<c42d2ee1>] dev_set_mac_address+0x51/0x70
 [<c42d3dca>] dev_ifsioc+0x11a/0x270
 [<c42d4131>] dev_ioctl+0x211/0x510
 [<c42c699a>] sock_ioctl+0xea/0x220
 [<c408a468>] do_ioctl+0x28/0x80
 [<c408a517>] vfs_ioctl+0x57/0x280
 [<c408a779>] sys_ioctl+0x39/0x60
 [<c40043ee>] sysenter_past_esp+0x5f/0x85
 =======================

