Return-Path: <linux-kernel-owner+w=401wt.eu-S1423384AbXDYVZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423384AbXDYVZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 17:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbXDYVZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 17:25:11 -0400
Received: from canuck.infradead.org ([209.217.80.40]:59905 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbXDYVZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 17:25:09 -0400
Date: Wed, 25 Apr 2007 14:22:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.20.8
Message-ID: <20070425212245.GB21200@kroah.com>
References: <20070425212225.GA21200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425212225.GA21200@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index bc99522..f3539e8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 20
-EXTRAVERSION = .7
+EXTRAVERSION = .8
 NAME = Homicidal Dwarf Hamster
 
 # *DOCUMENTATION*
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index d47b72a..fa2cb8c 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -772,6 +772,8 @@ static void nl_fib_lookup(struct fib_result_nl *frn, struct fib_table *tb )
 				       .nl_u = { .ip4_u = { .daddr = frn->fl_addr,
 							    .tos = frn->fl_tos,
 							    .scope = frn->fl_scope } } };
+
+	frn->err = -ENOENT;
 	if (tb) {
 		local_bh_disable();
 
@@ -783,6 +785,7 @@ static void nl_fib_lookup(struct fib_result_nl *frn, struct fib_table *tb )
 			frn->nh_sel = res.nh_sel;
 			frn->type = res.type;
 			frn->scope = res.scope;
+			fib_res_put(&res);
 		}
 		local_bh_enable();
 	}
@@ -797,6 +800,9 @@ static void nl_fib_input(struct sock *sk, int len)
 	struct fib_table *tb;
 	
 	skb = skb_dequeue(&sk->sk_receive_queue);
+	if (skb == NULL)
+		return;
+
 	nlh = (struct nlmsghdr *)skb->data;
 	if (skb->len < NLMSG_SPACE(0) || skb->len < nlh->nlmsg_len ||
 	    nlh->nlmsg_len < NLMSG_LENGTH(sizeof(*frn))) {
@@ -809,7 +815,7 @@ static void nl_fib_input(struct sock *sk, int len)
 
 	nl_fib_lookup(frn, tb);
 	
-	pid = nlh->nlmsg_pid;           /*pid of sending process */
+	pid = NETLINK_CB(skb).pid;       /* pid of sending process */
 	NETLINK_CB(skb).pid = 0;         /* from kernel */
 	NETLINK_CB(skb).dst_group = 0;  /* unicast */
 	netlink_unicast(sk, skb, pid, MSG_DONTWAIT);
