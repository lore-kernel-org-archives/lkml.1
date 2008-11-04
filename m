Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbYKDVie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbYKDVie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbYKDViL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:38:11 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:54602 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbYKDViJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:38:09 -0500
Date: Tue, 4 Nov 2008 15:38:05 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v8][PATCH 0/12] Kernel based checkpoint/restart
Message-ID: <20081104213805.GA14737@us.ibm.com>
References: <1225374675-22850-1-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225374675-22850-1-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> Basic checkpoint-restart [C/R]: v8 adds support for "external" checkpoint
> and improves documentation. Older announcements below.

Finally!

>From 8edab186b605f7dddd612e581204f1ad8fd766be Mon Sep 17 00:00:00 2001
From: Serge Hallyn <serue@us.ibm.com>
Date: Tue, 4 Nov 2008 15:28:01 -0600
Subject: [PATCH 1/1] cr: fix use of __d_path()

__d_path():
	1. should be used under dcache_lock
	2. can change root->{mnt,dentry} without changing refcounts
The second point was the cause of my BUGs.  The ctx->root was passed
in, and do_checkpoint() had taken a path_get on the vfsroot.  So now
at cleanup it was doing path_put() using another mnt+dentry.

(Why they are different, I'm not sure - but my guess would be that
stdin or stdout is inherited from the parent task in parent mntns,
hence file->mnt is different from root->mnt as it's a different
namespace.)

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
---
 checkpoint/checkpoint.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/checkpoint/checkpoint.c b/checkpoint/checkpoint.c
index 173b637..7f0c1e7 100644
--- a/checkpoint/checkpoint.c
+++ b/checkpoint/checkpoint.c
@@ -70,9 +70,20 @@ static char *
 cr_fill_fname(struct path *path, struct path *root, char *buf, int *n)
 {
 	char *fname;
+	struct path root2;
+
+	root2.mnt = root->mnt;
+	root2.dentry = root->dentry;
 
 	BUG_ON(!buf);
-	fname = __d_path(path, root, buf, *n);
+	spin_lock(&dcache_lock);
+	fname = __d_path(path, &root2, buf, *n);
+	spin_unlock(&dcache_lock);
+	if (root2.mnt != root->mnt)
+		printk(KERN_NOTICE "%s: mnt changed\n", __func__);
+	if (root2.dentry != root->dentry)
+		printk(KERN_NOTICE "%s: dentry changed\n", __func__);
+	fname = buf+10;
 	if (!IS_ERR(fname))
 		*n = (buf + (*n) - fname);
 	return fname;
-- 
1.5.6.3

