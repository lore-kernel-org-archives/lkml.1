Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934924Ab0CMBTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:19:51 -0500
Received: from kroah.org ([198.145.64.141]:60946 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934961Ab0CMAUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:34 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:11 2010
Message-Id: <20100313001511.814182092@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tim Gardner <tim.gardner@canonical.com>,
       Patrick McHardy <kaber@trash.net>
Subject: [patch 076/123] netfilter: xt_recent: fix buffer overflow
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Tim Gardner <tim.gardner@canonical.com>

commit 2c08522e5d2f0af2d6f05be558946dcbf8173683 upstream.

e->index overflows e->stamps[] every ip_pkt_list_tot packets.

Consider the case when ip_pkt_list_tot==1; the first packet received is stored
in e->stamps[0] and e->index is initialized to 1. The next received packet
timestamp is then stored at e->stamps[1] in recent_entry_update(),
a buffer overflow because the maximum e->stamps[] index is 0.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/xt_recent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -173,10 +173,10 @@ recent_entry_init(struct recent_table *t
 
 static void recent_entry_update(struct recent_table *t, struct recent_entry *e)
 {
+	e->index %= ip_pkt_list_tot;
 	e->stamps[e->index++] = jiffies;
 	if (e->index > e->nstamps)
 		e->nstamps = e->index;
-	e->index %= ip_pkt_list_tot;
 	list_move_tail(&e->lru_list, &t->lru_list);
 }
 


