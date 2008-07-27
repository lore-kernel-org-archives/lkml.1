Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYG0Fbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYG0Fbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 01:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYG0FbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 01:31:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38611 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbYG0FbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 01:31:23 -0400
Date: Sun, 27 Jul 2008 06:31:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Kara <jack@ucw.cz>
Subject: [PATCH] lost sysctl fix
Message-ID: <20080727053122.GZ28946@ZenIV.linux.org.uk>
References: <14615.1217125366@turing-police.cc.vt.edu> <20080726202525.3ac3052f.akpm@linux-foundation.org> <21657.1217130229@turing-police.cc.vt.edu> <20080727040908.GX28946@ZenIV.linux.org.uk> <20080727051702.GY28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727051702.GY28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try_attach() should walk into the matching subdirectory, not the first one...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
[and yes, that's what that crap had been]

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
