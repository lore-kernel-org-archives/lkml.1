Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935238Ab0CMA0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:26:46 -0500
Received: from kroah.org ([198.145.64.141]:32806 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935052Ab0CMAVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:07 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:15 2010
Message-Id: <20100313001514.929300670@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 112/123] NFS: Fix an allocation-under-spinlock bug
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit ebed9203b68a4f333ce5d17e874b26c3afcfeff1 upstream.

sunrpc_cache_update() will always call detail->update() from inside the
detail->hash_lock, so it cannot allocate memory.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/dns_resolve.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/fs/nfs/dns_resolve.c
+++ b/fs/nfs/dns_resolve.c
@@ -36,6 +36,19 @@ struct nfs_dns_ent {
 };
 
 
+static void nfs_dns_ent_update(struct cache_head *cnew,
+		struct cache_head *ckey)
+{
+	struct nfs_dns_ent *new;
+	struct nfs_dns_ent *key;
+
+	new = container_of(cnew, struct nfs_dns_ent, h);
+	key = container_of(ckey, struct nfs_dns_ent, h);
+
+	memcpy(&new->addr, &key->addr, key->addrlen);
+	new->addrlen = key->addrlen;
+}
+
 static void nfs_dns_ent_init(struct cache_head *cnew,
 		struct cache_head *ckey)
 {
@@ -49,8 +62,7 @@ static void nfs_dns_ent_init(struct cach
 	new->hostname = kstrndup(key->hostname, key->namelen, GFP_KERNEL);
 	if (new->hostname) {
 		new->namelen = key->namelen;
-		memcpy(&new->addr, &key->addr, key->addrlen);
-		new->addrlen = key->addrlen;
+		nfs_dns_ent_update(cnew, ckey);
 	} else {
 		new->namelen = 0;
 		new->addrlen = 0;
@@ -234,7 +246,7 @@ static struct cache_detail nfs_dns_resol
 	.cache_show = nfs_dns_show,
 	.match = nfs_dns_match,
 	.init = nfs_dns_ent_init,
-	.update = nfs_dns_ent_init,
+	.update = nfs_dns_ent_update,
 	.alloc = nfs_dns_ent_alloc,
 };
 


