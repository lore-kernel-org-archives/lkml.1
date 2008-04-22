Return-Path: <linux-kernel-owner+w=401wt.eu-S1762767AbYDVJ7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762767AbYDVJ7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759205AbYDVJ6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:58:55 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:5844 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758290AbYDVJ6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:58:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=h+xD9OP7gOuEJmPom3TFH0f8MvnA9iePyCUiKC4b8c8u6PG+X+NO5iix0MDGLBoXlFuKol7xUo7JclDr9hVOrkMIcXlkYHqSokv8SGanfRayf4rrXqzIdgVaLRTXQWMrOEfubh5HQP1Ox5sL9bdfp1vd6/5RMtekIssK+T2RG2c=
Message-ID: <480DB6D6.5040808@gmail.com>
Date: Tue, 22 Apr 2008 18:58:46 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       oliver@neukum.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       zaitcev@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: [PATCH] klist: implement klist_add_{after|before}()
References: <480DB6A4.20101@gmail.com>
In-Reply-To: <480DB6A4.20101@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add klist_add_after() and klist_add_before() which puts a new node
after and before an existing node, respectively.  This is useful for
callers which need to keep klist ordered.  Note that synchronizing
between simultaneous additions for ordering is the caller's
responsibility.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 include/linux/klist.h |    2 ++
 lib/klist.c           |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/include/linux/klist.h b/include/linux/klist.h
index c6b697c..80658c4 100644
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -46,6 +46,8 @@ struct klist_node {
 
 extern void klist_add_tail(struct klist_node * n, struct klist * k);
 extern void klist_add_head(struct klist_node * n, struct klist * k);
+extern void klist_add_after(struct klist_node * n, struct klist_node * pos);
+extern void klist_add_before(struct klist_node * n, struct klist_node * pos);
 
 extern void klist_del(struct klist_node * n);
 extern void klist_remove(struct klist_node * n);
diff --git a/lib/klist.c b/lib/klist.c
index 120bd17..ffe9cb6 100644
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -120,6 +120,44 @@ void klist_add_tail(struct klist_node * n, struct klist * k)
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
-- 
1.5.2.4

