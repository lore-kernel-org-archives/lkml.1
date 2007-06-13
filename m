Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbXFMN3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbXFMN3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbXFMN3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:29:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46749 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbXFMN3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:29:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] sysfs: Fix oops in sysfs_drop_dentry on x86_64
Date: Wed, 13 Jun 2007 15:36:18 +0200
User-Agent: KMail/1.9.5
Cc: Tejun Heo <htejun@gmail.com>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706131536.18882.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Fix oops on x86_64 caused by the dereference of dir in sysfs_drop_dentry() made
before checking if dir is not NULL
(cf. http://marc.info/?l=linux-kernel&m=118151626704924&w=2).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 fs/sysfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc4-mm2/fs/sysfs/inode.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/sysfs/inode.c
+++ linux-2.6.22-rc4-mm2/fs/sysfs/inode.c
@@ -285,7 +285,7 @@ void sysfs_drop_dentry(struct sysfs_dire
 int sysfs_hash_and_remove(struct dentry * dir, const char * name)
 {
 	struct sysfs_dirent **pos, *sd;
-	struct sysfs_dirent *parent_sd = dir->d_fsdata;
+	struct sysfs_dirent *parent_sd;
 	int found = 0;
 
 	if (!dir)
@@ -295,6 +295,7 @@ int sysfs_hash_and_remove(struct dentry 
 		/* no inode means this hasn't been made visible yet */
 		return -ENOENT;
 
+	parent_sd = dir->d_fsdata;
 	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
 	for (pos = &parent_sd->s_children; *pos; pos = &(*pos)->s_sibling) {
 		sd = *pos;
