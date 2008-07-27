Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbYG0FRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbYG0FRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 01:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYG0FRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 01:17:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43587 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYG0FRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 01:17:05 -0400
Date: Sun, 27 Jul 2008 06:17:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Kara <jack@ucw.cz>, Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Re: 2.6.26-mmotm-0724 - linux-next.git loses
	/proc/sys/fs/quota, breaks disk quotas
Message-ID: <20080727051702.GY28946@ZenIV.linux.org.uk>
References: <14615.1217125366@turing-police.cc.vt.edu> <20080726202525.3ac3052f.akpm@linux-foundation.org> <21657.1217130229@turing-police.cc.vt.edu> <20080727040908.GX28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727040908.GX28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 05:09:08AM +0100, Al Viro wrote:
> On Sat, Jul 26, 2008 at 11:43:49PM -0400, Valdis.Kletnieks@vt.edu wrote:
> 
> > > Ah, it seems to be taking a little vacation over in
> > > /proc/sys/kernel/.  Curious.
> > 
> > Wow. I never *thought* to look for it there, and neither did my userspace :)
> 
> Wow, indeed...  Very odd, since there shouldn't be any way for that
> to end up there.  Off to try and reproduce it...

Wait... I remember fixing exactly that, but the fix is not in there...
Bugger.  Botched "fold on reorder", fortunately still findable in old local
branch.

Anyway, I know what's going on; will test in a few, but I'm fairly sure what it
is.  The lost fix is to have try_attach() walk into the right subdirectory
of what we are attaching, not the first one.

Fun with reordering ;-/  The missing delta, rediffed to the tip of Linus'
tree follows and definitely needs to be applied; will test if that's all
there is as soon as the kernel build finishes...

Sigh... Why does that stuff show up after 10 days in linux-next, about
5 minutes after seeing it merged into mainline?  Murphy's fun...

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 911d846..fe47133 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1680,43 +1680,45 @@ static __init int sysctl_init(void)
 
 core_initcall(sysctl_init);
 
-static int is_branch_in(struct ctl_table *branch, struct ctl_table *table)
+static struct ctl_table *is_branch_in(struct ctl_table *branch,
+				      struct ctl_table *table)
 {
 	struct ctl_table *p;
 	const char *s = branch->procname;
 
 	/* branch should have named subdirectory as its first element */
 	if (!s || !branch->child)
-		return 0;
+		return NULL;
 
 	/* ... and nothing else */
 	if (branch[1].procname || branch[1].ctl_name)
-		return 0;
+		return NULL;
 
 	/* table should contain subdirectory with the same name */
 	for (p = table; p->procname || p->ctl_name; p++) {
 		if (!p->child)
 			continue;
 		if (p->procname && strcmp(p->procname, s) == 0)
-			return 1;
+			return p;
 	}
-	return 0;
+	return NULL;
 }
 
 /* see if attaching q to p would be an improvement */
 static void try_attach(struct ctl_table_header *p, struct ctl_table_header *q)
 {
 	struct ctl_table *to = p->ctl_table, *by = q->ctl_table;
+	struct ctl_table *next;
 	int is_better = 0;
 	int not_in_parent = !p->attached_by;
 
-	while (is_branch_in(by, to)) {
+	while ((next = is_branch_in(by, to)) != NULL) {
 		if (by == q->attached_by)
 			is_better = 1;
 		if (to == p->attached_by)
 			not_in_parent = 1;
 		by = by->child;
-		to = to->child;
+		to = next->child;
 	}
 
 	if (is_better && not_in_parent) {
