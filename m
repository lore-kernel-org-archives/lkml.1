Return-Path: <linux-kernel-owner+w=401wt.eu-S1763814AbZFMQeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763814AbZFMQeA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761768AbZFMQdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:33:31 -0400
Received: from mail-fx0-f206.google.com ([209.85.220.206]:65246 "EHLO
	mail-fx0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365AbZFMQd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:33:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=oA8traKxr8qLVjQA0diIr3mfBpi2QF649Nr9kElsDHqmaYTDEwEvGpQqpJ3uyivDvb
         hCg98ic4+mh7OXsFs+6grU/l9BFsK2EtwL7LAJoGuhtemFMVCmpuuyWdSQ9ckCiRN4lx
         8SN9hhTZquFu60Fz0g7HYVf4jTVsg88o5x6qU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH] Staging: rtl8192su: remove unused ieee80211_crypt.h
Date: Sat, 13 Jun 2009 18:30:22 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090612-07181-g84f26e4; KDE/4.2.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906131830.23119.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/ieee80211_crypt.h |   86 ----------------------------
 1 file changed, 86 deletions(-)

Index: b/drivers/staging/rtl8192su/ieee80211_crypt.h
===================================================================
--- a/drivers/staging/rtl8192su/ieee80211_crypt.h
+++ /dev/null
@@ -1,86 +0,0 @@
-/*
- * Original code based on Host AP (software wireless LAN access point) driver
- * for Intersil Prism2/2.5/3.
- *
- * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
- * <jkmaline@cc.hut.fi>
- * Copyright (c) 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
- *
- * Adaption to a generic IEEE 802.11 stack by James Ketrenos
- * <jketreno@linux.intel.com>
- *
- * Copyright (c) 2004, Intel Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation. See README and COPYING for
- * more details.
- */
-
-/*
- * This file defines the interface to the ieee80211 crypto module.
- */
-#ifndef IEEE80211_CRYPT_H
-#define IEEE80211_CRYPT_H
-
-#include <linux/skbuff.h>
-
-struct ieee80211_crypto_ops {
-	const char *name;
-
-	/* init new crypto context (e.g., allocate private data space,
-	 * select IV, etc.); returns NULL on failure or pointer to allocated
-	 * private data on success */
-	void * (*init)(int keyidx);
-
-	/* deinitialize crypto context and free allocated private data */
-	void (*deinit)(void *priv);
-
-	/* encrypt/decrypt return < 0 on error or >= 0 on success. The return
-	 * value from decrypt_mpdu is passed as the keyidx value for
-	 * decrypt_msdu. skb must have enough head and tail room for the
-	 * encryption; if not, error will be returned; these functions are
-	 * called for all MPDUs (i.e., fragments).
-	 */
-	int (*encrypt_mpdu)(struct sk_buff *skb, int hdr_len, void *priv);
-	int (*decrypt_mpdu)(struct sk_buff *skb, int hdr_len, void *priv);
-
-	/* These functions are called for full MSDUs, i.e. full frames.
-	 * These can be NULL if full MSDU operations are not needed. */
-	int (*encrypt_msdu)(struct sk_buff *skb, int hdr_len, void *priv);
-	int (*decrypt_msdu)(struct sk_buff *skb, int keyidx, int hdr_len,
-			    void *priv);
-
-	int (*set_key)(void *key, int len, u8 *seq, void *priv);
-	int (*get_key)(void *key, int len, u8 *seq, void *priv);
-
-	/* procfs handler for printing out key information and possible
-	 * statistics */
-	char * (*print_stats)(char *p, void *priv);
-
-	/* maximum number of bytes added by encryption; encrypt buf is
-	 * allocated with extra_prefix_len bytes, copy of in_buf, and
-	 * extra_postfix_len; encrypt need not use all this space, but
-	 * the result must start at the beginning of the buffer and correct
-	 * length must be returned */
-	int extra_prefix_len, extra_postfix_len;
-
-	struct module *owner;
-};
-
-struct ieee80211_crypt_data {
-	struct list_head list; /* delayed deletion list */
-	struct ieee80211_crypto_ops *ops;
-	void *priv;
-	atomic_t refcnt;
-};
-
-int ieee80211_register_crypto_ops(struct ieee80211_crypto_ops *ops);
-int ieee80211_unregister_crypto_ops(struct ieee80211_crypto_ops *ops);
-struct ieee80211_crypto_ops * ieee80211_get_crypto_ops(const char *name);
-void ieee80211_crypt_deinit_entries(struct ieee80211_device *, int);
-void ieee80211_crypt_deinit_handler(unsigned long);
-void ieee80211_crypt_delayed_deinit(struct ieee80211_device *ieee,
-				    struct ieee80211_crypt_data **crypt);
-
-#endif
