Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbZFIKPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbZFIKPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbZFIKPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:15:22 -0400
Received: from kroah.org ([198.145.64.141]:59631 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbZFIKPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:15:22 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:52 2009
Message-Id: <20090609094052.306238753@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:38:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 01/87] xfrm: wrong hash value for temporary SA
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=xfrm-wrong-hash-value-for-temporary-sa.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 6a783c9067e3f71aac61a9262fe42c1f68efd4fc ]

When kernel inserts a temporary SA for IKE, it uses the wrong hash
value for dst list. Two hash values were calcultated before: one with
source address and one with a wildcard source address.

Bug hinted by Junwei Zhang <junwei.zhang@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/xfrm/xfrm_state.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -794,7 +794,7 @@ xfrm_state_find(xfrm_address_t *daddr, x
 {
 	static xfrm_address_t saddr_wildcard = { };
 	struct net *net = xp_net(pol);
-	unsigned int h;
+	unsigned int h, h_wildcard;
 	struct hlist_node *entry;
 	struct xfrm_state *x, *x0, *to_put;
 	int acquire_in_progress = 0;
@@ -819,8 +819,8 @@ xfrm_state_find(xfrm_address_t *daddr, x
 	if (best)
 		goto found;
 
-	h = xfrm_dst_hash(net, daddr, &saddr_wildcard, tmpl->reqid, family);
-	hlist_for_each_entry(x, entry, net->xfrm.state_bydst+h, bydst) {
+	h_wildcard = xfrm_dst_hash(net, daddr, &saddr_wildcard, tmpl->reqid, family);
+	hlist_for_each_entry(x, entry, net->xfrm.state_bydst+h_wildcard, bydst) {
 		if (x->props.family == family &&
 		    x->props.reqid == tmpl->reqid &&
 		    !(x->props.flags & XFRM_STATE_WILDRECV) &&


