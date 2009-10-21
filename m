Return-Path: <linux-kernel-owner+w=401wt.eu-S932402AbZJUTYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbZJUTYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbZJUTYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:24:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156AbZJUTVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:21:23 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>
Subject: [PATCH 29/41] union-mount: Always create topmost directory on open
Date: Wed, 21 Oct 2009 12:19:27 -0700
Message-Id: <1256152779-10054-30-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-29-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
 <1256152779-10054-9-git-send-email-vaurora@redhat.com>
 <1256152779-10054-10-git-send-email-vaurora@redhat.com>
 <1256152779-10054-11-git-send-email-vaurora@redhat.com>
 <1256152779-10054-12-git-send-email-vaurora@redhat.com>
 <1256152779-10054-13-git-send-email-vaurora@redhat.com>
 <1256152779-10054-14-git-send-email-vaurora@redhat.com>
 <1256152779-10054-15-git-send-email-vaurora@redhat.com>
 <1256152779-10054-16-git-send-email-vaurora@redhat.com>
 <1256152779-10054-17-git-send-email-vaurora@redhat.com>
 <1256152779-10054-18-git-send-email-vaurora@redhat.com>
 <1256152779-10054-19-git-send-email-vaurora@redhat.com>
 <1256152779-10054-20-git-send-email-vaurora@redhat.com>
 <1256152779-10054-21-git-send-email-vaurora@redhat.com>
 <1256152779-10054-22-git-send-email-vaurora@redhat.com>
 <1256152779-10054-23-git-send-email-vaurora@redhat.com>
 <1256152779-10054-24-git-send-email-vaurora@redhat.com>
 <1256152779-10054-25-git-send-email-vaurora@redhat.com>
 <1256152779-10054-26-git-send-email-vaurora@redhat.com>
 <1256152779-10054-27-git-send-email-vaurora@redhat.com>
 <1256152779-10054-28-git-send-email-vaurora@redhat.com>
 <1256152779-10054-29-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we open a directory, always create a matching directory on the
top-level.  This way we don't have to go back and create all the
directories on the path to an element when we want to copy it up.

XXX - Turn into #ifdef'able function

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   34 ++++++++++++++++++++++++++++++----
 1 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 1f2a214..8d95eb1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1284,8 +1284,31 @@ static int __link_path_walk(const char *name, struct nameidata *nd)
 		if (err)
 			break;
 
-		if ((nd->flags & LOOKUP_TOPMOST) &&
-		    (nd->um_flags & LAST_LOWLEVEL)) {
+		/*
+		 * We want to create this element on the top level
+		 * file system in two cases:
+		 *
+		 * - We are specifically told to - LOOKUP_TOPMOST.
+		 * - This is a directory, and it does not yet exist on
+		 *   the top level.  Various tricks only work if
+		 *   directories always exist on the top level.
+		 *
+		 * In either case, only create this element on the top
+		 * level if the last element is located on the lower
+		 * level.  If the last element is located on the top
+		 * level, then every single element in the path
+		 * already exists on the top level.
+		 *
+		 * Note that we can assume that the parent is on the
+		 * top level since we always create the directory on
+		 * the top level.
+		 */
+
+		if ((nd->um_flags & LAST_LOWLEVEL) &&
+		    ((next.dentry->d_inode &&
+		      S_ISDIR(next.dentry->d_inode->i_mode) &&
+		      (nd->path.mnt != next.mnt)) ||
+		     (nd->flags & LOOKUP_TOPMOST))) {
 			struct dentry *dentry;
 
 			dentry = union_create_topmost(nd, &this, &next);
@@ -1349,8 +1372,11 @@ last_component:
 		if (err)
 			break;
 
-		if ((nd->flags & LOOKUP_TOPMOST) &&
-		    (nd->um_flags & LAST_LOWLEVEL)) {
+		if ((nd->um_flags & LAST_LOWLEVEL) &&
+		    ((next.dentry->d_inode &&
+		      S_ISDIR(next.dentry->d_inode->i_mode) &&
+		      (nd->path.mnt != next.mnt)) ||
+		     (nd->flags & LOOKUP_TOPMOST))) {
 			struct dentry *dentry;
 
 			dentry = union_create_topmost(nd, &this, &next);
-- 
1.6.3.3

