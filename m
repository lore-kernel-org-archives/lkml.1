Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbXBRVoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbXBRVoB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 16:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbXBRVoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 16:44:00 -0500
Received: from mail.screens.ru ([213.234.233.54]:56899 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbXBRVoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 16:44:00 -0500
Date: Mon, 19 Feb 2007 00:43:59 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       "David S. Miller" <davem@davemloft.net>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] net/bridge/br_if.c: don't use _WORK_NAR
Message-ID: <20070218214359.GA4226@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Afaics, noautorel work_struct buys nothing for "struct net_bridge_port".

If del_nbp()->cancel_delayed_work(&p->carrier_check) fails, port_carrier_check
may be called later anyway. So the reading of *work in port_carrier_check() is
equally unsafe with or without this patch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- WQ/net/bridge/br_if.c~1_bridge	2007-02-18 22:56:49.000000000 +0300
+++ WQ/net/bridge/br_if.c	2007-02-18 23:06:15.000000000 +0300
@@ -85,7 +85,6 @@ static void port_carrier_check(struct wo
 
 	dev = container_of(work, struct net_bridge_port,
 			   carrier_check.work)->dev;
-	work_release(work);
 
 	rtnl_lock();
 	p = dev->br_port;
@@ -282,7 +281,7 @@ static struct net_bridge_port *new_nbp(s
 	p->port_no = index;
 	br_init_port(p);
 	p->state = BR_STATE_DISABLED;
-	INIT_DELAYED_WORK_NAR(&p->carrier_check, port_carrier_check);
+	INIT_DELAYED_WORK(&p->carrier_check, port_carrier_check);
 	br_stp_port_timer_init(p);
 
 	kobject_init(&p->kobj);

