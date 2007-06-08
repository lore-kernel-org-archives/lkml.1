Return-Path: <linux-kernel-owner+w=401wt.eu-S967962AbXFHH3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967962AbXFHH3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936864AbXFHHTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:19:10 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:57596 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966891AbXFHHTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:19:07 -0400
Message-Id: <20070608071535.477108000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:17 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>, Adrian Bunk <bunk@stusta.de>,
       Jorge Boncompte <jorge@dti2.net>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 06/32] [NETFILTER]: {ip, nf}_nat_proto_gre: do not modify/corrupt GREv0 packets through NAT
Content-Disposition: inline; filename=ip-nf-_nat_proto_gre-do-not-modify-corrupt-grev0-packets-through-nat.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jorge Boncompte <jorge@dti2.net>

While porting some changes of the 2.6.21-rc7 pptp/proto_gre conntrack
and nat modules to a 2.4.32 kernel I noticed that the gre_key function
returns a wrong pointer to the GRE key of a version 0 packet thus
corrupting the packet payload.

The intended behaviour for GREv0 packets is to act like
nf_conntrack_proto_generic/nf_nat_proto_unknown so I have ripped the
offending functions (not used anymore) and modified the
nf_nat_proto_gre modules to not touch version 0 (non PPTP) packets.

Signed-off-by: Jorge Boncompte <jorge@dti2.net>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
commit 244c67aee5750eb3a79c727d09c01a500e68bbbe
tree 29bbce944bba681886a6d58c0c6b7bca3858c0e1
parent 8d8b10482fffcb72b15515231bb942e2ad6395c9
author Jorge Boncompte <jorge@dti2.net> Thu, 03 May 2007 02:50:51 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 03 May 2007 02:50:51 +0200

 include/linux/netfilter/nf_conntrack_proto_gre.h      |   18 ----------------
 include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h |   19 -----------------
 net/ipv4/netfilter/ip_nat_proto_gre.c                 |   20 +++++++-----------
 net/ipv4/netfilter/nf_nat_proto_gre.c                 |   20 +++++++-----------
 4 files changed, 16 insertions(+), 61 deletions(-)

--- linux-2.6.20.13.orig/include/linux/netfilter/nf_conntrack_proto_gre.h
+++ linux-2.6.20.13/include/linux/netfilter/nf_conntrack_proto_gre.h
@@ -87,24 +87,6 @@ int nf_ct_gre_keymap_add(struct nf_conn 
 /* delete keymap entries */
 void nf_ct_gre_keymap_destroy(struct nf_conn *ct);
 
-/* get pointer to gre key, if present */
-static inline __be32 *gre_key(struct gre_hdr *greh)
-{
-	if (!greh->key)
-		return NULL;
-	if (greh->csum || greh->routing)
-		return (__be32 *)(greh+sizeof(*greh)+4);
-	return (__be32 *)(greh+sizeof(*greh));
-}
-
-/* get pointer ot gre csum, if present */
-static inline __sum16 *gre_csum(struct gre_hdr *greh)
-{
-	if (!greh->csum)
-		return NULL;
-	return (__sum16 *)(greh+sizeof(*greh));
-}
-
 extern void nf_ct_gre_keymap_flush(void);
 extern void nf_nat_need_gre(void);
 
--- linux-2.6.20.13.orig/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h
+++ linux-2.6.20.13/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h
@@ -90,25 +90,6 @@ int ip_ct_gre_keymap_add(struct ip_connt
 /* delete keymap entries */
 void ip_ct_gre_keymap_destroy(struct ip_conntrack *ct);
 
-
-/* get pointer to gre key, if present */
-static inline __be32 *gre_key(struct gre_hdr *greh)
-{
-	if (!greh->key)
-		return NULL;
-	if (greh->csum || greh->routing)
-		return (__be32 *) (greh+sizeof(*greh)+4);
-	return (__be32 *) (greh+sizeof(*greh));
-}
-
-/* get pointer ot gre csum, if present */
-static inline __sum16 *gre_csum(struct gre_hdr *greh)
-{
-	if (!greh->csum)
-		return NULL;
-	return (__sum16 *) (greh+sizeof(*greh));
-}
-
 #endif /* __KERNEL__ */
 
 #endif /* _CONNTRACK_PROTO_GRE_H */
--- linux-2.6.20.13.orig/net/ipv4/netfilter/ip_nat_proto_gre.c
+++ linux-2.6.20.13/net/ipv4/netfilter/ip_nat_proto_gre.c
@@ -70,6 +70,11 @@ gre_unique_tuple(struct ip_conntrack_tup
 	__be16 *keyptr;
 	unsigned int min, i, range_size;
 
+	/* If there is no master conntrack we are not PPTP,
+	   do not change tuples */
+	if (!conntrack->master)
+		return 0;
+		
 	if (maniptype == IP_NAT_MANIP_SRC)
 		keyptr = &tuple->src.u.gre.key;
 	else
@@ -122,18 +127,9 @@ gre_manip_pkt(struct sk_buff **pskb,
 	if (maniptype == IP_NAT_MANIP_DST) {
 		/* key manipulation is always dest */
 		switch (greh->version) {
-		case 0:
-			if (!greh->key) {
-				DEBUGP("can't nat GRE w/o key\n");
-				break;
-			}
-			if (greh->csum) {
-				/* FIXME: Never tested this code... */
-				nf_proto_csum_replace4(gre_csum(greh), *pskb,
-							*(gre_key(greh)),
-							tuple->dst.u.gre.key, 0);
-			}
-			*(gre_key(greh)) = tuple->dst.u.gre.key;
+		case GRE_VERSION_1701:
+			/* We do not currently NAT any GREv0 packets.
+			 * Try to behave like "ip_nat_proto_unknown" */
 			break;
 		case GRE_VERSION_PPTP:
 			DEBUGP("call_id -> 0x%04x\n",
--- linux-2.6.20.13.orig/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ linux-2.6.20.13/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -72,6 +72,11 @@ gre_unique_tuple(struct nf_conntrack_tup
 	__be16 *keyptr;
 	unsigned int min, i, range_size;
 
+	/* If there is no master conntrack we are not PPTP,
+	   do not change tuples */
+	if (!conntrack->master)
+		return 0;
+		
 	if (maniptype == IP_NAT_MANIP_SRC)
 		keyptr = &tuple->src.u.gre.key;
 	else
@@ -122,18 +127,9 @@ gre_manip_pkt(struct sk_buff **pskb, uns
 	if (maniptype != IP_NAT_MANIP_DST)
 		return 1;
 	switch (greh->version) {
-	case 0:
-		if (!greh->key) {
-			DEBUGP("can't nat GRE w/o key\n");
-			break;
-		}
-		if (greh->csum) {
-			/* FIXME: Never tested this code... */
-			nf_proto_csum_replace4(gre_csum(greh), *pskb,
-					       *(gre_key(greh)),
-					       tuple->dst.u.gre.key, 0);
-		}
-		*(gre_key(greh)) = tuple->dst.u.gre.key;
+	case GRE_VERSION_1701:
+		/* We do not currently NAT any GREv0 packets.
+		 * Try to behave like "nf_nat_proto_unknown" */
 		break;
 	case GRE_VERSION_PPTP:
 		DEBUGP("call_id -> 0x%04x\n", ntohs(tuple->dst.u.gre.key));

-- 
