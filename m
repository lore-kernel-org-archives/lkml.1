Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbZKWJhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbZKWJhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbZKWJhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:37:51 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:64889 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422AbZKWJhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:37:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=pBjeL9duWjI7O85MhgiIGA96QDYwZMFvL5DY6yZjrLTU4dFobQtMImguOHqQcAPIY1
         rn6A0AJs58KjoOJy32wgmTxLM+PRLMMofc0ofNk3eEiOqSOo6LAZr/Rl5reDh4QpVd64
         aneZRm2b495DaFn10p/GwIentlUZNBRDwCErI=
MIME-Version: 1.0
Date: Mon, 23 Nov 2009 17:37:57 +0800
Message-ID: <51d384e10911230137q7553b8c4x5ba3aca3e8edbc77@mail.gmail.com>
Subject: [PATCH] dvb-core: Fix ULE decapsulation bug when less than 4 bytes of 
	ULE SNDU is packed into the remaining bytes of a MPEG2-TS frame
From: Ang Way Chuang <wcang79@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ULE (Unidirectional Lightweight Encapsulation RFC 4326) decapsulation
code has a bug that incorrectly treats ULE SNDU packed into the
remaining 2 or 3 bytes of a MPEG2-TS frame as having invalid pointer
field on the subsequent MPEG2-TS frame.

This patch was generated and tested against v2.6.32-rc8. Similar patch
was applied and tested using 2.6.27 which is similar to the latest
dvb_net.c, except for network device statistical data structure. I
suspect that this bug was introduced in kernel version 2.6.15, but had
not verified it.

Care has been taken not to introduce more bug by fixing this bug, but
please scrutinize the code for I always produces buggy code.

Signed-off-by: Ang Way Chuang <wcang@nav6.org>
---
diff --git a/drivers/media/dvb/dvb-core/dvb_net.c
b/drivers/media/dvb/dvb-core/dvb_net.c
index 0241a7c..7e0db86 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -458,8 +458,9 @@ static void dvb_net_ule( struct net_device *dev,
const u8 *buf, size_t buf_len )
 						       "field: %u.\n", priv->ts_count, *from_where);

 						/* Drop partly decoded SNDU, reset state, resync on PUSI. */
-						if (priv->ule_skb) {
-							dev_kfree_skb( priv->ule_skb );
+						if (priv->ule_skb || priv->ule_sndu_remain) {
+							if (priv->ule_skb)
+								dev_kfree_skb( priv->ule_skb );
 							dev->stats.rx_errors++;
 							dev->stats.rx_frame_errors++;
 						}
@@ -533,6 +534,7 @@ static void dvb_net_ule( struct net_device *dev,
const u8 *buf, size_t buf_len )
 				from_where += 2;
 			}

+			priv->ule_sndu_remain = priv->ule_sndu_len + 2;
 			/*
 			 * State of current TS:
 			 *   ts_remain (remaining bytes in the current TS cell)
@@ -542,6 +544,7 @@ static void dvb_net_ule( struct net_device *dev,
const u8 *buf, size_t buf_len )
 			 */
 			switch (ts_remain) {
 				case 1:
+					priv->ule_sndu_remain--;
 					priv->ule_sndu_type = from_where[0] << 8;
 					priv->ule_sndu_type_1 = 1; /* first byte of ule_type is set. */
 					ts_remain -= 1; from_where += 1;
@@ -555,6 +558,7 @@ static void dvb_net_ule( struct net_device *dev,
const u8 *buf, size_t buf_len )
 				default: /* complete ULE header is present in current TS. */
 					/* Extract ULE type field. */
 					if (priv->ule_sndu_type_1) {
+						priv->ule_sndu_type_1 = 0;
 						priv->ule_sndu_type |= from_where[0];
 						from_where += 1; /* points to payload start. */
 						ts_remain -= 1;
