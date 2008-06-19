Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbYFSSwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbYFSSwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 14:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbYFSSw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 14:52:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbYFSSw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 14:52:27 -0400
Message-ID: <485AAACA.4010006@redhat.com>
Date: Thu, 19 Jun 2008 13:51:54 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Michael Halcrow <mhalcrow@us.ibm.com>, Jan Tluka <jtluka@redhat.com>
Subject: [PATCH (RESEND)] ecryptfs: propagate key errors up at mount time
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(re-sending this, forgot to actually put it on any list last time!)

Mounting with invalid key signatures should probably fail,
if they were specifically requested but not available.

Also fix case checks in process_request_key_err() for
the right sign of the errnos, as spotted by Jan Tluka.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Reported-by: Jan Tluka <jtluka@redhat.com>
---

Index: linux-2.6/fs/ecryptfs/keystore.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/keystore.c	2008-06-05 13:44:20.363046095 -0500
+++ linux-2.6/fs/ecryptfs/keystore.c	2008-06-13 15:16:37.738983417 -0500
@@ -44,15 +44,15 @@ static int process_request_key_err(long 
 	int rc = 0;
 
 	switch (err_code) {
-	case ENOKEY:
+	case -ENOKEY:
 		ecryptfs_printk(KERN_WARNING, "No key\n");
 		rc = -ENOENT;
 		break;
-	case EKEYEXPIRED:
+	case -EKEYEXPIRED:
 		ecryptfs_printk(KERN_WARNING, "Key expired\n");
 		rc = -ETIME;
 		break;
-	case EKEYREVOKED:
+	case -EKEYREVOKED:
 		ecryptfs_printk(KERN_WARNING, "Key revoked\n");
 		rc = -EINVAL;
 		break;
@@ -963,8 +963,7 @@ int ecryptfs_keyring_auth_tok_for_sig(st
 	if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
 		printk(KERN_ERR "Could not find key with description: [%s]\n",
 		       sig);
-		process_request_key_err(PTR_ERR(*auth_tok_key));
-		rc = -EINVAL;
+		rc = process_request_key_err(PTR_ERR(*auth_tok_key));
 		goto out;
 	}
 	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
Index: linux-2.6/fs/ecryptfs/main.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/main.c	2008-06-05 13:44:20.363046095 -0500
+++ linux-2.6/fs/ecryptfs/main.c	2008-06-13 15:16:37.756983075 -0500
@@ -262,10 +262,11 @@ static int ecryptfs_init_global_auth_tok
 			       "session keyring for sig specified in mount "
 			       "option: [%s]\n", global_auth_tok->sig);
 			global_auth_tok->flags |= ECRYPTFS_AUTH_TOK_INVALID;
-			rc = 0;
+			goto out;
 		} else
 			global_auth_tok->flags &= ~ECRYPTFS_AUTH_TOK_INVALID;
 	}
+out:
 	return rc;
 }
 
@@ -430,7 +431,6 @@ static int ecryptfs_parse_options(struct
 		printk(KERN_WARNING "One or more global auth toks could not "
 		       "properly register; rc = [%d]\n", rc);
 	}
-	rc = 0;
 out:
 	return rc;
 }



