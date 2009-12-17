Return-Path: <linux-kernel-owner+w=401wt.eu-S936468AbZLQEX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936468AbZLQEX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965079AbZLQEWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:22:52 -0500
Received: from kroah.org ([198.145.64.141]:55824 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935958AbZLQEFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:07 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:56 2009
Message-Id: <20091217035656.740124090@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [106/151] dm crypt: make wipe message also wipe essiv key
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Milan Broz <mbroz@redhat.com>

commit 542da317668c35036e8471822a564b609d05af66 upstream.

The "wipe key" message is used to wipe the volume key from memory
temporarily, for example when suspending to RAM.

But the initialisation vector in ESSIV mode is calculated from the
hashed volume key, so the wipe message should wipe this IV key too and
reinitialise it when the volume key is reinstated.

This patch adds an IV wipe method called from a wipe message callback.
ESSIV is then reinitialised using the init function added by the
last patch.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-crypt.c |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2003 Christophe Saout <christophe@saout.de>
  * Copyright (C) 2004 Clemens Fruhwirth <clemens@endorphin.org>
- * Copyright (C) 2006-2008 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2006-2009 Red Hat, Inc. All rights reserved.
  *
  * This file is released under the GPL.
  */
@@ -72,6 +72,7 @@ struct crypt_iv_operations {
 		   const char *opts);
 	void (*dtr)(struct crypt_config *cc);
 	int (*init)(struct crypt_config *cc);
+	int (*wipe)(struct crypt_config *cc);
 	int (*generator)(struct crypt_config *cc, u8 *iv, sector_t sector);
 };
 
@@ -199,6 +200,17 @@ static int crypt_iv_essiv_init(struct cr
 				    crypto_hash_digestsize(essiv->hash_tfm));
 }
 
+/* Wipe salt and reset key derived from volume key */
+static int crypt_iv_essiv_wipe(struct crypt_config *cc)
+{
+	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
+	unsigned salt_size = crypto_hash_digestsize(essiv->hash_tfm);
+
+	memset(essiv->salt, 0, salt_size);
+
+	return crypto_cipher_setkey(essiv->tfm, essiv->salt, salt_size);
+}
+
 static void crypt_iv_essiv_dtr(struct crypt_config *cc)
 {
 	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
@@ -334,6 +346,7 @@ static struct crypt_iv_operations crypt_
 	.ctr       = crypt_iv_essiv_ctr,
 	.dtr       = crypt_iv_essiv_dtr,
 	.init      = crypt_iv_essiv_init,
+	.wipe      = crypt_iv_essiv_wipe,
 	.generator = crypt_iv_essiv_gen
 };
 
@@ -1310,6 +1323,7 @@ static void crypt_resume(struct dm_targe
 static int crypt_message(struct dm_target *ti, unsigned argc, char **argv)
 {
 	struct crypt_config *cc = ti->private;
+	int ret = -EINVAL;
 
 	if (argc < 2)
 		goto error;
@@ -1319,10 +1333,22 @@ static int crypt_message(struct dm_targe
 			DMWARN("not suspended during key manipulation.");
 			return -EINVAL;
 		}
-		if (argc == 3 && !strnicmp(argv[1], MESG_STR("set")))
-			return crypt_set_key(cc, argv[2]);
-		if (argc == 2 && !strnicmp(argv[1], MESG_STR("wipe")))
+		if (argc == 3 && !strnicmp(argv[1], MESG_STR("set"))) {
+			ret = crypt_set_key(cc, argv[2]);
+			if (ret)
+				return ret;
+			if (cc->iv_gen_ops && cc->iv_gen_ops->init)
+				ret = cc->iv_gen_ops->init(cc);
+			return ret;
+		}
+		if (argc == 2 && !strnicmp(argv[1], MESG_STR("wipe"))) {
+			if (cc->iv_gen_ops && cc->iv_gen_ops->wipe) {
+				ret = cc->iv_gen_ops->wipe(cc);
+				if (ret)
+					return ret;
+			}
 			return crypt_wipe_key(cc);
+		}
 	}
 
 error:


