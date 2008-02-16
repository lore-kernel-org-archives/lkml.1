Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbYBPDXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbYBPDXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 22:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759442AbYBPDWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 22:22:49 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:22842 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbYBPDWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 22:22:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vZibkwddTymvzVT0350JsnxYYi04Y7jPIiha04Tz2BqEc2pN6DH9SFkzQuxtL78wbkSy9BnqCEWCGIzu6pZT1i64QJcdelWs70oaqmXVCI2QPFDLYepIcxFkuSHkGNbIzEi9eHBUN5nTUWsaNoqtvg834e5zPx7xUwtav95F3Ks=
Subject: [PATCH 4/4] jffs2: fix sparse warnings in gc.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 19:22:16 -0800
Message-Id: <1203132137.7442.35.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/jffs2/gc.c:1147:29: warning: symbol 'jeb' shadows an earlier one
fs/jffs2/gc.c:1084:89: originally declared here
fs/jffs2/gc.c:1197:29: warning: symbol 'jeb' shadows an earlier one
fs/jffs2/gc.c:1084:89: originally declared here

Add an sb_ prefix to the inner jeb variables as they are taken from
the super_blocks list.

It appears jffs2_garbage_collect_dnode never uses its jeb argument,
so as an alternative that could be dropped and the one caller adusted
then the inner variables would not need to be touched.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/jffs2/gc.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/jffs2/gc.c b/fs/jffs2/gc.c
index 32ff037..855ca05 100644
--- a/fs/jffs2/gc.c
+++ b/fs/jffs2/gc.c
@@ -1144,24 +1144,24 @@ static int jffs2_garbage_collect_dnode(struct jffs2_sb_info *c, struct jffs2_era
 				   If not, cover it anyway. */
 
 				struct jffs2_raw_node_ref *raw = frag->node->raw;
-				struct jffs2_eraseblock *jeb;
+				struct jffs2_eraseblock *sb_jeb;
 
-				jeb = &c->blocks[raw->flash_offset / c->sector_size];
+				sb_jeb = &c->blocks[raw->flash_offset / c->sector_size];
 
-				if (jeb == c->gcblock) {
+				if (sb_jeb == c->gcblock) {
 					D1(printk(KERN_DEBUG "Expanding down to cover frag (0x%x-0x%x) in gcblock at %08x\n",
 						  frag->ofs, frag->ofs+frag->size, ref_offset(raw)));
 					start = frag->ofs;
 					break;
 				}
-				if (!ISDIRTY(jeb->dirty_size + jeb->wasted_size)) {
+				if (!ISDIRTY(sb_jeb->dirty_size + sb_jeb->wasted_size)) {
 					D1(printk(KERN_DEBUG "Not expanding down to cover frag (0x%x-0x%x) in clean block %08x\n",
-						  frag->ofs, frag->ofs+frag->size, jeb->offset));
+						  frag->ofs, frag->ofs+frag->size, sb_jeb->offset));
 					break;
 				}
 
 				D1(printk(KERN_DEBUG "Expanding down to cover frag (0x%x-0x%x) in dirty block %08x\n",
-						  frag->ofs, frag->ofs+frag->size, jeb->offset));
+						  frag->ofs, frag->ofs+frag->size, sb_jeb->offset));
 				start = frag->ofs;
 				break;
 			}
@@ -1194,24 +1194,24 @@ static int jffs2_garbage_collect_dnode(struct jffs2_sb_info *c, struct jffs2_era
 				   If not, cover it anyway. */
 
 				struct jffs2_raw_node_ref *raw = frag->node->raw;
-				struct jffs2_eraseblock *jeb;
+				struct jffs2_eraseblock *sb_jeb;
 
-				jeb = &c->blocks[raw->flash_offset / c->sector_size];
+				sb_jeb = &c->blocks[raw->flash_offset / c->sector_size];
 
-				if (jeb == c->gcblock) {
+				if (sb_jeb == c->gcblock) {
 					D1(printk(KERN_DEBUG "Expanding up to cover frag (0x%x-0x%x) in gcblock at %08x\n",
 						  frag->ofs, frag->ofs+frag->size, ref_offset(raw)));
 					end = frag->ofs + frag->size;
 					break;
 				}
-				if (!ISDIRTY(jeb->dirty_size + jeb->wasted_size)) {
+				if (!ISDIRTY(sb_jeb->dirty_size + sb_jeb->wasted_size)) {
 					D1(printk(KERN_DEBUG "Not expanding up to cover frag (0x%x-0x%x) in clean block %08x\n",
-						  frag->ofs, frag->ofs+frag->size, jeb->offset));
+						  frag->ofs, frag->ofs+frag->size, sb_jeb->offset));
 					break;
 				}
 
 				D1(printk(KERN_DEBUG "Expanding up to cover frag (0x%x-0x%x) in dirty block %08x\n",
-						  frag->ofs, frag->ofs+frag->size, jeb->offset));
+						  frag->ofs, frag->ofs+frag->size, sb_jeb->offset));
 				end = frag->ofs + frag->size;
 				break;
 			}
-- 
1.5.4.1.1278.gc75be

