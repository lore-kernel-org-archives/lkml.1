Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbXDZGTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbXDZGTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbXDZGTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:19:25 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:37263 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770AbXDZGTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:19:24 -0400
Date: Thu, 26 Apr 2007 02:12:00 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 12/12] selinux: preserve boolean values across policy reloads
In-Reply-To: <Line.LNX.4.64.0704260200450.30059@d.namei>
Message-ID: <Line.LNX.4.64.0704260211270.30059@d.namei>
References: <Line.LNX.4.64.0704260200450.30059@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

At present, the userland policy loading code has to go through contortions 
to preserve boolean values across policy reloads, and cannot do so 
atomically. As this is what we always want to do for reloads, let the 
kernel preserve them instead.

Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: Karl MacMillan <kmacmillan@mentalrootkit.com>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/ss/services.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 21b8318..40660ff 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -1257,6 +1257,7 @@ bad:
 }
 
 extern void selinux_complete_init(void);
+static int security_preserve_bools(struct policydb *p);
 
 /**
  * security_load_policy - Load a security policy configuration.
@@ -1333,6 +1334,12 @@ int security_load_policy(void *data, size_t len)
 		goto err;
 	}
 
+	rc = security_preserve_bools(&newpolicydb);
+	if (rc) {
+		printk(KERN_ERR "security:  unable to preserve booleans\n");
+		goto err;
+	}
+
 	/* Clone the SID table. */
 	sidtab_shutdown(&sidtab);
 	if (sidtab_map(&sidtab, clone_sid, &newsidtab)) {
@@ -1890,6 +1897,37 @@ out:
 	return rc;
 }
 
+static int security_preserve_bools(struct policydb *p)
+{
+	int rc, nbools = 0, *bvalues = NULL, i;
+	char **bnames = NULL;
+	struct cond_bool_datum *booldatum;
+	struct cond_node *cur;
+
+	rc = security_get_bools(&nbools, &bnames, &bvalues);
+	if (rc)
+		goto out;
+	for (i = 0; i < nbools; i++) {
+		booldatum = hashtab_search(p->p_bools.table, bnames[i]);
+		if (booldatum)
+			booldatum->state = bvalues[i];
+	}
+	for (cur = p->cond_list; cur != NULL; cur = cur->next) {
+		rc = evaluate_cond_node(p, cur);
+		if (rc)
+			goto out;
+	}
+
+out:
+	if (bnames) {
+		for (i = 0; i < nbools; i++)
+			kfree(bnames[i]);
+	}
+	kfree(bnames);
+	kfree(bvalues);
+	return rc;
+}
+
 /*
  * security_sid_mls_copy() - computes a new sid based on the given
  * sid and the mls portion of mls_sid.
-- 
1.5.0.6

