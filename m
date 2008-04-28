Return-Path: <linux-kernel-owner+w=401wt.eu-S936225AbYD1X4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936225AbYD1X4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935039AbYD1X4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:56:05 -0400
Received: from ns.suse.de ([195.135.220.2]:51072 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934628AbYD1X4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:56:03 -0400
Subject: patch klist-implement-klist_add_-after-before.patch added to gregkh-2.6 tree
To: htejun@gmail.com, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       gregkh@suse.de, greg@kroah.com, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, stern@rowland.harvard.edu
From: <gregkh@suse.de>
Date: Mon, 28 Apr 2008 16:51:28 -0700
In-Reply-To: <480DB6D6.5040808@gmail.com>
Message-ID: <12094266881802@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: klist: implement klist_add_{after|before}()

to my gregkh-2.6 tree.  Its filename is

     klist-implement-klist_add_-after-before.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From htejun@gmail.com Tue Apr 22 02:58:55 2008
From: Tejun Heo <htejun@gmail.com>
Date: Tue, 22 Apr 2008 18:58:46 +0900
Subject: klist: implement klist_add_{after|before}()
To: James Bottomley <James.Bottomley@HansenPartnership.com>,  Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,  oliver@neukum.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,  zaitcev@redhat.com,  Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Message-ID: <480DB6D6.5040808@gmail.com>


Add klist_add_after() and klist_add_before() which puts a new node
after and before an existing node, respectively.  This is useful for
callers which need to keep klist ordered.  Note that synchronizing
between simultaneous additions for ordering is the caller's
responsibility.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/klist.h |    2 ++
 lib/klist.c           |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -46,6 +46,8 @@ struct klist_node {
 
 extern void klist_add_tail(struct klist_node * n, struct klist * k);
 extern void klist_add_head(struct klist_node * n, struct klist * k);
+extern void klist_add_after(struct klist_node * n, struct klist_node * pos);
+extern void klist_add_before(struct klist_node * n, struct klist_node * pos);
 
 extern void klist_del(struct klist_node * n);
 extern void klist_remove(struct klist_node * n);
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -120,6 +120,44 @@ void klist_add_tail(struct klist_node * 
 EXPORT_SYMBOL_GPL(klist_add_tail);
 
 
+/**
+ *	klist_add_after - Init a klist_node and add it after an existing node
+ *	@n:	node we're adding.
+ *	@pos:	node to put @n after
+ */
+
+void klist_add_after(struct klist_node * n, struct klist_node * pos)
+{
+	struct klist *k = pos->n_klist;
+
+	klist_node_init(k, n);
+	spin_lock(&k->k_lock);
+	list_add(&n->n_node, &pos->n_node);
+	spin_unlock(&k->k_lock);
+}
+
+EXPORT_SYMBOL_GPL(klist_add_after);
+
+
+/**
+ *	klist_add_before - Init a klist_node and add it before an existing node
+ *	@n:	node we're adding.
+ *	@pos:	node to put @n after
+ */
+
+void klist_add_before(struct klist_node * n, struct klist_node * pos)
+{
+	struct klist *k = pos->n_klist;
+
+	klist_node_init(k, n);
+	spin_lock(&k->k_lock);
+	list_add_tail(&n->n_node, &pos->n_node);
+	spin_unlock(&k->k_lock);
+}
+
+EXPORT_SYMBOL_GPL(klist_add_before);
+
+
 static void klist_release(struct kref * kref)
 {
 	struct klist_node * n = container_of(kref, struct klist_node, n_ref);


Patches currently in gregkh-2.6 which might be from htejun@gmail.com are

driver-core/sysfs-add-sys-dev-char-block-to-lookup-sysfs-path-by-major-minor.patch
driver-core/klist-implement-klist_add_-after-before.patch
driver-core/klist-implement-klist_init-and-define_klist.patch
