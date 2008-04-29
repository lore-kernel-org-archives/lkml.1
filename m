Return-Path: <linux-kernel-owner+w=401wt.eu-S1765985AbYD2OjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765985AbYD2OjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759052AbYD2Ohs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:37:48 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49802 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761214AbYD2Ohr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:37:47 -0400
Message-Id: <20080429143730.504910000@bull.net>
References: <20080429143304.741001000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 29 Apr 2008 16:33:10 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 06/10] Introduce ridr_get_new()
Content-Disposition: inline; filename=ridr_get_new.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 06/10]

This patch introduces the ridr_get_new() routine.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/ridr.h |    1 +
 lib/ridr.c           |   27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

Index: linux-2.6.25-mm1/include/linux/ridr.h
===================================================================
--- linux-2.6.25-mm1.orig/include/linux/ridr.h	2008-04-29 14:03:35.000000000 +0200
+++ linux-2.6.25-mm1/include/linux/ridr.h	2008-04-29 14:16:09.000000000 +0200
@@ -44,6 +44,7 @@ struct ridr {
  * This is what we export.
  */
 int ridr_pre_get(struct ridr *, gfp_t);
+int ridr_get_new(struct ridr *, void *, int *);
 int ridr_get_new_above(struct ridr *, void *, int, int *);
 void ridr_init(struct ridr *);
 
Index: linux-2.6.25-mm1/lib/ridr.c
===================================================================
--- linux-2.6.25-mm1.orig/lib/ridr.c	2008-04-29 14:03:35.000000000 +0200
+++ linux-2.6.25-mm1/lib/ridr.c	2008-04-29 14:17:05.000000000 +0200
@@ -232,6 +232,33 @@ int ridr_get_new_above(struct ridr *idp,
 }
 EXPORT_SYMBOL(ridr_get_new_above);
 
+/**
+ * ridr_get_new - allocate new ridr entry
+ * @idp: ridr handle
+ * @ptr: pointer you want associated with the ide
+ * @id: pointer to the allocated handle
+ *
+ * This is the allocate id function.  It should be called with any
+ * required locks.
+ *
+ * If memory is required, it will return -EAGAIN, you should unlock
+ * and go back to the ridr_pre_get() call.  If the ridr is full, it will
+ * return -ENOSPC.
+ *
+ * @id returns a value in the range 0 ... 0x7fffffff
+ */
+int ridr_get_new(struct ridr *idp, void *ptr, int *id)
+{
+	int rv;
+
+	rv = ridr_get_new_above_int(idp, ptr, 0);
+	if (rv < 0)
+		return _idr_rc_to_errno(rv);
+	*id = rv;
+	return 0;
+}
+EXPORT_SYMBOL(ridr_get_new);
+
 static void ridr_cache_ctor(struct kmem_cache *ridr_layer_cache,
 			void *ridr_layer)
 {

--
