Return-Path: <linux-kernel-owner+w=401wt.eu-S935241AbXJPTgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935241AbXJPTgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759007AbXJPTf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:35:59 -0400
Received: from mail.fieldses.org ([66.93.2.214]:55803 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758067AbXJPTf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:35:58 -0400
Date: Tue, 16 Oct 2007 15:35:57 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] dcache: don't expose uninitialized memory in
	/proc/<pid>/fd/<fd>
Message-ID: <20071016193557.GB8650@fieldses.org>
References: <20071016193230.GA8650@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016193230.GA8650@fieldses.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

Well, it's not especially important that target->d_iname get the
contents of dentry->d_iname, but it's important that it get initialized
with *something*, otherwise we're just exposing some random piece of
memory to anyone who reads the link at /proc/<pid>/fd/<fd> for the
deleted file, when it's still held open by someone.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 fs/dcache.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

(Am I missing something?  I've also run a test program that copies a
short (<36 character) name ontop of a long (>=36 character) name and see
that the first time I run it, without this patch, I get unpredicatable
results out of /proc/<pid>/fd/<fd>.)

diff --git a/fs/dcache.c b/fs/dcache.c
index 5663a31..24252fc 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1483,6 +1483,8 @@ static void switch_names(struct dentry *dentry, struct dentry *target)
 			 * dentry:internal, target:external.  Steal target's
 			 * storage and make target internal.
 			 */
+			memcpy(target->d_iname, dentry->d_name.name,
+					dentry->d_name.len + 1);
 			dentry->d_name.name = target->d_name.name;
 			target->d_name.name = target->d_iname;
 		}
-- 
1.5.3.4.208.gc990

