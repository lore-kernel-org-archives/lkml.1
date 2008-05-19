Return-Path: <linux-kernel-owner+w=401wt.eu-S1761011AbYESRLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761011AbYESRLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYESRLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:11:12 -0400
Received: from khc.piap.pl ([195.187.100.11]:60910 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbYESRLK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:11:10 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] WAN: protect Cisco HDLC state changes with a spinlock.
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 19 May 2008 19:11:08 +0200
Message-ID: <m3od72gqxf.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WAN: protect Cisco HDLC state changes with a spinlock.
    
Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -55,6 +55,7 @@ struct cisco_state {
 	cisco_proto settings;
 
 	struct timer_list timer;
+	spinlock_t lock;
 	unsigned long last_poll;
 	int up;
 	int request_sent;
@@ -157,6 +158,7 @@ static int cisco_rx(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
 	hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct cisco_state *st = state(hdlc);
 	struct hdlc_header *data = (struct hdlc_header*)skb->data;
 	struct cisco_packet *cisco_data;
 	struct in_device *in_dev;
@@ -219,11 +221,12 @@ static int cisco_rx(struct sk_buff *skb)
 			goto rx_error;
 
 		case CISCO_KEEPALIVE_REQ:
-			state(hdlc)->rxseq = ntohl(cisco_data->par1);
-			if (state(hdlc)->request_sent &&
-			    ntohl(cisco_data->par2) == state(hdlc)->txseq) {
-				state(hdlc)->last_poll = jiffies;
-				if (!state(hdlc)->up) {
+			spin_lock(&st->lock);
+			st->rxseq = ntohl(cisco_data->par1);
+			if (st->request_sent &&
+			    ntohl(cisco_data->par2) == st->txseq) {
+				st->last_poll = jiffies;
+				if (!st->up) {
 					u32 sec, min, hrs, days;
 					sec = ntohl(cisco_data->time) / 1000;
 					min = sec / 60; sec -= min * 60;
@@ -231,12 +234,12 @@ static int cisco_rx(struct sk_buff *skb)
 					days = hrs / 24; hrs -= days * 24;
 					printk(KERN_INFO "%s: Link up (peer "
 					       "uptime %ud%uh%um%us)\n",
-					       dev->name, days, hrs,
-					       min, sec);
+					       dev->name, days, hrs, min, sec);
 					netif_dormant_off(dev);
-					state(hdlc)->up = 1;
+					st->up = 1;
 				}
 			}
+			spin_unlock(&st->lock);
 
 			dev_kfree_skb_any(skb);
 			return NET_RX_SUCCESS;
@@ -260,24 +263,25 @@ static void cisco_timer(unsigned long arg)
 {
 	struct net_device *dev = (struct net_device *)arg;
 	hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct cisco_state *st = state(hdlc);
 
-	if (state(hdlc)->up &&
-	    time_after(jiffies, state(hdlc)->last_poll +
-		       state(hdlc)->settings.timeout * HZ)) {
-		state(hdlc)->up = 0;
+	spin_lock(&st->lock);
+	if (st->up &&
+	    time_after(jiffies, st->last_poll + st->settings.timeout * HZ)) {
+		st->up = 0;
 		printk(KERN_INFO "%s: Link down\n", dev->name);
 		netif_dormant_on(dev);
 	}
 
-	cisco_keepalive_send(dev, CISCO_KEEPALIVE_REQ,
-			     htonl(++state(hdlc)->txseq),
-			     htonl(state(hdlc)->rxseq));
-	state(hdlc)->request_sent = 1;
-	state(hdlc)->timer.expires = jiffies +
-		state(hdlc)->settings.interval * HZ;
-	state(hdlc)->timer.function = cisco_timer;
-	state(hdlc)->timer.data = arg;
-	add_timer(&state(hdlc)->timer);
+	cisco_keepalive_send(dev, CISCO_KEEPALIVE_REQ, htonl(++st->txseq),
+			     htonl(st->rxseq));
+	st->request_sent = 1;
+	spin_unlock(&st->lock);
+
+	st->timer.expires = jiffies + st->settings.interval * HZ;
+	st->timer.function = cisco_timer;
+	st->timer.data = arg;
+	add_timer(&st->timer);
 }
 
 
@@ -285,15 +289,20 @@ static void cisco_timer(unsigned long arg)
 static void cisco_start(struct net_device *dev)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
-	state(hdlc)->up = 0;
-	state(hdlc)->request_sent = 0;
-	state(hdlc)->txseq = state(hdlc)->rxseq = 0;
-
-	init_timer(&state(hdlc)->timer);
-	state(hdlc)->timer.expires = jiffies + HZ; /*First poll after 1s*/
-	state(hdlc)->timer.function = cisco_timer;
-	state(hdlc)->timer.data = (unsigned long)dev;
-	add_timer(&state(hdlc)->timer);
+	struct cisco_state *st = state(hdlc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&st->lock, flags);
+	st->up = 0;
+	st->request_sent = 0;
+	st->txseq = st->rxseq = 0;
+	spin_unlock_irqrestore(&st->lock, flags);
+
+	init_timer(&st->timer);
+	st->timer.expires = jiffies + HZ; /* First poll after 1 s */
+	st->timer.function = cisco_timer;
+	st->timer.data = (unsigned long)dev;
+	add_timer(&st->timer);
 }
 
 
@@ -301,10 +310,16 @@ static void cisco_start(struct net_device *dev)
 static void cisco_stop(struct net_device *dev)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
-	del_timer_sync(&state(hdlc)->timer);
+	struct cisco_state *st = state(hdlc);
+	unsigned long flags;
+
+	del_timer_sync(&st->timer);
+
+	spin_lock_irqsave(&st->lock, flags);
 	netif_dormant_on(dev);
-	state(hdlc)->up = 0;
-	state(hdlc)->request_sent = 0;
+	st->up = 0;
+	st->request_sent = 0;
+	spin_unlock_irqrestore(&st->lock, flags);
 }
 
 
@@ -366,6 +381,7 @@ static int cisco_ioctl(struct net_device *dev, struct ifreq *ifr)
 			return result;
 
 		memcpy(&state(hdlc)->settings, &new_settings, size);
+		spin_lock_init(&state(hdlc)->lock);
 		dev->hard_start_xmit = hdlc->xmit;
 		dev->header_ops = &cisco_header_ops;
 		dev->type = ARPHRD_CISCO;
