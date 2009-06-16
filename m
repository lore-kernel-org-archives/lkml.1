Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbZFPKg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbZFPKg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbZFPKgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:36:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58180 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbZFPKgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:36:17 -0400
Date: Tue, 16 Jun 2009 12:36:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Joerg Roedel <joerg.roedel@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in tty ldisc and friends
Message-ID: <20090616103606.GA3497@elte.hu>
References: <alpine.DEB.2.00.0906160144340.26673@gandalf.stny.rr.com> <20090616093741.0d5b36bc@lxorguk.ukuu.org.uk> <20090616085028.GA13771@elte.hu> <20090616095706.36f01282@lxorguk.ukuu.org.uk> <20090616100015.GD6432@elte.hu> <20090616110419.14bc9485@lxorguk.ukuu.org.uk> <20090616101240.GB28204@elte.hu> <20090616102509.GA32717@elte.hu> <20090616102910.GA11011@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616102910.GA11011@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> This is something we noticed recently: dma-debug uses a lot of 
> lock classes and thus creates a really large lock-graph, depleting 
> the reserves quickly.

yep, i think dma-debug is the culprit. It has:

 #define HASH_SIZE       1024ULL

each hash entry has a separate lock.

But this should be easily to solve: a special lock-class for these 
locks. Patch below (warning: utterly untested!).

(Btw., that SPIN_LOCK_UNLOCKED init method should really be 
deprecated for real.)

	Ingo

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 3b93129..012c240 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -62,6 +62,8 @@ struct dma_debug_entry {
 #endif
 };
 
+static struct lock_class_key hash_bucket_class;
+
 struct hash_bucket {
 	struct list_head list;
 	spinlock_t lock;
@@ -716,7 +718,8 @@ void dma_debug_init(u32 num_entries)
 
 	for (i = 0; i < HASH_SIZE; ++i) {
 		INIT_LIST_HEAD(&dma_entry_hash[i].list);
-		dma_entry_hash[i].lock = SPIN_LOCK_UNLOCKED;
+		spin_lock_init(&dma_entry_hash[i].lock);
+		lockdep_set_lock_class(&dma_entry_hash[i].lock, &hash_bucket_class);
 	}
 
 	if (dma_debug_fs_init() != 0) {
