Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbZG1XvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbZG1XvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZG1Xug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:36 -0400
Received: from kroah.org ([198.145.64.141]:35962 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbZG1Xua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:30 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:42:01 2009
Message-Id: <20090728234201.259462843@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>
Subject: [patch 63/71] netfilter: tcp conntrack: fix unacknowledged data detection with NAT
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=netfilter-tcp-conntrack-fix-unacknowledged-data-detection-with-nat.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick McHardy <kaber@trash.net>

commit a3a9f79e361e864f0e9d75ebe2a0cb43d17c4272 upstream.

When NAT helpers change the TCP packet size, the highest seen sequence
number needs to be corrected. This is currently only done upwards, when
the packet size is reduced the sequence number is unchanged. This causes
TCP conntrack to falsely detect unacknowledged data and decrease the
timeout.

Fix by updating the highest seen sequence number in both directions after
packet mangling.

Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/netfilter/nf_conntrack.h   |    4 ++--
 net/ipv4/netfilter/nf_nat_helper.c     |   17 +++++++++++------
 net/netfilter/nf_conntrack_proto_tcp.c |    6 +++---
 3 files changed, 16 insertions(+), 11 deletions(-)

--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -255,8 +255,8 @@ static inline bool nf_ct_kill(struct nf_
 /* Update TCP window tracking data when NAT mangles the packet */
 extern void nf_conntrack_tcp_update(const struct sk_buff *skb,
 				    unsigned int dataoff,
-				    struct nf_conn *ct,
-				    int dir);
+				    struct nf_conn *ct, int dir,
+				    s16 offset);
 
 /* Fake conntrack entry for untracked connections */
 extern struct nf_conn nf_conntrack_untracked;
--- a/net/ipv4/netfilter/nf_nat_helper.c
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -191,7 +191,8 @@ nf_nat_mangle_tcp_packet(struct sk_buff 
 				    ct, ctinfo);
 		/* Tell TCP window tracking about seq change */
 		nf_conntrack_tcp_update(skb, ip_hdrlen(skb),
-					ct, CTINFO2DIR(ctinfo));
+					ct, CTINFO2DIR(ctinfo),
+					(int)rep_len - (int)match_len);
 
 		nf_conntrack_event_cache(IPCT_NATSEQADJ, ct);
 	}
@@ -377,6 +378,7 @@ nf_nat_seq_adjust(struct sk_buff *skb,
 	struct tcphdr *tcph;
 	int dir;
 	__be32 newseq, newack;
+	s16 seqoff, ackoff;
 	struct nf_conn_nat *nat = nfct_nat(ct);
 	struct nf_nat_seq *this_way, *other_way;
 
@@ -390,15 +392,18 @@ nf_nat_seq_adjust(struct sk_buff *skb,
 
 	tcph = (void *)skb->data + ip_hdrlen(skb);
 	if (after(ntohl(tcph->seq), this_way->correction_pos))
-		newseq = htonl(ntohl(tcph->seq) + this_way->offset_after);
+		seqoff = this_way->offset_after;
 	else
-		newseq = htonl(ntohl(tcph->seq) + this_way->offset_before);
+		seqoff = this_way->offset_before;
 
 	if (after(ntohl(tcph->ack_seq) - other_way->offset_before,
 		  other_way->correction_pos))
-		newack = htonl(ntohl(tcph->ack_seq) - other_way->offset_after);
+		ackoff = other_way->offset_after;
 	else
-		newack = htonl(ntohl(tcph->ack_seq) - other_way->offset_before);
+		ackoff = other_way->offset_before;
+
+	newseq = htonl(ntohl(tcph->seq) + seqoff);
+	newack = htonl(ntohl(tcph->ack_seq) - ackoff);
 
 	inet_proto_csum_replace4(&tcph->check, skb, tcph->seq, newseq, 0);
 	inet_proto_csum_replace4(&tcph->check, skb, tcph->ack_seq, newack, 0);
@@ -413,7 +418,7 @@ nf_nat_seq_adjust(struct sk_buff *skb,
 	if (!nf_nat_sack_adjust(skb, tcph, ct, ctinfo))
 		return 0;
 
-	nf_conntrack_tcp_update(skb, ip_hdrlen(skb), ct, dir);
+	nf_conntrack_tcp_update(skb, ip_hdrlen(skb), ct, dir, seqoff);
 
 	return 1;
 }
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -706,8 +706,8 @@ static bool tcp_in_window(const struct n
 /* Caller must linearize skb at tcp header. */
 void nf_conntrack_tcp_update(const struct sk_buff *skb,
 			     unsigned int dataoff,
-			     struct nf_conn *ct,
-			     int dir)
+			     struct nf_conn *ct, int dir,
+			     s16 offset)
 {
 	const struct tcphdr *tcph = (const void *)skb->data + dataoff;
 	const struct ip_ct_tcp_state *sender = &ct->proto.tcp.seen[dir];
@@ -720,7 +720,7 @@ void nf_conntrack_tcp_update(const struc
 	/*
 	 * We have to worry for the ack in the reply packet only...
 	 */
-	if (after(end, ct->proto.tcp.seen[dir].td_end))
+	if (ct->proto.tcp.seen[dir].td_end + offset == end)
 		ct->proto.tcp.seen[dir].td_end = end;
 	ct->proto.tcp.last_end = end;
 	write_unlock_bh(&tcp_lock);


