Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbZBWUBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbZBWUBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbZBWUBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:01:44 -0500
Received: from smtp-out.google.com ([216.239.33.17]:11735 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbZBWUBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:01:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding:x-system-of-record;
	b=wnWwx+hSksSEBVpx2/yepfnBAhtqD8AXqqF5BvEyVz+jBBDKvK32DX6AbK1pRDlxL
	AabBW5DNBzqrQxgKCA/5Q==
MIME-Version: 1.0
Date: Mon, 23 Feb 2009 12:01:38 -0800
Message-ID: <97949e3e0902231201n4781d2c4q261bfc62ba1cb7fc@mail.gmail.com>
Subject: Subject: [PATCH 001/001] bonding: add support for netdev link events.
From: Laurent Chavey <chavey@google.com>
To: Jay Vosburgh <fubar@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Chavey <chavey@google.com>

kernel:2.6.28

Add a netdev link event handler so the bond state machine can react to
link state changes using async netdev events rather than having to
use mii monitor polling.

Signed-off-by: Laurent Chavey <chavey@google.com>
---


--- linux-2.6.28.org/drivers/net/bonding/bond_main.c	2008-12-24
15:26:37.000000000 -0800
+++ linux-2.6.28/drivers/net/bonding/bond_main.c	2009-02-23
10:59:12.000000000 -0800
@@ -2477,7 +2477,11 @@ void bond_mii_monitor(struct work_struct
 	}

 re_arm:
-	if (bond->params.miimon)
+	 /* A netdev event may have set some delay work, in that
+	  * case do not remove it and let it take priority.
+	  */
+	if  (bond->params.miimon && !bond->kill_timers &&
+	     !delayed_work_pending(&bond->mii_work))
 		queue_delayed_work(bond->wq, &bond->mii_work,
 				   msecs_to_jiffies(bond->params.miimon));
 out:
@@ -3521,6 +3525,33 @@ static int bond_master_netdev_event(unsi
 	return NOTIFY_DONE;
 }

+static inline void bond_netdev_link_event(struct bonding *bond)
+{
+	if (!bond->params.use_carrier)
+		return;
+
+	write_lock_bh(&bond->lock);
+	if (bond->kill_timers) {
+		write_unlock_bh(&bond->lock);
+		return;
+	}
+
+	if (delayed_work_pending(&bond->mii_work)) {
+		/* cancel_delayed_work(&bond->mii_work); calls del_timer_sync().
+		 * We implement a version that does not call del_timer_sync().
+		 *  if an active timer is found, then the job is not on the WQ.
+		 *    we clear the PENDING bit, so the job can be added later
+		 *  else the job maybe done (PENDING bit is clear) or it maybe
+		 *    running, then we do not care and do only  add a new job
+		 *    if the job has completed.
+		 */
+		if (del_timer(&bond->mii_work.timer))
+			work_clear_pending(&bond->mii_work.work);
+	}
+	queue_delayed_work(bond->wq, &bond->mii_work, 0);
+	write_unlock_bh(&bond->lock);
+}
+
 static int bond_slave_netdev_event(unsigned long event, struct
net_device *slave_dev)
 {
 	struct net_device *bond_dev = slave_dev->master;
@@ -3536,15 +3567,17 @@ static int bond_slave_netdev_event(unsig
 		}
 		break;
 	case NETDEV_CHANGE:
-		/*
-		 * TODO: is this what we get if somebody
-		 * sets up a hierarchical bond, then rmmod's
-		 * one of the slave bonding devices?
-		 */
-		break;
+	case NETDEV_UP:
 	case NETDEV_DOWN:
+		if (bond_dev && bond_dev->priv &&
+		    ARPHRD_ETHER == slave_dev->type) {
+			bond_netdev_link_event(bond_dev->priv);
+		}
+
 		/*
-		 * ... Or is it this?
+		 * TODO: do we get a NETDEV_CHANGE or NETDEV_DOWN event
+		 * if somebody sets up a hierarchical bond, then rmmod's
+		 * one of the slave bonding devices?
 		 */
 		break;
 	case NETDEV_CHANGEMTU:
@@ -5196,4 +5229,3 @@ MODULE_SUPPORTED_DEVICE("most ethernet d
  *  tab-width: 8
  * End:
  */
-
