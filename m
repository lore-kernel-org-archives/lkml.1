Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989Ab0AFRBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab0AFRBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963Ab0AFRBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:01:14 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:37453 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab0AFRBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:01:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 1/1] cred: fix memory leak
Date: Wed,  6 Jan 2010 18:01:05 +0100
Message-Id: <1262797265-26557-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a memory leak in prepare_exec_creds. tgcred is not
freed/assigned on all paths. Fix that.

I.e. unifdef tgcred and add kfree(tgcred); as it is initialized to
NULL already.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Serge Hallyn <serue@us.ibm.com>
---
 kernel/cred.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index dd76cfe..0e10f73 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -351,9 +351,7 @@ struct cred *prepare_exec_creds(void)
  */
 struct cred *prepare_usermodehelper_creds(void)
 {
-#ifdef CONFIG_KEYS
 	struct thread_group_cred *tgcred = NULL;
-#endif
 	struct cred *new;
 
 #ifdef CONFIG_KEYS
@@ -363,8 +361,10 @@ struct cred *prepare_usermodehelper_creds(void)
 #endif
 
 	new = kmem_cache_alloc(cred_jar, GFP_ATOMIC);
-	if (!new)
+	if (!new) {
+		kfree(tgcred);
 		return NULL;
+	}
 
 	kdebug("prepare_usermodehelper_creds() alloc %p", new);
 
-- 
1.6.5.7

