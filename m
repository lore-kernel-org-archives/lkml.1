Return-Path: <linux-kernel-owner+w=401wt.eu-S1751379AbZGREkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbZGREkB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 00:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbZGREjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 00:39:55 -0400
Received: from cobra.newdream.net ([66.33.216.30]:57340 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZGREjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 00:39:54 -0400
Date: Fri, 17 Jul 2009 21:39:54 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Chris Wright <chrisw@sous-sol.org>
cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] ceph: Ceph distributed file system client v0.10
In-Reply-To: <20090718012819.GE8150@sequoia.sous-sol.org>
Message-ID: <Pine.LNX.4.64.0907172130170.25768@cobra.newdream.net>
References: <1247693090-27796-1-git-send-email-sage@newdream.net>
 <87hbxcx182.fsf@basil.nowhere.org> <Pine.LNX.4.64.0907161004080.8026@cobra.newdream.net>
 <20090718012819.GE8150@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009, Chris Wright wrote:
> * Sage Weil (sage@newdream.net) wrote:
> > I don't always verify that things like element counts are "sane", though, 
> > so there's currently the possibility of trying to allocate large chunks of 
> > memory.
> 
> There's also the potential of allocating a small amount of memory w/ a
> large element count if you overflow on multiply.  You should definitely
> protect against this if you have such code in ceph client (kcalloc has
> simple example defense).

Good call.  I've audited all the k[mz]alloc call sites and switched to 
kcalloc for all the decode num * size allocations, or added a similar 
check for overflow.

Thanks-
sage


---
diff --git a/src/include/ceph_fs.h b/src/include/ceph_fs.h
index c7ca9ba..6242cf2 100644
--- a/src/include/ceph_fs.h
+++ b/src/include/ceph_fs.h
@@ -31,6 +31,9 @@
 
 #define CEPH_INO_ROOT  1
 
+/* arbitrary limit on max # of monitors (cluster of 3 is typical) */
+#define CEPH_MAX_MON   31
+
 
 /*
  * "Frags" are a way to describe a subset of a 32-bit number space,
diff --git a/src/kernel/inode.c b/src/kernel/inode.c
index c22e570..6758f69 100644
--- a/src/kernel/inode.c
+++ b/src/kernel/inode.c
@@ -1926,7 +1926,8 @@ start:
 		xattr_version = ci->i_xattrs.version;
 		spin_unlock(&inode->i_lock);
 
-		xattrs = kmalloc(numattr*sizeof(struct ceph_xattr *), GFP_NOFS);
+		xattrs = kcalloc(numattr, sizeof(struct ceph_xattr *),
+				 GFP_NOFS);
 		err = -ENOMEM;
 		if (!xattrs)
 			goto bad_lock;
@@ -2177,7 +2178,7 @@ static int ceph_sync_setxattr(struct dentry *dentry, const char *name,
 	/* copy value into some pages */
 	nr_pages = calc_pages_for(0, size);
 	if (nr_pages) {
-		pages = kmalloc(sizeof(pages)*nr_pages, GFP_NOFS);
+		pages = kmalloc(sizeof(pages[0])*nr_pages, GFP_NOFS);
 		if (!pages)
 			return -ENOMEM;
 		err = -ENOMEM;
diff --git a/src/kernel/mds_client.c b/src/kernel/mds_client.c
index 6237134..dd5630b 100644
--- a/src/kernel/mds_client.c
+++ b/src/kernel/mds_client.c
@@ -129,10 +129,10 @@ static int parse_reply_info_dir(void **p, void *end,
 
 	/* alloc large array */
 	info->dir_nr = num;
-	info->dir_in = kmalloc(num * (sizeof(*info->dir_in) +
-				      sizeof(*info->dir_dname) +
-				      sizeof(*info->dir_dname_len) +
-				      sizeof(*info->dir_dlease)),
+	info->dir_in = kcalloc(num, sizeof(*info->dir_in) +
+			       sizeof(*info->dir_dname) +
+			       sizeof(*info->dir_dname_len) +
+			       sizeof(*info->dir_dlease),
 			       GFP_NOFS);
 	if (info->dir_in == NULL) {
 		err = -ENOMEM;
@@ -312,7 +312,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 		struct ceph_mds_session **sa;
 
 		dout("register_session realloc to %d\n", newmax);
-		sa = kzalloc(newmax * sizeof(void *), GFP_NOFS);
+		sa = kcalloc(newmax, sizeof(void *), GFP_NOFS);
 		if (sa == NULL)
 			return ERR_PTR(-ENOMEM);
 		if (mdsc->sessions) {
diff --git a/src/kernel/mdsmap.c b/src/kernel/mdsmap.c
index b545850..e1a86ae 100644
--- a/src/kernel/mdsmap.c
+++ b/src/kernel/mdsmap.c
@@ -65,8 +65,8 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
 	ceph_decode_64(p, m->m_max_file_size);
 	ceph_decode_32(p, m->m_max_mds);
 
-	m->m_addr = kzalloc(m->m_max_mds*sizeof(*m->m_addr), GFP_NOFS);
-	m->m_state = kzalloc(m->m_max_mds*sizeof(*m->m_state), GFP_NOFS);
+	m->m_addr = kcalloc(m->m_max_mds, sizeof(*m->m_addr), GFP_NOFS);
+	m->m_state = kcalloc(m->m_max_mds, sizeof(*m->m_state), GFP_NOFS);
 	if (m->m_addr == NULL || m->m_state == NULL)
 		goto badmem;
 
@@ -102,7 +102,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
 	/* pg_pools */
 	ceph_decode_32_safe(p, end, n, bad);
 	m->m_num_data_pg_pools = n;
-	m->m_data_pg_pools = kmalloc(sizeof(u32)*n, GFP_NOFS);
+	m->m_data_pg_pools = kcalloc(n, sizeof(u32), GFP_NOFS);
 	if (!m->m_data_pg_pools)
 		goto badmem;
 	ceph_decode_need(p, end, sizeof(u32)*(n+1), bad);
diff --git a/src/kernel/messenger.c b/src/kernel/messenger.c
index a5828ca..845faf2 100644
--- a/src/kernel/messenger.c
+++ b/src/kernel/messenger.c
@@ -303,7 +303,7 @@ static struct ceph_connection *new_connection(struct ceph_messenger *msgr)
 {
 	struct ceph_connection *con;
 
-	con = kzalloc(sizeof(struct ceph_connection), GFP_NOFS);
+	con = kzalloc(sizeof(*con), GFP_NOFS);
 	if (con == NULL)
 		return NULL;
 	con->msgr = msgr;
diff --git a/src/kernel/mon_client.c b/src/kernel/mon_client.c
index abee6dc..23ce141 100644
--- a/src/kernel/mon_client.c
+++ b/src/kernel/mon_client.c
@@ -33,6 +33,8 @@ struct ceph_monmap *ceph_monmap_decode(void *p, void *end)
 	ceph_decode_need(&p, end, num_mon*sizeof(m->mon_inst[0]), bad);
 
 	/* The encoded and decoded sizes match. */
+	if (num_mon >= CEPH_MAX_MON)
+		goto bad;
 	m = kmalloc(sizeof(*m) + sizeof(m->mon_inst[0])*num_mon, GFP_NOFS);
 	if (m == NULL)
 		return ERR_PTR(-ENOMEM);
diff --git a/src/kernel/osdmap.c b/src/kernel/osdmap.c
index 23bef3b..fef1574 100644
--- a/src/kernel/osdmap.c
+++ b/src/kernel/osdmap.c
@@ -78,10 +78,10 @@ static int crush_decode_list_bucket(void **p, void *end,
 {
 	int j;
 	dout("crush_decode_list_bucket %p to %p\n", *p, end);
-	b->item_weights = kmalloc(b->h.size * sizeof(u32), GFP_NOFS);
+	b->item_weights = kcalloc(b->h.size, sizeof(u32), GFP_NOFS);
 	if (b->item_weights == NULL)
 		return -ENOMEM;
-	b->sum_weights = kmalloc(b->h.size * sizeof(u32), GFP_NOFS);
+	b->sum_weights = kcalloc(b->h.size, sizeof(u32), GFP_NOFS);
 	if (b->sum_weights == NULL)
 		return -ENOMEM;
 	ceph_decode_need(p, end, 2 * b->h.size * sizeof(u32), bad);
@@ -100,7 +100,7 @@ static int crush_decode_tree_bucket(void **p, void *end,
 	int j;
 	dout("crush_decode_tree_bucket %p to %p\n", *p, end);
 	ceph_decode_32_safe(p, end, b->num_nodes, bad);
-	b->node_weights = kmalloc(b->num_nodes * sizeof(u32), GFP_NOFS);
+	b->node_weights = kcalloc(b->num_nodes, sizeof(u32), GFP_NOFS);
 	if (b->node_weights == NULL)
 		return -ENOMEM;
 	ceph_decode_need(p, end, b->num_nodes * sizeof(u32), bad);
@@ -116,10 +116,10 @@ static int crush_decode_straw_bucket(void **p, void *end,
 {
 	int j;
 	dout("crush_decode_straw_bucket %p to %p\n", *p, end);
-	b->item_weights = kmalloc(b->h.size * sizeof(u32), GFP_NOFS);
+	b->item_weights = kcalloc(b->h.size, sizeof(u32), GFP_NOFS);
 	if (b->item_weights == NULL)
 		return -ENOMEM;
-	b->straws = kmalloc(b->h.size * sizeof(u32), GFP_NOFS);
+	b->straws = kcalloc(b->h.size, sizeof(u32), GFP_NOFS);
 	if (b->straws == NULL)
 		return -ENOMEM;
 	ceph_decode_need(p, end, 2 * b->h.size * sizeof(u32), bad);
@@ -158,17 +158,17 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 	ceph_decode_32(p, c->max_rules);
 	ceph_decode_32(p, c->max_devices);
 
-	c->device_parents = kmalloc(c->max_devices * sizeof(u32), GFP_NOFS);
+	c->device_parents = kcalloc(c->max_devices, sizeof(u32), GFP_NOFS);
 	if (c->device_parents == NULL)
 		goto badmem;
-	c->bucket_parents = kmalloc(c->max_buckets * sizeof(u32), GFP_NOFS);
+	c->bucket_parents = kcalloc(c->max_buckets, sizeof(u32), GFP_NOFS);
 	if (c->bucket_parents == NULL)
 		goto badmem;
 
-	c->buckets = kmalloc(c->max_buckets * sizeof(*c->buckets), GFP_NOFS);
+	c->buckets = kcalloc(c->max_buckets, sizeof(*c->buckets), GFP_NOFS);
 	if (c->buckets == NULL)
 		goto badmem;
-	c->rules = kmalloc(c->max_rules * sizeof(*c->rules), GFP_NOFS);
+	c->rules = kcalloc(c->max_rules, sizeof(*c->rules), GFP_NOFS);
 	if (c->rules == NULL)
 		goto badmem;
 
@@ -217,10 +217,10 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 		dout("crush_decode bucket size %d off %x %p to %p\n",
 		     b->size, (int)(*p-start), *p, end);
 
-		b->items = kmalloc(b->size * sizeof(__s32), GFP_NOFS);
+		b->items = kcalloc(b->size, sizeof(__s32), GFP_NOFS);
 		if (b->items == NULL)
 			goto badmem;
-		b->perm = kmalloc(b->size * sizeof(u32), GFP_NOFS);
+		b->perm = kcalloc(b->size, sizeof(u32), GFP_NOFS);
 		if (b->perm == NULL)
 			goto badmem;
 		b->perm_n = 0;
@@ -276,7 +276,10 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 
 		/* len */
 		ceph_decode_32_safe(p, end, yes, bad);
-
+#if BITS_PER_LONG == 32
+		if (yes > ULONG_MAX / sizeof(struct crush_rule_step))
+			goto bad;
+#endif
 		r = c->rules[i] = kmalloc(sizeof(*r) +
 					  yes*sizeof(struct crush_rule_step),
 					  GFP_NOFS);
@@ -331,9 +334,9 @@ static int osdmap_set_max_osd(struct ceph_osdmap *map, int max)
 	struct ceph_entity_addr *addr;
 	u32 *weight;
 
-	state = kzalloc(max * sizeof(*state), GFP_NOFS);
-	addr = kzalloc(max * sizeof(*addr), GFP_NOFS);
-	weight = kzalloc(max * sizeof(*weight), GFP_NOFS);
+	state = kcalloc(max, sizeof(*state), GFP_NOFS);
+	addr = kcalloc(max, sizeof(*addr), GFP_NOFS);
+	weight = kcalloc(max, sizeof(*weight), GFP_NOFS);
 	if (state == NULL || addr == NULL || weight == NULL) {
 		kfree(state);
 		kfree(addr);
@@ -381,7 +384,7 @@ struct ceph_osdmap *osdmap_decode(void **p, void *end)
 	ceph_decode_copy(p, &map->modified, sizeof(map->modified));
 
 	ceph_decode_32(p, map->num_pools);
-	map->pg_pool = kmalloc(map->num_pools * sizeof(*map->pg_pool),
+	map->pg_pool = kcalloc(map->num_pools, sizeof(*map->pg_pool),
 			       GFP_NOFS);
 	if (!map->pg_pool) {
 		err = -ENOMEM;
@@ -523,8 +526,9 @@ struct ceph_osdmap *apply_incremental(void **p, void *end,
 	while (len--) {
 		ceph_decode_32_safe(p, end, pool, bad);
 		if (pool >= map->num_pools) {
-			void *pg_pool = kzalloc((pool+1)*sizeof(*map->pg_pool),
-					  GFP_NOFS);
+			void *pg_pool = kcalloc(pool + 1,
+						sizeof(*map->pg_pool),
+						GFP_NOFS);
 			if (!pg_pool) {
 				err = -ENOMEM;
 				goto bad;
diff --git a/src/kernel/snap.c b/src/kernel/snap.c
index f3e0685..e07d776 100644
--- a/src/kernel/snap.c
+++ b/src/kernel/snap.c
@@ -299,6 +299,8 @@ static int build_snap_context(struct ceph_snap_realm *realm)
 
 	/* alloc new snap context */
 	err = -ENOMEM;
+	if (num > ULONG_MAX / sizeof(u64) - sizeof(*snapc))
+		goto fail;
 	snapc = kzalloc(sizeof(*snapc) + num*sizeof(u64), GFP_NOFS);
 	if (!snapc)
 		goto fail;
@@ -374,7 +376,7 @@ static int dup_array(u64 **dst, __le64 *src, int num)
 
 	kfree(*dst);
 	if (num) {
-		*dst = kmalloc(sizeof(u64) * num, GFP_NOFS);
+		*dst = kcalloc(num, sizeof(u64), GFP_NOFS);
 		if (!*dst)
 			return -ENOMEM;
 		for (i = 0; i < num; i++)
