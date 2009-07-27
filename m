Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbZG0Pce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbZG0Pce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbZG0PbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:31:24 -0400
Received: from smtp-out.google.com ([216.239.45.13]:16449 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbZG0PbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:31:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=aU420+IKP8437RLlPhdp2Uq243y6zVZf5HAtDYqFGIghsCpjVuhpN/aDysC/xL5jz
	WjB+pcNH9a89S78MzxgZg==
Subject: [RFC][PATCH 4/5] IPVS: debugging output for ip_vs_update_conntrack
To: lvs-devel@vger.kernel.org
From: Hannes Eder <heder@google.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Mon, 27 Jul 2009 15:46:31 +0200
Message-ID: <20090727134631.12897.59167.stgit@jazzy.zrh.corp.google.com>
In-Reply-To: <20090727134457.12897.272.stgit@jazzy.zrh.corp.google.com>
References: <20090727134457.12897.272.stgit@jazzy.zrh.corp.google.com>
User-Agent: StGit/0.14.3.366.gf979
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is not ment to be merged, its mere for debugging during
development.

Signed-off-by: Hannes Eder <heder@google.com>

 net/netfilter/ipvs/ip_vs_xmit.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index f3b6810..ed6b811 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -24,6 +24,7 @@
 #include <net/ip6_route.h>
 #include <linux/icmpv6.h>
 #include <linux/netfilter.h>
+#define DEBUG
 #include <net/netfilter/nf_conntrack.h>
 #include <linux/netfilter_ipv4.h>
 
@@ -345,12 +346,31 @@ ip_vs_bypass_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 }
 #endif
 
+#ifdef DEBUG
+static void
+ip_vs_dump_ct_tuple(const struct nf_conntrack_tuple *t)
+{
+	/*
+	 * We ignore the fact that this is not SMP-safe.  Otherwise we would
+	 * have to duplicate code and this code is not ment to stay here anyway.
+	 */
+	printk(KERN_DEBUG "IPVS: ");
+	nf_ct_dump_tuple(t);
+}
+#endif
+
 static void
 ip_vs_update_conntrack(struct sk_buff *skb, struct ip_vs_conn *cp)
 {
 	if (skb->nfct) {
 		struct nf_conn *ct = (struct nf_conn *)skb->nfct;
 
+#ifdef DEBUG
+		ip_vs_dump_ct_tuple(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+		ip_vs_dump_ct_tuple(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+		printk("IPVS: nfct confirmed=%d\n", nf_ct_is_confirmed(ct));
+#endif
+
 		if (ct != &nf_conntrack_untracked && !nf_ct_is_confirmed(ct)) {
 			/*
 			 * The connection is not yet in the hashtable, so we
@@ -365,6 +385,12 @@ ip_vs_update_conntrack(struct sk_buff *skb, struct ip_vs_conn *cp)
 			ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.tcp.port =
 				cp->dport;
 		}
+
+#ifdef DEBUG
+		ip_vs_dump_ct_tuple(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+		ip_vs_dump_ct_tuple(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+#endif
+
 	}
 }
 

