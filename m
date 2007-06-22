Return-Path: <linux-kernel-owner+w=401wt.eu-S1759682AbXFVRNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682AbXFVRNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbXFVRN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:13:26 -0400
Received: from web50106.mail.re2.yahoo.com ([206.190.38.34]:45746 "HELO
	web50106.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754571AbXFVRNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:13:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=qhrmWcc/u2Ng/R3kZVsnrhwD95vEivx4rEGqvb3vg7JQq1NhE9xo7l3oBSjYMSZt2BkymENR0/UhHxsZ6v8bndbPjPDzL7W1voeUj03TOAV3zN7hiCLNHCdikJmC/+XEJ/9qCaT7HWkHk56P1zVz737ZOvYQgm93oHZJfSf+558=;
X-YMail-OSG: alG5lXAVM1nJDW2._Nf8xpUlc0a2rASvjchrwHJbvFi60M.yseEX4EI3_Bnk1wzSlDu1sDSGiEsysy4U4f.0eUJLYpCukURwWIUJoLNBJrhQq0aZzQlxPLi7_BFgO1NyWonfdGVl8zs-
Date: Fri, 22 Jun 2007 10:13:24 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Reply-To: dougthompson@xmission.com
Subject: [PATCH 1/1] fs-sysfs bugfix of sysfs_hash_and_remove dereferencing before checking for NULL
To: Greg K-H <greg@kroah.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <887490.81074.qm@web50106.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

In tracking down one of my bugs in using sysfs, I found the kernel doing a NULL de-reference
in function fs/sysfs/inode.c:sysfs_hash_and_remove(), when I (incorrectly) passed
in a dentry value of NULL.

The check for NULL should occur BEFORE the dereference of 'dir'. 
This patch modifies the sequence and does the check FIRST


Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
---

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
@@ -295,6 +295,8 @@ int sysfs_hash_and_remove(struct dentry 
 		/* no inode means this hasn't been made visible yet */
 		return -ENOENT;
 
+	parent_sd = dir->d_fsdata;
+
 	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
 	for (pos = &parent_sd->s_children; *pos; pos = &(*pos)->s_sibling) {
 		sd = *pos;
