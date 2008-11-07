Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbYKGXYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbYKGXYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYKGXW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:22:56 -0500
Received: from kroah.org ([198.145.64.141]:59193 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753540AbYKGXWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:22:55 -0500
Date: Fri, 7 Nov 2008 15:15:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 05/23] net: Fix recursive descent in __scm_destroy().
Message-ID: <20081107231523.GF1108@kroah.com>
References: <20081107224818.593212310@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-fix-recursive-descent-in-__scm_destroy.patch"
In-Reply-To: <20081107231457.GA1108@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Miller <davem@davemloft.net>

commit f8d570a4745835f2238a33b537218a1bb03fc671 and
3b53fbf4314594fa04544b02b2fc6e607912da18 upstream (because once wasn't
good enough...)

__scm_destroy() walks the list of file descriptors in the scm_fp_list
pointed to by the scm_cookie argument.

Those, in turn, can close sockets and invoke __scm_destroy() again.

There is nothing which limits how deeply this can occur.

The idea for how to fix this is from Linus.  Basically, we do all of
the fput()s at the top level by collecting all of the scm_fp_list
objects hit by an fput().  Inside of the initial __scm_destroy() we
keep running the list until it is empty.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/sched.h |    4 +++-
 include/net/scm.h     |    5 +++--
 net/core/scm.c        |   24 +++++++++++++++++++++---
 3 files changed, 27 insertions(+), 6 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1288,7 +1288,9 @@ struct task_struct {
 	atomic_t fs_excl;	/* holding fs exclusive resources */
 	struct rcu_head rcu;
 
-	/*
+	struct list_head	*scm_work_list;
+
+/*
 	 * cache last used pipe for splice
 	 */
 	struct pipe_inode_info *splice_pipe;
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -14,8 +14,9 @@
 
 struct scm_fp_list
 {
-	int		count;
-	struct file	*fp[SCM_MAX_FD];
+	struct list_head	list;
+	int			count;
+	struct file		*fp[SCM_MAX_FD];
 };
 
 struct scm_cookie
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -75,6 +75,7 @@ static int scm_fp_copy(struct cmsghdr *c
 		if (!fpl)
 			return -ENOMEM;
 		*fplp = fpl;
+		INIT_LIST_HEAD(&fpl->list);
 		fpl->count = 0;
 	}
 	fpp = &fpl->fp[fpl->count];
@@ -106,9 +107,25 @@ void __scm_destroy(struct scm_cookie *sc
 
 	if (fpl) {
 		scm->fp = NULL;
-		for (i=fpl->count-1; i>=0; i--)
-			fput(fpl->fp[i]);
-		kfree(fpl);
+		if (current->scm_work_list) {
+			list_add_tail(&fpl->list, current->scm_work_list);
+		} else {
+			LIST_HEAD(work_list);
+
+			current->scm_work_list = &work_list;
+
+			list_add(&fpl->list, &work_list);
+			while (!list_empty(&work_list)) {
+				fpl = list_first_entry(&work_list, struct scm_fp_list, list);
+
+				list_del(&fpl->list);
+				for (i=fpl->count-1; i>=0; i--)
+					fput(fpl->fp[i]);
+				kfree(fpl);
+			}
+
+			current->scm_work_list = NULL;
+		}
 	}
 }
 
@@ -284,6 +301,7 @@ struct scm_fp_list *scm_fp_dup(struct sc
 
 	new_fpl = kmalloc(sizeof(*fpl), GFP_KERNEL);
 	if (new_fpl) {
+		INIT_LIST_HEAD(&new_fpl->list);
 		for (i=fpl->count-1; i>=0; i--)
 			get_file(fpl->fp[i]);
 		memcpy(new_fpl, fpl, sizeof(*fpl));

-- 
