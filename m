Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab0BSRLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:11:14 -0500
Received: from kroah.org ([198.145.64.141]:57602 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806Ab0BSRAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:43 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:43 2010
Message-Id: <20100219163243.579053978@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [46/93] netfilter: nf_conntrack: fix memory corruption with multiple namespaces
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick McHardy <kaber@trash.net>

commit 9edd7ca0a3e3999c260642c92fa008892d82ca6e upstream.

As discovered by Jon Masters <jonathan@jonmasters.org>, the "untracked"
conntrack, which is located in the data section, might be accidentally
freed when a new namespace is instantiated while the untracked conntrack
is attached to a skb because the reference count it re-initialized.

The best fix would be to use a seperate untracked conntrack per
namespace since it includes a namespace pointer. Unfortunately this is
not possible without larger changes since the namespace is not easily
available everywhere we need it. For now move the untracked conntrack
initialization to the init_net setup function to make sure the reference
count is not re-initialized and handle cleanup in the init_net cleanup
function to make sure namespaces can exit properly while the untracked
conntrack is in use in other namespaces.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nf_conntrack_core.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1107,6 +1107,10 @@ static void nf_ct_release_dying_list(str
 
 static void nf_conntrack_cleanup_init_net(void)
 {
+	/* wait until all references to nf_conntrack_untracked are dropped */
+	while (atomic_read(&nf_conntrack_untracked.ct_general.use) > 1)
+		schedule();
+
 	nf_conntrack_helper_fini();
 	nf_conntrack_proto_fini();
 	kmem_cache_destroy(nf_conntrack_cachep);
@@ -1121,9 +1125,6 @@ static void nf_conntrack_cleanup_net(str
 		schedule();
 		goto i_see_dead_people;
 	}
-	/* wait until all references to nf_conntrack_untracked are dropped */
-	while (atomic_read(&nf_conntrack_untracked.ct_general.use) > 1)
-		schedule();
 
 	nf_ct_free_hashtable(net->ct.hash, net->ct.hash_vmalloc,
 			     nf_conntrack_htable_size);
@@ -1282,6 +1283,14 @@ static int nf_conntrack_init_init_net(vo
 	if (ret < 0)
 		goto err_helper;
 
+	/* Set up fake conntrack: to never be deleted, not in any hashes */
+#ifdef CONFIG_NET_NS
+	nf_conntrack_untracked.ct_net = &init_net;
+#endif
+	atomic_set(&nf_conntrack_untracked.ct_general.use, 1);
+	/*  - and look it like as a confirmed connection */
+	set_bit(IPS_CONFIRMED_BIT, &nf_conntrack_untracked.status);
+
 	return 0;
 
 err_helper:
@@ -1327,15 +1336,6 @@ static int nf_conntrack_init_net(struct
 	if (ret < 0)
 		goto err_ecache;
 
-	/* Set up fake conntrack:
-	    - to never be deleted, not in any hashes */
-#ifdef CONFIG_NET_NS
-	nf_conntrack_untracked.ct_net = &init_net;
-#endif
-	atomic_set(&nf_conntrack_untracked.ct_general.use, 1);
-	/*  - and look it like as a confirmed connection */
-	set_bit(IPS_CONFIRMED_BIT, &nf_conntrack_untracked.status);
-
 	return 0;
 
 err_ecache:


