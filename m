Return-Path: <linux-kernel-owner+w=401wt.eu-S967964AbXEHTuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967964AbXEHTuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967120AbXEHTtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:49:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031824AbXEHTtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:49:43 -0400
Date: Tue, 8 May 2007 20:48:45 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Heinz Mauelshagen <hjm@redhat.com>
Subject: [2.6.22 PATCH 22/26] dm: bio list helpers
Message-ID: <20070508194845.GC24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Heinz Mauelshagen <hjm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinz Mauelshagen <hjm@redhat.com>

More bio_list helper functions for new targets (including dm-delay and
dm-loop) to manipulate lists of bios.

Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
Signed-off-by: Bryn Reeves <breeves@redhat.com>
Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-bio-list.h |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+)

Index: linux-2.6.21/drivers/md/dm-bio-list.h
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-bio-list.h	2007-05-01 17:38:31.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-bio-list.h	2007-05-01 17:40:55.000000000 +0100
@@ -8,17 +8,43 @@
 #define DM_BIO_LIST_H
 
 #include <linux/bio.h>
+#include <linux/prefetch.h>
 
 struct bio_list {
 	struct bio *head;
 	struct bio *tail;
 };
 
+static inline int bio_list_empty(const struct bio_list *bl)
+{
+	return bl->head == NULL;
+}
+
+#define BIO_LIST_INIT { .head = NULL, .tail = NULL }
+
+#define BIO_LIST(bl) \
+	struct bio_list bl = BIO_LIST_INIT
+
 static inline void bio_list_init(struct bio_list *bl)
 {
 	bl->head = bl->tail = NULL;
 }
 
+#define bio_list_for_each(bio, bl) \
+	for (bio = (bl)->head; bio && ({ prefetch(bio->bi_next); 1; }); \
+	     bio = bio->bi_next)
+
+static inline unsigned bio_list_size(const struct bio_list *bl)
+{
+	unsigned sz = 0;
+	struct bio *bio;
+
+	bio_list_for_each(bio, bl)
+		sz++;
+
+	return sz;
+}
+
 static inline void bio_list_add(struct bio_list *bl, struct bio *bio)
 {
 	bio->bi_next = NULL;
