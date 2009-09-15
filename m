Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbZIOT0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbZIOT0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbZIOTZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:25:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:51719 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758582AbZIOTZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:25:39 -0400
Message-Id: <20090915192242.714632996@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Wed, 16 Sep 2009 05:19:05 +1000
From: npiggin@suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch 2/5] fs: improve scalability of bdi writeback work queues
References: <20090915191903.290006007@suse.de>
Content-Disposition: inline; filename=fs-bdiwb-scale.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you're going to do an atomic RMW on each list entry, there's not much
point in all the RCU complexities of the list walking. This is only going
to help the multi-thread case I guess, but it doesn't hurt to do now.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/fs-writeback.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -736,8 +736,9 @@ static struct bdi_work *get_next_work_it
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(work, &bdi->work_list, list) {
-		if (!test_and_clear_bit(wb->nr, &work->seen))
+		if (!test_bit(wb->nr, &work->seen))
 			continue;
+		clear_bit(wb->nr, &work->seen);
 
 		ret = work;
 		break;


