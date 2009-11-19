Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbZKSRW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbZKSRW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbZKSRWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:22:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912AbZKSRWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:22:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/28] CacheFiles: Better showing of debugging information in
	active object problems
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:22:47 +0000
Message-ID: <20091119172247.1679.73708.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show more debugging information if cachefiles_mark_object_active() is asked to
activate an active object.

This may happen, for instance, if the netfs tries to register an object with
the same key multiple times.

The code is changed to (a) get the appropriate object lock to protect the
cookie pointer whilst we dereference it, and (b) get and display the cookie key
if available.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/namei.c |  102 ++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 75 insertions(+), 27 deletions(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 3df8695..00a0cda 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -27,6 +27,76 @@ static int cachefiles_wait_bit(void *flags)
 	return 0;
 }
 
+#define CACHEFILES_KEYBUF_SIZE 512
+
+/*
+ * dump debugging info about an object
+ */
+static noinline
+void __cachefiles_printk_object(struct cachefiles_object *object,
+				const char *prefix,
+				u8 *keybuf)
+{
+	struct fscache_cookie *cookie;
+	unsigned keylen, loop;
+
+	printk(KERN_ERR "%sobject: OBJ%x\n",
+	       prefix, object->fscache.debug_id);
+	printk(KERN_ERR "%sobjstate=%s fl=%lx swfl=%lx ev=%lx[%lx]\n",
+	       prefix, fscache_object_states[object->fscache.state],
+	       object->fscache.flags, object->fscache.work.flags,
+	       object->fscache.events,
+	       object->fscache.event_mask & FSCACHE_OBJECT_EVENTS_MASK);
+	printk(KERN_ERR "%sops=%u inp=%u exc=%u\n",
+	       prefix, object->fscache.n_ops, object->fscache.n_in_progress,
+	       object->fscache.n_exclusive);
+	printk(KERN_ERR "%sparent=%p\n",
+	       prefix, object->fscache.parent);
+
+	spin_lock(&object->fscache.lock);
+	cookie = object->fscache.cookie;
+	if (cookie) {
+		printk(KERN_ERR "%scookie=%p [pr=%p nd=%p fl=%lx]\n",
+		       prefix,
+		       object->fscache.cookie,
+		       object->fscache.cookie->parent,
+		       object->fscache.cookie->netfs_data,
+		       object->fscache.cookie->flags);
+		if (keybuf)
+			keylen = cookie->def->get_key(cookie->netfs_data, keybuf,
+						      CACHEFILES_KEYBUF_SIZE);
+		else
+			keylen = 0;
+	} else {
+		printk(KERN_ERR "%scookie=NULL\n", prefix);
+		keylen = 0;
+	}
+	spin_unlock(&object->fscache.lock);
+
+	if (keylen) {
+		printk(KERN_ERR "%skey=[%u] '", prefix, keylen);
+		for (loop = 0; loop < keylen; loop++)
+			printk("%02x", keybuf[loop]);
+		printk("'\n");
+	}
+}
+
+/*
+ * dump debugging info about a pair of objects
+ */
+static noinline void cachefiles_printk_object(struct cachefiles_object *object,
+					      struct cachefiles_object *xobject)
+{
+	u8 *keybuf;
+
+	keybuf = kmalloc(CACHEFILES_KEYBUF_SIZE, GFP_NOIO);
+	if (object)
+		__cachefiles_printk_object(object, "", keybuf);
+	if (xobject)
+		__cachefiles_printk_object(xobject, "x", keybuf);
+	kfree(keybuf);
+}
+
 /*
  * record the fact that an object is now active
  */
@@ -42,8 +112,11 @@ static void cachefiles_mark_object_active(struct cachefiles_cache *cache,
 try_again:
 	write_lock(&cache->active_lock);
 
-	if (test_and_set_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags))
+	if (test_and_set_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags)) {
+		printk(KERN_ERR "CacheFiles: Error: Object already active\n");
+		cachefiles_printk_object(object, NULL);
 		BUG();
+	}
 
 	dentry = object->dentry;
 	_p = &cache->active_nodes.rb_node;
@@ -76,32 +149,7 @@ wait_for_old_object:
 		printk(KERN_ERR "\n");
 		printk(KERN_ERR "CacheFiles: Error:"
 		       " Unexpected object collision\n");
-		printk(KERN_ERR "xobject: OBJ%x\n",
-		       xobject->fscache.debug_id);
-		printk(KERN_ERR "xobjstate=%s\n",
-		       fscache_object_states[xobject->fscache.state]);
-		printk(KERN_ERR "xobjflags=%lx\n", xobject->fscache.flags);
-		printk(KERN_ERR "xobjevent=%lx [%lx]\n",
-		       xobject->fscache.events, xobject->fscache.event_mask);
-		printk(KERN_ERR "xops=%u inp=%u exc=%u\n",
-		       xobject->fscache.n_ops, xobject->fscache.n_in_progress,
-		       xobject->fscache.n_exclusive);
-		printk(KERN_ERR "xcookie=%p [pr=%p nd=%p fl=%lx]\n",
-		       xobject->fscache.cookie,
-		       xobject->fscache.cookie->parent,
-		       xobject->fscache.cookie->netfs_data,
-		       xobject->fscache.cookie->flags);
-		printk(KERN_ERR "xparent=%p\n",
-		       xobject->fscache.parent);
-		printk(KERN_ERR "object: OBJ%x\n",
-		       object->fscache.debug_id);
-		printk(KERN_ERR "cookie=%p [pr=%p nd=%p fl=%lx]\n",
-		       object->fscache.cookie,
-		       object->fscache.cookie->parent,
-		       object->fscache.cookie->netfs_data,
-		       object->fscache.cookie->flags);
-		printk(KERN_ERR "parent=%p\n",
-		       object->fscache.parent);
+		cachefiles_printk_object(object, xobject);
 		BUG();
 	}
 	atomic_inc(&xobject->usage);

