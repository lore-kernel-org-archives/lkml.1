Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYDMTdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYDMTdx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbYDMTdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:33:38 -0400
Received: from mail3.iitk.ac.in ([203.200.95.132]:56139 "EHLO mail3.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686AbYDMTdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:33:37 -0400
Date: Mon, 14 Apr 2008 01:03:28 +0530 (IST)
From: Arun Raghavan <arunsr@cse.iitk.ac.in>
X-X-Sender: arun@peripatetic.hades
To: dhowells@redhat.com, linux-kernel@vger.kernel.org
cc: satyam@infradead.org
Subject: [PATCH] [keys] Use mutex instead of rw_semaphore for __key_link()
 serialisation
Message-ID: <Pine.LNX.4.64.0804140053210.9760@peripatetic.hades>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__key_link() uses an rw_semaphore as a mutex to serialise link/link calls. 
This patch converts it to explicitly use a struct mutex.

Signed-off-by: Arun Raghavan <arunsr@cse.iitk.ac.in>
Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 security/keys/keyring.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 5f31eb7..7bfc725 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/security.h>
 #include <linux/seq_file.h>
+#include <linux/mutex.h>
 #include <linux/err.h>
 #include <asm/uaccess.h>
 #include "internal.h"
@@ -69,10 +70,10 @@ struct key_type key_type_keyring = {
 EXPORT_SYMBOL(key_type_keyring);
 
 /*
- * semaphore to serialise link/link calls to prevent two link calls in parallel
+ * mutex to serialise link/link calls to prevent two link calls in parallel
  * introducing a cycle
  */
-static DECLARE_RWSEM(keyring_serialise_link_sem);
+static DEFINE_MUTEX(keyring_serialise_link_mutex);
 
 /*****************************************************************************/
 /*
@@ -681,7 +682,7 @@ int __key_link(struct key *keyring, struct key *key)
 
 	/* serialise link/link calls to prevent parallel calls causing a
 	 * cycle when applied to two keyring in opposite orders */
-	down_write(&keyring_serialise_link_sem);
+	mutex_lock(&keyring_serialise_link_mutex);
 
 	/* check that we aren't going to create a cycle adding one keyring to
 	 * another */
@@ -789,7 +790,7 @@ int __key_link(struct key *keyring, struct key *key)
 done:
 	ret = 0;
 error2:
-	up_write(&keyring_serialise_link_sem);
+	mutex_unlock(&keyring_serialise_link_mutex);
 error:
 	return ret;
 
