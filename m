Return-Path: <linux-kernel-owner+w=401wt.eu-S1750990AbXA0IY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990AbXA0IY2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 03:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbXA0IY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 03:24:27 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34842 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750990AbXA0IY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 03:24:26 -0500
Message-ID: <369886263.27547@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070127082529.253596257@mail.ustc.edu.cn>
References: <20070127080219.161473179@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 27 Jan 2007 16:02:21 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Martin Peschke <mp3@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] readahead: state based method routines: explicitly embed class_new/class_old inside flags
Content-Disposition: inline; filename=readahead-state-based-method-routines-explicitly-embed-class_new-class_old-inside-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The new/old ra class were implicitly stored in low bits of file_ra_state.flags.
Now make the data structure obvious, and remove the coding tricks.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 include/linux/fs.h |    9 ++++++++-
 mm/readahead.c     |   18 ++++--------------
 2 files changed, 12 insertions(+), 15 deletions(-)

--- linux-2.6.20-rc4-mm1.orig/include/linux/fs.h
+++ linux-2.6.20-rc4-mm1/include/linux/fs.h
@@ -738,7 +738,14 @@ struct file_ra_state {
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
 
-	unsigned long flags;	/* RA_FLAG_xxx | ra_class_old | ra_class_new */
+	union {
+		unsigned long	flags;	/* RA_FLAG_xxx | class_old | class_new */
+		struct {
+			u8	class_new;
+			u8	class_old;
+		};
+	};
+
 	unsigned long prev_page;	/* Cache last read() position */
 	unsigned long ra_pages;		/* Maximum readahead window */
 };
--- linux-2.6.20-rc4-mm1.orig/mm/readahead.c
+++ linux-2.6.20-rc4-mm1/mm/readahead.c
@@ -48,8 +48,6 @@ int readahead_hit_rate = 1;
 /*
  * Detailed classification of read-ahead behaviors.
  */
-#define RA_CLASS_SHIFT 4
-#define RA_CLASS_MASK  ((1 << RA_CLASS_SHIFT) - 1)
 enum ra_class {
 	RA_CLASS_ALL,
 	RA_CLASS_INITIAL,
@@ -795,12 +793,12 @@ out:
 
 static enum ra_class ra_class_new(struct file_ra_state *ra)
 {
-	return ra->flags & RA_CLASS_MASK;
+	return ra->class_new;
 }
 
 static inline enum ra_class ra_class_old(struct file_ra_state *ra)
 {
-	return (ra->flags >> RA_CLASS_SHIFT) & RA_CLASS_MASK;
+	return ra->class_old;
 }
 
 static unsigned long ra_readahead_size(struct file_ra_state *ra)
@@ -832,16 +830,8 @@ static int ra_has_index(struct file_ra_s
  */
 static void ra_set_class(struct file_ra_state *ra, enum ra_class ra_class)
 {
-	unsigned long flags_mask;
-	unsigned long flags;
-	unsigned long old_ra_class;
-
-	flags_mask = ~(RA_CLASS_MASK | (RA_CLASS_MASK << RA_CLASS_SHIFT));
-	flags = ra->flags & flags_mask;
-
-	old_ra_class = ra_class_new(ra) << RA_CLASS_SHIFT;
-
-	ra->flags = flags | old_ra_class | ra_class;
+	ra->class_old = ra->class_new;
+	ra->class_new = ra_class;
 }
 
 /*

--
