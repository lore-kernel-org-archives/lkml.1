Return-Path: <linux-kernel-owner+w=401wt.eu-S1765001AbXJPEsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765001AbXJPEsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 00:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbXJPEs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 00:48:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35148 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbXJPEs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 00:48:27 -0400
Date: Tue, 16 Oct 2007 06:47:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] lockdep: fixup the inode dir annotation
Message-ID: <20071016044754.GA16762@elte.hu>
References: <1192469455.27435.87.camel@twins> <alpine.LFD.0.999.0710151813390.6887@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710151813390.6887@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > please pull the lockdep tree from:
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git 
> >  v2.6.24-lockdep
> 
> Hmm. I'm now getting
> 
> 	WARNING: at kernel/lockdep.c:700 look_up_lock_class()

it triggered here too - the patch from Peter below was tested overnight 
and seems to do the trick for me.

	Ingo

--------------------->
Subject: lockdep: fixup the inode dir annotation

A slight oversight tripped lockdep debugging code, each lockdep
class should have but a single init site.

Rearange the code to make this true.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/inode.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: linux/fs/inode.c
===================================================================
--- linux.orig/fs/inode.c
+++ linux/fs/inode.c
@@ -568,16 +568,16 @@ EXPORT_SYMBOL(new_inode);
 void unlock_new_inode(struct inode *inode)
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct file_system_type *type = inode->i_sb->s_type;
-	/*
-	 * ensure nobody is actually holding i_mutex
-	 */
-	mutex_destroy(&inode->i_mutex);
-	mutex_init(&inode->i_mutex);
-	if (inode->i_mode & S_IFDIR)
+	if (inode->i_mode & S_IFDIR) {
+		struct file_system_type *type = inode->i_sb->s_type;
+
+		/*
+		 * ensure nobody is actually holding i_mutex
+		 */
+		mutex_destroy(&inode->i_mutex);
+		mutex_init(&inode->i_mutex);
 		lockdep_set_class(&inode->i_mutex, &type->i_mutex_dir_key);
-	else
-		lockdep_set_class(&inode->i_mutex, &type->i_mutex_key);
+	}
 #endif
 	/*
 	 * This is special!  We do not need the spinlock
