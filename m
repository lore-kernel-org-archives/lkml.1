Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbZJ3Nkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbZJ3Nkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 09:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbZJ3Nka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 09:40:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214AbZJ3Nk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 09:40:29 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, zach.brown@oracle.com
Subject: [patch] aio: Don't zero out the pages array inside struct dio
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 30 Oct 2009 09:39:55 -0400
Message-ID: <x49tyxhroes.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Intel reported a performance regression caused by the following commit:

commit 848c4dd5153c7a0de55470ce99a8e13a63b4703f
Author: Zach Brown <zach.brown@oracle.com>
Date:   Mon Aug 20 17:12:01 2007 -0700

    dio: zero struct dio with kzalloc instead of manually

    This patch uses kzalloc to zero all of struct dio rather than
    manually trying to track which fields we rely on being zero.  It
    passed aio+dio stress testing and some bug regression testing on
    ext3.

    This patch was introduced by Linus in the conversation that lead up
    to Badari's minimal fix to manually zero .map_bh.b_state in commit:

      6a648fa72161d1f6468dabd96c5d3c0db04f598a

    It makes the code a bit smaller.  Maybe a couple fewer cachelines to
    load, if we're lucky:

       text    data     bss     dec     hex filename
    3285925  568506 1304616 5159047  4eb887 vmlinux
    3285797  568506 1304616 5158919  4eb807 vmlinux.patched

    I was unable to measure a stable difference in the number of cpu
    cycles spent in blockdev_direct_IO() when pushing aio+dio 256K reads
    at ~340MB/s.

    So the resulting intent of the patch isn't a performance gain but to
    avoid exposing ourselves to the risk of finding another field like
    .map_bh.b_state where we rely on zeroing but don't enforce it in the
    code.

Zach surmised that zeroing out the page array was what caused most of
the problem, and suggested the approach taken in the attached patch for
resolving the issue.  Intel re-tested with this patch and saw a 0.6%
performance gain (the original regression was 0.5%).

Comments, as always, are appreciated.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Zach Brown <zach.brown@oracle.com>

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 8b10b87..533bd30 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -104,6 +104,18 @@ struct dio {
 	unsigned cur_page_len;		/* Nr of bytes at cur_page_offset */
 	sector_t cur_page_block;	/* Where it starts */
 
+	/* BIO completion state */
+	spinlock_t bio_lock;		/* protects BIO fields below */
+	unsigned long refcount;		/* direct_io_worker() and bios */
+	struct bio *bio_list;		/* singly linked via bi_private */
+	struct task_struct *waiter;	/* waiting task (NULL if none) */
+
+	/* AIO related stuff */
+	struct kiocb *iocb;		/* kiocb */
+	int is_async;			/* is IO async ? */
+	int io_error;			/* IO error in completion path */
+	ssize_t result;                 /* IO result */
+
 	/*
 	 * Page fetching state. These variables belong to dio_refill_pages().
 	 */
@@ -115,22 +127,10 @@ struct dio {
 	 * Page queue.  These variables belong to dio_refill_pages() and
 	 * dio_get_page().
 	 */
-	struct page *pages[DIO_PAGES];	/* page buffer */
 	unsigned head;			/* next page to process */
 	unsigned tail;			/* last valid page + 1 */
 	int page_errors;		/* errno from get_user_pages() */
-
-	/* BIO completion state */
-	spinlock_t bio_lock;		/* protects BIO fields below */
-	unsigned long refcount;		/* direct_io_worker() and bios */
-	struct bio *bio_list;		/* singly linked via bi_private */
-	struct task_struct *waiter;	/* waiting task (NULL if none) */
-
-	/* AIO related stuff */
-	struct kiocb *iocb;		/* kiocb */
-	int is_async;			/* is IO async ? */
-	int io_error;			/* IO error in completion path */
-	ssize_t result;                 /* IO result */
+	struct page *pages[DIO_PAGES];	/* page buffer */
 };
 
 /*
@@ -1151,10 +1151,16 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 		}
 	}
 
-	dio = kzalloc(sizeof(*dio), GFP_KERNEL);
+	dio = kmalloc(sizeof(*dio), GFP_KERNEL);
 	retval = -ENOMEM;
 	if (!dio)
 		goto out;
+	/*
+	 * Believe it or not, zeroing out the page array caused a .5%
+	 * performance regression in a database benchmark.  So, we take
+	 * care to only zero out what's needed.
+	 */
+	memset(dio, 0, offsetof(struct dio, pages));
 
 	/*
 	 * For block device access DIO_NO_LOCKING is used,
