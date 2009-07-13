Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZGML7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZGML7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 07:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbZGML7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 07:59:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37010 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbZGML7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 07:59:22 -0400
Date: Mon, 13 Jul 2009 13:59:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alexey Vlasov <renton@renton.name>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: [PATCH] Report file size for deleted files; was Re: Counters in
	df, du
Message-ID: <20090713115917.GA27684@basil.fritz.box>
References: <20090713081106.GA5569@beaver.vrungel.ru> <87fxd19cfq.fsf@basil.nowhere.org> <20090713113252.GB5569@beaver.vrungel.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090713113252.GB5569@beaver.vrungel.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But you can see the file date, these are new files and by next search

I appended a patch that reports the size.

-Andi

---

VFS: Report file size for deleted files in /proc

It's useful to know how big deleted files are, in case a file system
is filled up unexpectedly and the admin wants to track down which
process is the culprit. This patch reports the file size 
in addition to (deleted) for /proc/*/fd links.

This modifies a public interface, but it's reasonable to assume
that noone relies on the particular format here.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/dcache.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

Index: linux-2.6.31-rc1-ak/fs/dcache.c
===================================================================
--- linux-2.6.31-rc1-ak.orig/fs/dcache.c
+++ linux-2.6.31-rc1-ak/fs/dcache.c
@@ -1910,9 +1910,19 @@ char *__d_path(const struct path *path,
 
 	spin_lock(&vfsmount_lock);
 	prepend(&end, &buflen, "\0", 1);
-	if (d_unlinked(dentry) &&
-		(prepend(&end, &buflen, " (deleted)", 10) != 0))
+	if (d_unlinked(dentry)) {
+		char buf[40];
+		int n;
+		if (dentry->d_inode) { /* check needed? */
+			n = snprintf(buf, sizeof buf, " (deleted; size %lluK)",
+					dentry->d_inode->i_size >> 10);
+		} else {
+			strcpy(buf, " (deleted)");
+			n = 10;
+		}
+		if (prepend(&end, &buflen, buf, n) != 0)
 			goto Elong;
+	}
 
 	if (buflen < 1)
 		goto Elong;

-- 
ak@linux.intel.com -- Speaking for myself only.
