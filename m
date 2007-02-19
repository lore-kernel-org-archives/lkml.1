Return-Path: <linux-kernel-owner+w=401wt.eu-S965097AbXBSWLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965097AbXBSWLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 17:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965099AbXBSWLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 17:11:33 -0500
Received: from mail.screens.ru ([213.234.233.54]:60922 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965097AbXBSWLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 17:11:32 -0500
Date: Tue, 20 Feb 2007 01:11:25 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: PATCH? net/bridge/br_if.c: fix use after free in port_carrier_check()
Message-ID: <20070219221125.GA5070@tv-sign.ru>
References: <20070218214359.GA4226@tv-sign.ru> <8462.1171884453@redhat.com> <20070219115955.GB91@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070219115955.GB91@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Oleg Nesterov wrote:
>
> I think the fix should be so that port_carrier_check() does get/put on
> "struct net_bridge_port" (container), but not on "struct net_device", and
>
> del_nbp(struct net_bridge_port *p)
>
> 	if (cancel_delayed_work(&p->carrier_check))
> -		dev_put(p->dev);
> +		kobject_put(&p->kobj);

Perhaps something like the patch below? (on top of this patch).
We should do something, the stable tree has the same bug.

Oleg.

--- WQ/net/bridge/br_if.c~5_bridge_uaf	2007-02-18 23:06:15.000000000 +0300
+++ WQ/net/bridge/br_if.c	2007-02-20 00:59:54.000000000 +0300
@@ -83,14 +83,14 @@ static void port_carrier_check(struct wo
 	struct net_device *dev;
 	struct net_bridge *br;
 
-	dev = container_of(work, struct net_bridge_port,
-			   carrier_check.work)->dev;
+	p = container_of(work, struct net_bridge_port, carrier_check.work);
 
 	rtnl_lock();
-	p = dev->br_port;
-	if (!p)
-		goto done;
 	br = p->br;
+	dev = p->dev;
+
+	if (!dev->br_port)
+		goto done;
 
 	if (netif_carrier_ok(dev))
 		p->path_cost = port_cost(dev);
@@ -107,14 +107,16 @@ static void port_carrier_check(struct wo
 		spin_unlock_bh(&br->lock);
 	}
 done:
-	dev_put(dev);
 	rtnl_unlock();
+	kobject_put(&p->kobj);
 }
 
 static void release_nbp(struct kobject *kobj)
 {
 	struct net_bridge_port *p
 		= container_of(kobj, struct net_bridge_port, kobj);
+
+	dev_put(p->dev);
 	kfree(p);
 }
 
@@ -127,12 +129,6 @@ static struct kobj_type brport_ktype = {
 
 static void destroy_nbp(struct net_bridge_port *p)
 {
-	struct net_device *dev = p->dev;
-
-	p->br = NULL;
-	p->dev = NULL;
-	dev_put(dev);
-
 	kobject_put(&p->kobj);
 }
 
@@ -162,7 +158,7 @@ static void del_nbp(struct net_bridge_po
 	dev_set_promiscuity(dev, -1);
 
 	if (cancel_delayed_work(&p->carrier_check))
-		dev_put(dev);
+		kobject_put(&p->kobj);
 
 	spin_lock_bh(&br->lock);
 	br_stp_disable_port(p);
@@ -446,7 +442,7 @@ int br_add_if(struct net_bridge *br, str
 	br_stp_recalculate_bridge_id(br);
 	br_features_recompute(br);
 	if (schedule_delayed_work(&p->carrier_check, BR_PORT_DEBOUNCE))
-		dev_hold(dev);
+		kobject_get(&p->kobj);
 
 	spin_unlock_bh(&br->lock);
 

