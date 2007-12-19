Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbXLSRun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbXLSRun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 12:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbXLSRuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 12:50:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37565 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbXLSRue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 12:50:34 -0500
Message-ID: <476959DB.1030507@redhat.com>
Date: Wed, 19 Dec 2007 11:50:19 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Michael Halcrow <mhalcrow@us.ibm.com>
CC: mike@halcrow.us
Subject: [PATCH] ecryptfs: remove debug as mount option, and warn if set via
 modprobe
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ecryptfs_debug really should not be a mount option; it is not per-mount,
but rather sets a global "ecryptfs_verbosity" variable which affects all
mounted filesysytems.  It's already settable as a module load option, 
I think we can leave it at that.

Also, if set, since secret values come out in debug messages, kick
things off with a stern warning.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

ndex: linux-2.6.24-rc3/fs/ecryptfs/main.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/ecryptfs/main.c
+++ linux-2.6.24-rc3/fs/ecryptfs/main.c
@@ -226,17 +226,15 @@ out:
 	return rc;
 }
 
-enum { ecryptfs_opt_sig, ecryptfs_opt_ecryptfs_sig, ecryptfs_opt_debug,
-       ecryptfs_opt_ecryptfs_debug, ecryptfs_opt_cipher,
-       ecryptfs_opt_ecryptfs_cipher, ecryptfs_opt_ecryptfs_key_bytes,
+enum { ecryptfs_opt_sig, ecryptfs_opt_ecryptfs_sig,
+       ecryptfs_opt_cipher, ecryptfs_opt_ecryptfs_cipher,
+       ecryptfs_opt_ecryptfs_key_bytes,
        ecryptfs_opt_passthrough, ecryptfs_opt_xattr_metadata,
        ecryptfs_opt_encrypted_view, ecryptfs_opt_err };
 
 static match_table_t tokens = {
 	{ecryptfs_opt_sig, "sig=%s"},
 	{ecryptfs_opt_ecryptfs_sig, "ecryptfs_sig=%s"},
-	{ecryptfs_opt_debug, "debug=%u"},
-	{ecryptfs_opt_ecryptfs_debug, "ecryptfs_debug=%u"},
 	{ecryptfs_opt_cipher, "cipher=%s"},
 	{ecryptfs_opt_ecryptfs_cipher, "ecryptfs_cipher=%s"},
 	{ecryptfs_opt_ecryptfs_key_bytes, "ecryptfs_key_bytes=%u"},
@@ -313,7 +311,6 @@ static int ecryptfs_parse_options(struct
 	substring_t args[MAX_OPT_ARGS];
 	int token;
 	char *sig_src;
-	char *debug_src;
 	char *cipher_name_dst;
 	char *cipher_name_src;
 	char *cipher_key_bytes_src;
@@ -341,16 +338,6 @@ static int ecryptfs_parse_options(struct
 			}
 			sig_set = 1;
 			break;
-		case ecryptfs_opt_debug:
-		case ecryptfs_opt_ecryptfs_debug:
-			debug_src = args[0].from;
-			ecryptfs_verbosity =
-				(int)simple_strtol(debug_src, &debug_src,
-						   0);
-			ecryptfs_printk(KERN_DEBUG,
-					"Verbosity set to [%d]" "\n",
-					ecryptfs_verbosity);
-			break;
 		case ecryptfs_opt_cipher:
 		case ecryptfs_opt_ecryptfs_cipher:
 			cipher_name_src = args[0].from;
@@ -911,6 +898,10 @@ static int __init ecryptfs_init(void)
 		       "rc = [%d]\n", rc);
 		goto out_release_messaging;
 	}
+	if (ecryptfs_verbosity > 0)
+		printk(KERN_CRIT "eCryptfs verbosity set to %d. Secret values "
+			"will be written to the syslog!\n", ecryptfs_verbosity);
+
 	goto out;
 out_release_messaging:
 	ecryptfs_release_messaging(ecryptfs_transport);
Index: linux-2.6.24-rc3/fs/ecryptfs/super.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/ecryptfs/super.c
+++ linux-2.6.24-rc3/fs/ecryptfs/super.c
@@ -175,10 +175,6 @@ static int ecryptfs_show_options(struct 
 	}
 	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
 
-	/* Note this is global and probably shouldn't be a mount option */
-	if (ecryptfs_verbosity)
-		seq_printf(m, ",ecryptfs_debug=%d\n", ecryptfs_verbosity);
-
 	seq_printf(m, ",ecryptfs_cipher=%s",
 		mount_crypt_stat->global_default_cipher_name);
 

