Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbXJIXZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbXJIXZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXJIXZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:25:10 -0400
Received: from namei.org ([69.55.235.186]:44329 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752085AbXJIXZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:25:09 -0400
Date: Wed, 10 Oct 2007 09:23:58 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 6/6] SELinux: kills warnings in Improve SELinux performance
 when AVC misses
In-Reply-To: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au>
Message-ID: <Xine.LNX.4.64.0710100923070.14862@us.intercode.com.au>
References: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: KaiGai Kohei <kaigai@kaigai.gr.jp>

This patch kills ugly warnings when the "Improve SELinux performance when 
AVC misses" patch.

Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/ss/ebitmap.c |   11 +++++------
 security/selinux/ss/ebitmap.h |    2 ++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/security/selinux/ss/ebitmap.c b/security/selinux/ss/ebitmap.c
index ae44c0c..c1a6b22 100644
--- a/security/selinux/ss/ebitmap.c
+++ b/security/selinux/ss/ebitmap.c
@@ -193,7 +193,7 @@ int ebitmap_netlbl_import(struct ebitmap *ebmap,
 			e_sft = delta % EBITMAP_UNIT_SIZE;
 			while (map) {
 				e_iter->maps[e_idx++] |= map & (-1UL);
-				map >>= EBITMAP_UNIT_SIZE;
+				map = EBITMAP_SHIFT_UNIT_SIZE(map);
 			}
 		}
 		c_iter = c_iter->next;
@@ -389,13 +389,13 @@ int ebitmap_read(struct ebitmap *e, void *fp)
 
 		if (startbit & (mapunit - 1)) {
 			printk(KERN_ERR "security: ebitmap start bit (%d) is "
-			       "not a multiple of the map unit size (%Zd)\n",
+			       "not a multiple of the map unit size (%u)\n",
 			       startbit, mapunit);
 			goto bad;
 		}
 		if (startbit > e->highbit - mapunit) {
 			printk(KERN_ERR "security: ebitmap start bit (%d) is "
-			       "beyond the end of the bitmap (%Zd)\n",
+			       "beyond the end of the bitmap (%u)\n",
 			       startbit, (e->highbit - mapunit));
 			goto bad;
 		}
@@ -433,9 +433,8 @@ int ebitmap_read(struct ebitmap *e, void *fp)
 
 		index = (startbit - n->startbit) / EBITMAP_UNIT_SIZE;
 		while (map) {
-			n->maps[index] = map & (-1UL);
-			map = map >> EBITMAP_UNIT_SIZE;
-			index++;
+			n->maps[index++] = map & (-1UL);
+			map = EBITMAP_SHIFT_UNIT_SIZE(map);
 		}
 	}
 ok:
diff --git a/security/selinux/ss/ebitmap.h b/security/selinux/ss/ebitmap.h
index e38a327..f283b43 100644
--- a/security/selinux/ss/ebitmap.h
+++ b/security/selinux/ss/ebitmap.h
@@ -21,6 +21,8 @@
 #define EBITMAP_UNIT_SIZE	BITS_PER_LONG
 #define EBITMAP_SIZE		(EBITMAP_UNIT_NUMS * EBITMAP_UNIT_SIZE)
 #define EBITMAP_BIT		1ULL
+#define EBITMAP_SHIFT_UNIT_SIZE(x)					\
+	(((x) >> EBITMAP_UNIT_SIZE / 2) >> EBITMAP_UNIT_SIZE / 2)
 
 struct ebitmap_node {
 	struct ebitmap_node *next;
-- 
1.5.2.4

