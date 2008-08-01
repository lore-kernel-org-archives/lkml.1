Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYHAHpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYHAHpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 03:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbYHAHpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 03:45:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:5998 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbYHAHpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 03:45:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=uo3Gdt4IBesrj2QvKHL5Ujs+YYh+jmnoDUIdSLHNEM7hFLZYOrPaEQroOi24b8bU7k
         Mm3iHWwg5FQjHHgJtwvGOv7BdmZmfePF9KZ/ariAJzxNtIlqckUVWk6g2LmQNXy3AU0P
         qGieYjRr8nLO5hj6WQmcRRJp1D8O5jzesyoXc=
Date: Fri, 1 Aug 2008 15:46:16 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: jirislaby@gmail.com
Cc: johannes@sipsolutions.net, akpm@linux-foundation.org,
       penberg@cs.helsinki.fi, tomasw@gmail.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: [PATCH] ath5k : ath5k_config_interface deadlock fix
Message-ID: <20080801074014.GA3341@darkstar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the drivers/net/wireless/ath5k/base.c, there's recursive locking of sc->lock
This casue the kernel stuck

Bug report please see:
http://lkml.org/lkml/2008/7/29/32

Fixed it by remove the lock in sub routine "ath5k_beacon_update",
The ath5k_config_interface is the only caller to it.

[  171.430207] =============================================
[  171.432140] [ INFO: possible recursive locking detected ]
[  171.433113] 2.6.27-rc1-smp #4
[  171.434079] ---------------------------------------------
[  171.435039] ath5k_pci/2447 is trying to acquire lock:
[  171.435990]  (&sc->lock){--..}, at: [<f89ee9b5>] ath5k_config_interface+0xd5/0x340 [ath5k]
[  171.437046] 
[  171.437048] but task is already holding lock:
[  171.438903]  (&sc->lock){--..}, at: [<f89ee91d>] ath5k_config_interface+0x3d/0x340 [ath5k]
[  171.439953] 
[  171.439954] other info that might help us debug this:
[  171.441795] 3 locks held by ath5k_pci/2447:
[  171.442729]  #0:  ((name)){--..}, at: [<c013a122>] run_workqueue+0x102/0x1d0
[  171.443800]  #1:  (&(&local->scan_work)->work){--..}, at: [<c013a122>] run_workqueue+0x102/0x1d0
[  171.444859]  #2:  (&sc->lock){--..}, at: [<f89ee91d>] ath5k_config_interface+0x3d/0x340 [ath5k]
[  171.445941] 
[  171.445942] stack backtrace:
[  171.447791] Pid: 2447, comm: ath5k_pci Not tainted 2.6.27-rc1-smp #4
[  171.448732]  [<c014d69f>] __lock_acquire+0xa8f/0x11b0
[  171.449698]  [<c014de41>] lock_acquire+0x81/0xa0
[  171.450655]  [<f89ee9b5>] ? ath5k_config_interface+0xd5/0x340 [ath5k]
[  171.451651]  [<c046073b>] mutex_lock_nested+0x9b/0x280
[  171.452609]  [<f89ee9b5>] ? ath5k_config_interface+0xd5/0x340 [ath5k]
[  171.453588]  [<f89ee9b5>] ? ath5k_config_interface+0xd5/0x340 [ath5k]
[  171.454555]  [<f89ee9b5>] ath5k_config_interface+0xd5/0x340 [ath5k]
[  171.455485]  [<c0184082>] ? check_object+0xe2/0x1e0
[  171.456428]  [<c014c7cb>] ? trace_hardirqs_on+0xb/0x10
[  171.457377]  [<c014c73d>] ? trace_hardirqs_on_caller+0xbd/0x140
[  171.458334]  [<c014c7cb>] ? trace_hardirqs_on+0xb/0x10
[  171.459304]  [<c03eb31c>] ? dev_alloc_skb+0x1c/0x30
[  171.460276]  [<f89a3747>] ieee80211_if_config+0x97/0x160 [mac80211]
[  171.461237]  [<f89a95bc>] ieee80211_sta_join_ibss+0x25c/0x3e0 [mac80211]
[  171.462196]  [<c012f070>] ? local_bh_enable_ip+0x80/0xc0
[  171.463171]  [<f89ab325>] ieee80211_sta_find_ibss+0x365/0x4b0 [mac80211]
[  171.464134]  [<f89ab8ab>] ieee80211_scan_completed+0x2cb/0x320 [mac80211]
[  171.465097]  [<f89ab7de>] ? ieee80211_scan_completed+0x1fe/0x320 [mac80211]
[  171.466084]  [<f89af3b3>] ieee80211_sta_scan_work+0xa3/0x1f0 [mac80211]
[  171.467054]  [<c013a122>] ? run_workqueue+0x102/0x1d0
[  171.468026]  [<c013a175>] run_workqueue+0x155/0x1d0
[  171.468978]  [<c013a122>] ? run_workqueue+0x102/0x1d0
[  171.469947]  [<c014c7cb>] ? trace_hardirqs_on+0xb/0x10
[  171.470925]  [<f89af310>] ? ieee80211_sta_scan_work+0x0/0x1f0 [mac80211]
[  171.471924]  [<c013ac68>] worker_thread+0x88/0xe0
[  171.472880]  [<c013da70>] ? autoremove_wake_function+0x0/0x40
[  171.473862]  [<c013abe0>] ? worker_thread+0x0/0xe0
[  171.474835]  [<c013d782>] kthread+0x42/0x70
[  171.475789]  [<c013d740>] ? kthread+0x0/0x70
[  171.476765]  [<c01048e7>] kernel_thread_helper+0x7/0x10

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

drivers/net/wireless/ath5k/base.c |    6 +++---
1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.26/drivers/net/wireless/ath5k/base.c
===================================================================
--- linux-2.6.26.orig/drivers/net/wireless/ath5k/base.c	2008-08-01 12:55:16.000000000 +0800
+++ linux-2.6.26/drivers/net/wireless/ath5k/base.c	2008-08-01 14:01:15.000000000 +0800
@@ -3024,6 +3024,9 @@
 		ath5k_hw_reset_tsf(sc->ah);
 }
 
+/*
+ * caller need lock the hw->sc->lock for us.
+ */
 static int
 ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
@@ -3032,8 +3035,6 @@
 
 	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
 
-	mutex_lock(&sc->lock);
-
 	if (sc->opmode != IEEE80211_IF_TYPE_IBSS) {
 		ret = -EIO;
 		goto end;
@@ -3048,7 +3049,6 @@
 		ath5k_beacon_config(sc);
 
 end:
-	mutex_unlock(&sc->lock);
 	return ret;
 }
 
