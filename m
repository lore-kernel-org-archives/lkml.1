Return-Path: <linux-kernel-owner+w=401wt.eu-S1763430AbYDNQk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763430AbYDNQk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763182AbYDNQj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:39:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:32518 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763159AbYDNQjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:39:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qO6dVEBGq+OlU8AKM3CTaxAjIPowJZu1cphNd2PLouFUFTJgqmfuvPUuasrN/Zol0bCdbbOPZYyGsbFfE7JnaJ/fa9/xkJOZ+H9Kg6YwVB8HshPubdn+UrNJdNAy4dCRsVvJ+254ASUk0E7TRilkIAvBOZiX+YH2gx9BTyfQx8Q=
Subject: [PATCH 08/10] pcmcia: Use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 09:37:56 -0700
Message-Id: <1208191076.5721.30.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/pcmcia/cistpl.c |   39 +++++++++++++++------------------------
 1 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
index 06a85d7..3637953 100644
--- a/drivers/pcmcia/cistpl.c
+++ b/drivers/pcmcia/cistpl.c
@@ -402,15 +402,6 @@ EXPORT_SYMBOL(pcmcia_replace_cis);
     
 ======================================================================*/
 
-static inline u16 cis_get_u16(void *ptr)
-{
-	return le16_to_cpu(get_unaligned((__le16 *) ptr));
-}
-static inline u32 cis_get_u32(void *ptr)
-{
-	return le32_to_cpu(get_unaligned((__le32 *) ptr));
-}
-
 typedef struct tuple_flags {
     u_int		link_space:4;
     u_int		has_link:1;
@@ -471,7 +462,7 @@ static int follow_link(struct pcmcia_socket *s, tuple_t *tuple)
 	/* Get indirect link from the MFC tuple */
 	read_cis_cache(s, LINK_SPACE(tuple->Flags),
 		       tuple->LinkOffset, 5, link);
-	ofs = cis_get_u32(link + 1);
+	ofs = get_unaligned_le32(link + 1);
 	SPACE(tuple->Flags) = (link[0] == CISTPL_MFC_ATTR);
 	/* Move to the next indirect link */
 	tuple->LinkOffset += 5;
@@ -679,8 +670,8 @@ static int parse_checksum(tuple_t *tuple, cistpl_checksum_t *csum)
     if (tuple->TupleDataLen < 5)
 	return CS_BAD_TUPLE;
     p = (u_char *) tuple->TupleData;
-    csum->addr = tuple->CISOffset + cis_get_u16(p) - 2;
-    csum->len = cis_get_u16(p + 2);
+    csum->addr = tuple->CISOffset + get_unaligned_le16(p) - 2;
+    csum->len = get_unaligned_le16(p + 2);
     csum->sum = *(p + 4);
     return CS_SUCCESS;
 }
@@ -691,7 +682,7 @@ static int parse_longlink(tuple_t *tuple, cistpl_longlink_t *link)
 {
     if (tuple->TupleDataLen < 4)
 	return CS_BAD_TUPLE;
-    link->addr = cis_get_u32(tuple->TupleData);
+    link->addr = get_unaligned_le32(tuple->TupleData);
     return CS_SUCCESS;
 }
 
@@ -710,7 +701,7 @@ static int parse_longlink_mfc(tuple_t *tuple,
 	return CS_BAD_TUPLE;
     for (i = 0; i < link->nfn; i++) {
 	link->fn[i].space = *p; p++;
-	link->fn[i].addr = cis_get_u32(p);
+	link->fn[i].addr = get_unaligned_le32(p);
 	p += 4;
     }
     return CS_SUCCESS;
@@ -800,8 +791,8 @@ static int parse_manfid(tuple_t *tuple, cistpl_manfid_t *m)
 {
     if (tuple->TupleDataLen < 4)
 	return CS_BAD_TUPLE;
-    m->manf = cis_get_u16(tuple->TupleData);
-    m->card = cis_get_u16(tuple->TupleData + 2);
+    m->manf = get_unaligned_le16(tuple->TupleData);
+    m->card = get_unaligned_le16(tuple->TupleData + 2);
     return CS_SUCCESS;
 }
 
@@ -1100,7 +1091,7 @@ static int parse_cftable_entry(tuple_t *tuple,
 	break;
     case 0x20:
 	entry->mem.nwin = 1;
-	entry->mem.win[0].len = cis_get_u16(p) << 8;
+	entry->mem.win[0].len = get_unaligned_le16(p) << 8;
 	entry->mem.win[0].card_addr = 0;
 	entry->mem.win[0].host_addr = 0;
 	p += 2;
@@ -1108,8 +1099,8 @@ static int parse_cftable_entry(tuple_t *tuple,
 	break;
     case 0x40:
 	entry->mem.nwin = 1;
-	entry->mem.win[0].len = cis_get_u16(p) << 8;
-	entry->mem.win[0].card_addr = cis_get_u16(p + 2) << 8;
+	entry->mem.win[0].len = get_unaligned_le16(p) << 8;
+	entry->mem.win[0].card_addr = get_unaligned_le16(p + 2) << 8;
 	entry->mem.win[0].host_addr = 0;
 	p += 4;
 	if (p > q) return CS_BAD_TUPLE;
@@ -1146,7 +1137,7 @@ static int parse_bar(tuple_t *tuple, cistpl_bar_t *bar)
     p = (u_char *)tuple->TupleData;
     bar->attr = *p;
     p += 2;
-    bar->size = cis_get_u32(p);
+    bar->size = get_unaligned_le32(p);
     return CS_SUCCESS;
 }
 
@@ -1159,7 +1150,7 @@ static int parse_config_cb(tuple_t *tuple, cistpl_config_t *config)
 	return CS_BAD_TUPLE;
     config->last_idx = *(++p);
     p++;
-    config->base = cis_get_u32(p);
+    config->base = get_unaligned_le32(p);
     config->subtuples = tuple->TupleDataLen - 6;
     return CS_SUCCESS;
 }
@@ -1275,7 +1266,7 @@ static int parse_vers_2(tuple_t *tuple, cistpl_vers_2_t *v2)
 
     v2->vers = p[0];
     v2->comply = p[1];
-    v2->dindex = cis_get_u16(p +2 );
+    v2->dindex = get_unaligned_le16(p +2 );
     v2->vspec8 = p[6];
     v2->vspec9 = p[7];
     v2->nhdr = p[8];
@@ -1316,8 +1307,8 @@ static int parse_format(tuple_t *tuple, cistpl_format_t *fmt)
 
     fmt->type = p[0];
     fmt->edc = p[1];
-    fmt->offset = cis_get_u32(p + 2);
-    fmt->length = cis_get_u32(p + 6);
+    fmt->offset = get_unaligned_le32(p + 2);
+    fmt->length = get_unaligned_le32(p + 6);
 
     return CS_SUCCESS;
 }
-- 
1.5.5.144.g3e42


