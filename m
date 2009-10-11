Return-Path: <linux-kernel-owner+w=401wt.eu-S1751261AbZJKU0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbZJKU0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 16:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbZJKU0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 16:26:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbZJKU0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 16:26:18 -0400
Date: Sun, 11 Oct 2009 22:24:25 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       David Airlie <airlied@linux.ie>
cc: Jonathan Corbet <corbet@lwn.net>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Vincent Sanders <vince@simtec.co.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH RFC] frontend.c: Remove the BKL from agp_open
Message-ID: <alpine.LFD.2.00.0910112216060.12574@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


@David Airlie. I was looking at the agp driver for removal of the bkl 
lock. From what I could tell, the mutex_lock(&(agp_fe.agp_mutex)) should 
cover what we need. However, I may have easily missed something, and would 
appreciate your review / comments on the patch.

>From 261cd08816c2b4c767b6ae038737beef32fe1085 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 11 Oct 2009 21:37:51 +0200
Subject: [PATCH] frontend.c: Remove the BKL from agp_open

- Remove the BKL from agp_open
- Perform a few clean-ups.

Analysis:
---------
int minor is local to the function.

The following are protected by agp_fe.agp_mutex
struct agp_file_private *priv;
struct agp_client *client;

Call-outs:

kzalloc should be safe to call under the mutex_lock

agp_find_client_by_pid:
	- agp_mmap calls that under agp_fe.agp_mutex which we hold in agp_open
	- agpioc_reserve_wrap calls it without any locking what-so-ever.
		- Is that an error? Or is that okay because it has pid that is
		  a unique handle?

agp_insert_file_private:
	- This function only manipulates struct agp_file_private, once again
	  while agp_fe.agp_mutex is held

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/char/agp/frontend.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
index a96f319..43412c0 100644
--- a/drivers/char/agp/frontend.c
+++ b/drivers/char/agp/frontend.c
@@ -676,25 +676,25 @@ static int agp_open(struct inode *inode, struct file *file)
 	int minor = iminor(inode);
 	struct agp_file_private *priv;
 	struct agp_client *client;
-	int rc = -ENXIO;
-
-	lock_kernel();
-	mutex_lock(&(agp_fe.agp_mutex));
 
 	if (minor != AGPGART_MINOR)
-		goto err_out;
+		return -ENXIO;
+
+	mutex_lock(&(agp_fe.agp_mutex));
 
 	priv = kzalloc(sizeof(struct agp_file_private), GFP_KERNEL);
-	if (priv == NULL)
-		goto err_out_nomem;
+	if (priv == NULL) {
+		mutex_unlock(&(agp_fe.agp_mutex));
+		return -ENOMEM;
+	}
 
 	set_bit(AGP_FF_ALLOW_CLIENT, &priv->access_flags);
 	priv->my_pid = current->pid;
 
-	if (capable(CAP_SYS_RAWIO)) {
+	if (capable(CAP_SYS_RAWIO))
 		/* Root priv, can be controller */
 		set_bit(AGP_FF_ALLOW_CONTROLLER, &priv->access_flags);
-	}
+
 	client = agp_find_client_by_pid(current->pid);
 
 	if (client != NULL) {
@@ -704,16 +704,10 @@ static int agp_open(struct inode *inode, struct file *file)
 	file->private_data = (void *) priv;
 	agp_insert_file_private(priv);
 	DBG("private=%p, client=%p", priv, client);
-	mutex_unlock(&(agp_fe.agp_mutex));
-	unlock_kernel();
-	return 0;
 
-err_out_nomem:
-	rc = -ENOMEM;
-err_out:
 	mutex_unlock(&(agp_fe.agp_mutex));
-	unlock_kernel();
-	return rc;
+
+	return 0;
 }
 
 
-- 
1.6.0.6

