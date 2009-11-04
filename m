Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbZKDQk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbZKDQk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbZKDQk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:40:56 -0500
Received: from xenbox.codefidence.com ([92.48.73.16]:57576 "EHLO
	xenbox.codefidence.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242AbZKDQkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:40:55 -0500
From: Gilad Ben-Yossef <gilad@codefidence.com>
To: Valdis.Kletnieks@vt.edu
Cc: netdev@vger.kernel.org, ori@comsleep.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH testing] Do not call IPv4 specific func in tcp_check_req
Date: Wed,  4 Nov 2009 18:40:54 +0200
Message-Id: <1257352854-19490-1-git-send-email-gilad@codefidence.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <7916.1257300093@turing-police.cc.vt.edu>
References: <7916.1257300093@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling IPv4 specific inet_csk_route_req in tcp_check_req
is a bad idea and crashes machine on IPv6 connections, as reported
by Valdis Kletnieks

Also, all we are really interested in is the timestamp
option in the header, so calling tcp_parse_options()
with the "estab" set to false flag is an overkill as
it tries to parse half a dozen other TCP options.

We know whether timestamp should be enabled or not
using data from request_sock.

Signed-off-by: Gilad Ben-Yossef <gilad@codefidence.com>
---
 net/ipv4/tcp_minisocks.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 8bb560d..c816e50 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -500,11 +500,10 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	int paws_reject = 0;
 	struct tcp_options_received tmp_opt;
 	struct sock *child;
-	struct dst_entry *dst = inet_csk_route_req(sk, req);
 
-	tmp_opt.saw_tstamp = 0;
-	if (th->doff > (sizeof(struct tcphdr)>>2)) {
-		tcp_parse_options(skb, &tmp_opt, 0, dst);
+	if ((th->doff > (sizeof(struct tcphdr)>>2)) && (req->ts_recent)) {
+		tmp_opt.tstamp_ok = 1;
+		tcp_parse_options(skb, &tmp_opt, 1, NULL);
 
 		if (tmp_opt.saw_tstamp) {
 			tmp_opt.ts_recent = req->ts_recent;
@@ -517,8 +516,6 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		}
 	}
 
-	dst_release(dst);
-
 	/* Check for pure retransmitted SYN. */
 	if (TCP_SKB_CB(skb)->seq == tcp_rsk(req)->rcv_isn &&
 	    flg == TCP_FLAG_SYN &&
-- 
1.5.6.3

