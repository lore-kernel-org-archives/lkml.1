Return-Path: <linux-kernel-owner+w=401wt.eu-S934793AbZJNPwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934793AbZJNPwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934749AbZJNPws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:52:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:34714 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934778AbZJNPwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:52:46 -0400
Date: Wed, 14 Oct 2009 15:51:46 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkacur@redhat.com, airlied@linux.ie, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, tglx@linutronix.de, airlied@linux.ie
In-Reply-To: <alpine.LFD.2.00.0910112216060.12574@localhost.localdomain>
References: <alpine.LFD.2.00.0910112216060.12574@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] agp: Remove the BKL from agp_open
Message-ID: <tip-55e858c8483af427144f33b42b818b30612b82b0@git.kernel.org>
Git-Commit-ID: 55e858c8483af427144f33b42b818b30612b82b0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:51:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55e858c8483af427144f33b42b818b30612b82b0
Gitweb:     http://git.kernel.org/tip/55e858c8483af427144f33b42b818b30612b82b0
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Sun, 11 Oct 2009 22:24:25 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:36:54 +0200

agp: Remove the BKL from agp_open

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
Acked-by: David Airlie <airlied@linux.ie>
LKML-Reference: <alpine.LFD.2.00.0910112216060.12574@localhost.localdomain>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
 
 
