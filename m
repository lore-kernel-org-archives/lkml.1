Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbZERQKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbZERQKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbZERQJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:09:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:41551 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047AbZERQJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:37 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 27/32] union-mount: Always create topmost directory on open
Date: Mon, 18 May 2009 18:09:23 +0200
Message-Id: <1242662968-11684-28-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora (Henson) <vaurora@redhat.com>

When we open a directory, unconditionally create a matching directory
on the top-level.  This way we don't have to go back and create all
the directories on the path to an element when we want to copy it up.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/namei.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 4d68597..684619c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1265,8 +1265,9 @@ static int __link_path_walk(const char *name, struct nameidata *nd)
 		if (err)
 			break;
 
-		if ((nd->flags & LOOKUP_TOPMOST) &&
-		    (nd->um_flags & LAST_LOWLEVEL)) {
+		if ((nd->um_flags & LAST_LOWLEVEL) &&
+		    (S_ISDIR(next.dentry->d_inode->i_mode) ||
+		     (nd->flags & LOOKUP_TOPMOST))) {
 			struct dentry *dentry;
 
 			dentry = union_create_topmost(nd, &this, &next);
@@ -1330,8 +1331,9 @@ last_component:
 		if (err)
 			break;
 
-		if ((nd->flags & LOOKUP_TOPMOST) &&
-		    (nd->um_flags & LAST_LOWLEVEL)) {
+		if ((nd->um_flags & LAST_LOWLEVEL) &&
+		    (S_ISDIR(next.dentry->d_inode->i_mode) ||
+		     (nd->flags & LOOKUP_TOPMOST))) {
 			struct dentry *dentry;
 
 			dentry = union_create_topmost(nd, &this, &next);
-- 
1.6.1.3

