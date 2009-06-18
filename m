Return-Path: <linux-kernel-owner+w=401wt.eu-S1763942AbZFRMwC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763942AbZFRMwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:52:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763411AbZFRMuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:50:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:38249 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763452AbZFRMuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:50:52 -0400
Date: Thu, 18 Jun 2009 12:50:13 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       davidel@xmailserver.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       viro@zeniv.linux.org.uk, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       viro@zeniv.linux.org.uk, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] fs: Provide empty .set_page_dirty() aop for anon inodes
Message-ID: <tip-d3a9262e59f7fb83c6d44df3b2b1460ed57d3ea1@git.kernel.org>
Git-Commit-ID: d3a9262e59f7fb83c6d44df3b2b1460ed57d3ea1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 12:50:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3a9262e59f7fb83c6d44df3b2b1460ed57d3ea1
Gitweb:     http://git.kernel.org/tip/d3a9262e59f7fb83c6d44df3b2b1460ed57d3ea1
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 18 Jun 2009 12:54:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Jun 2009 14:46:10 +0200

fs: Provide empty .set_page_dirty() aop for anon inodes

.set_page_dirty() is one of those a_ops that defaults to the
buffer implementation when not set. Therefore provide a dummy
function to make it do nothing.

(Uncovered by perfcounters fd's which can now be writable-mmap-ed.)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 fs/anon_inodes.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 1dd96d4..47d4a01 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -52,6 +52,19 @@ static const struct dentry_operations anon_inodefs_dentry_operations = {
 	.d_delete	= anon_inodefs_delete_dentry,
 };
 
+/*
+ * nop .set_page_dirty method so that people can use .page_mkwrite on
+ * anon inodes.
+ */
+static int anon_set_page_dirty(struct page *page)
+{
+	return 0;
+};
+
+static const struct address_space_operations anon_aops = {
+	.set_page_dirty = anon_set_page_dirty,
+};
+
 /**
  * anon_inode_getfd - creates a new file instance by hooking it up to an
  *                    anonymous inode, and a dentry that describe the "class"
@@ -151,6 +164,8 @@ static struct inode *anon_inode_mkinode(void)
 
 	inode->i_fop = &anon_inode_fops;
 
+	inode->i_mapping->a_ops = &anon_aops;
+
 	/*
 	 * Mark the inode dirty from the very beginning,
 	 * that way it will never be moved to the dirty
