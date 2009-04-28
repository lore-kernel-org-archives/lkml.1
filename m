Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbZD1JTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbZD1JTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbZD1JTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:19:19 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:16964 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbZD1JTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:19:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ElCLU+8YHl8lGTPkXhDLSEI4kkfbYBQ4o1skjzcOD001AdqW4+fqe2jos/vDnQ32Fm
         xH5REhfbj15CMh4A+8VU5gDbkm3dFSMVt+8x58Je4DD35xzYYmms1fBSVwBxojRPNCS5
         k5VcRnvDuN3kvA9Bw8Uw3KMZH8KKJYlriTk8Q=
Message-ID: <49F6CA0E.5040101@tuffmail.co.uk>
Date: Tue, 28 Apr 2009 10:19:10 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: [PATCH] [RFC] EEE PC hangs when booting off battery
References: <49E065CF.6040408@tuffmail.co.uk> <200904140859.02188.bjorn.helgaas@hp.com> <20090414081728.10de978a@infradead.org> <200904140948.37633.bjorn.helgaas@hp.com> <49E5F01B.2060201@tuffmail.co.uk> <49EF0ABD.2080801@tuffmail.co.uk> <49F446AE.6070607@tuffmail.co.uk>
In-Reply-To: <49F446AE.6070607@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a regression where my EEE hangs at boot time, if the battery is
present.

I'm confident it's a regression because it disappears if I revert
Arjan's asynchronous battery initialisation.  However, the evidence
points to a deadlock in the wireless stack which has simply been
uncovered by timing changes.

If I leave the system long enough, I get a series of hung task
warnings.  They suggest the following deadlock:

- ieee80211_wep_init(), which is called with rtnl_lock() held, is
blocked in request_module() [waiting for modprobe to load a crypto module].
- modprobe is blocked in a call to flush_workqueue(), caused by closing
a TTY.
- worker_thread is blocked because the workqueue item linkwatch_event()
is blocked on rtnl_lock.


I've hacked up a test patch to move wep_init() outside of rtnl_lock, and
it solved the problem.  My one caveat is that it would probably be
cleaner to move it after rtnl_unlock(), instead of before rtnl_lock(). 
I just wasn't 100% sure if that would be safe.  Here's the patch:

---8<---

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index fbcbed6..fffa7f9 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -909,6 +909,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (result < 0)
 		goto fail_sta_info;
 
+	result = ieee80211_wep_init(local);
+	if (result < 0) {
+		printk(KERN_DEBUG "%s: Failed to initialize wep: %d\n",
+		       wiphy_name(local->hw.wiphy), result);
+		goto fail_wep;
+	}
+
 	rtnl_lock();
 	result = dev_alloc_name(local->mdev, local->mdev->name);
 	if (result < 0)
@@ -930,14 +937,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_rate;
 	}
 
-	result = ieee80211_wep_init(local);
-
-	if (result < 0) {
-		printk(KERN_DEBUG "%s: Failed to initialize wep: %d\n",
-		       wiphy_name(local->hw.wiphy), result);
-		goto fail_wep;
-	}
-
 	/* add one default STA interface if supported */
 	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION)) {
 		result = ieee80211_if_add(local, "wlan%d", NULL,
@@ -967,13 +966,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	return 0;
 
-fail_wep:
-	rate_control_deinitialize(local);
 fail_rate:
 	unregister_netdevice(local->mdev);
 	local->mdev = NULL;
 fail_dev:
 	rtnl_unlock();
+fail_wep:
 	sta_info_stop(local);
 fail_sta_info:
 	debugfs_hw_del(local);


