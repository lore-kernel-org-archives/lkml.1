Return-Path: <linux-kernel-owner+w=401wt.eu-S940245AbXGSQ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940245AbXGSQ5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935310AbXGSQ44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:56:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51503 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934863AbXGSQ4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:56:55 -0400
Date: Thu, 19 Jul 2007 18:56:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
Subject: [patch] afs: build fix
Message-ID: <20070719165646.GA18436@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: afs: build fix
From: Ingo Molnar <mingo@elte.hu>

this fresh commit:

 commit e8d6c554126b830217c5e9f549e0e21f865a0a8a
 Author: David Howells <dhowells@redhat.com>
 Date:   Sun Jul 15 23:40:12 2007 -0700

     AFS: implement file locking

     Implement file locking for AFS.

did not even build (in an allyesconfig) because it forgot to take this
recent commit into account:

 commit 6d34ac199a4af5c678a3a8f3275aeb2586b72da3
 Author: J. Bruce Fields <bfields@citi.umich.edu>
 Date:   Fri May 11 16:09:32 2007 -0400

     locks: make posix_test_lock() interface more consistent

the fix is trivial.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/afs/flock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/fs/afs/flock.c
===================================================================
--- linux.orig/fs/afs/flock.c
+++ linux/fs/afs/flock.c
@@ -456,7 +456,8 @@ static int afs_do_getlk(struct file *fil
 
 	/* check local lock records first */
 	ret = 0;
-	if (posix_test_lock(file, fl) == 0) {
+	posix_test_lock(file, fl);
+	if (fl->fl_type == F_UNLCK) {
 		/* no local locks; consult the server */
 		ret = afs_vnode_fetch_status(vnode, NULL, key);
 		if (ret < 0)
