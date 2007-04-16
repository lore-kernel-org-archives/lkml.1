Return-Path: <linux-kernel-owner+w=401wt.eu-S1030495AbXDPMEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030495AbXDPMEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 08:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030501AbXDPMEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 08:04:15 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:46381 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030495AbXDPMEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 08:04:14 -0400
Message-ID: <46236739.5000409@sw.ru>
Date: Mon, 16 Apr 2007 16:08:25 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH] Set a separate lockdep class for neighbour table's proxy_queue
Content-Type: multipart/mixed;
 boundary="------------000704030900030605080103"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000704030900030605080103
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Otherwise the following calltrace will lead to a wrong
lockdep warning:

  neigh_proxy_process()
    `- lock(neigh_table->proxy_queue.lock);
  arp_redo /* via tbl->proxy_redo */
  arp_process
  neigh_event_ns
  neigh_update
  skb_queue_purge
    `- lock(neighbor->arp_queue.lock);

This is not a deadlock actually, as neighbor table's proxy_queue
and the neighbor's arp_queue are different queues.

Lockdep thinks there is a deadlock as both queues are initialized
with skb_queue_head_init() and thus have a common class.

--------------000704030900030605080103
Content-Type: text/plain;
 name="diff-set-lockdep-class-for-neighbour-table-skb-list"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff-set-lockdep-class-for-neighbour-table-skb-list"

--- a/include/linux/skbuff.h	2007-04-09 22:52:27.000000000 +0400
+++ b/include/linux/skbuff.h	2007-04-09 22:52:32.000000000 +0400
@@ -628,6 +628,13 @@ static inline void skb_queue_head_init(s
 	list->qlen = 0;
 }
 
+static inline void skb_queue_head_init_class(struct sk_buff_head *list,
+		struct lock_class_key *class)
+{
+	skb_queue_head_init(list);
+	lockdep_set_class(&list->lock, class);
+}
+
 /*
  *	Insert an sk_buff at the start of a list.
  *
--- a/net/core/neighbour.c	2007-04-09 22:52:28.000000000 +0400
+++ b/net/core/neighbour.c	2007-04-09 22:53:01.000000000 +0400
@@ -1327,6 +1327,8 @@ void neigh_parms_destroy(struct neigh_pa
 	kfree(parms);
 }
 
+static struct lock_class_key neigh_table_proxy_queue_class;
+
 void neigh_table_init_no_netlink(struct neigh_table *tbl)
 {
 	unsigned long now = jiffies;
@@ -1379,7 +1381,8 @@ void neigh_table_init_no_netlink(struct 
 	init_timer(&tbl->proxy_timer);
 	tbl->proxy_timer.data	  = (unsigned long)tbl;
 	tbl->proxy_timer.function = neigh_proxy_process;
-	skb_queue_head_init(&tbl->proxy_queue);
+	skb_queue_head_init_class(&tbl->proxy_queue,
+			&neigh_table_proxy_queue_class);
 
 	tbl->last_flush = now;
 	tbl->last_rand	= now + tbl->parms.reachable_time * 20;

--------------000704030900030605080103--
