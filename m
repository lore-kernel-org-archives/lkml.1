Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZJABBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZJABBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 21:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbZJABBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 21:01:42 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:9685
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755384AbZJABBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 21:01:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAGecw0rLO7dJ/2dsb2JhbADXZoQnBIFNVg
X-IronPort-AV: E=Sophos;i="4.44,483,1249228800"; 
   d="scan'208";a="585680293"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 06/10] autofs4 - cleanup active and expire lookup
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Sage Weil <sage@newdream.net>, Al Viro <viro@ZenIV.linux.org.uk>,
       Andreas Dilger <adilger@sun.com>, Christoph Hellwig <hch@infradead.org>,
       Yehuda Saheh <yehuda@newdream.net>
Date: Thu, 01 Oct 2009 09:01:35 +0800
Message-ID: <20091001010135.7675.98606.stgit@zeus.themaw.net>
In-Reply-To: <20091001010054.7675.77673.stgit@zeus.themaw.net>
References: <20091001010054.7675.77673.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lookup functions for active and expiring dentrys use parameters
that can be easily obtained on entry so we change the call to to
take just the dentry. This makes the subsequent change, to send all
lookups to ->lookup(), a bit cleaner.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/root.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 961ff37..81700f4 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -405,8 +405,11 @@ static const struct dentry_operations autofs4_dentry_operations = {
 	.d_release	= autofs4_dentry_release,
 };
 
-static struct dentry *autofs4_lookup_active(struct autofs_sb_info *sbi, struct dentry *parent, struct qstr *name)
+static struct dentry *autofs4_lookup_active(struct dentry *dentry)
 {
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct dentry *parent = dentry->d_parent;
+	struct qstr *name = &dentry->d_name;
 	unsigned int len = name->len;
 	unsigned int hash = name->hash;
 	const unsigned char *str = name->name;
@@ -457,8 +460,11 @@ next:
 	return NULL;
 }
 
-static struct dentry *autofs4_lookup_expiring(struct autofs_sb_info *sbi, struct dentry *parent, struct qstr *name)
+static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
 {
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct dentry *parent = dentry->d_parent;
+	struct qstr *name = &dentry->d_name;
 	unsigned int len = name->len;
 	unsigned int hash = name->hash;
 	const unsigned char *str = name->name;
@@ -530,7 +536,7 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
 		 current->pid, task_pgrp_nr(current), sbi->catatonic, oz_mode);
 
-	active = autofs4_lookup_active(sbi, dentry->d_parent, &dentry->d_name);
+	active = autofs4_lookup_active(dentry);
 	if (active) {
 		dentry = active;
 		ino = autofs4_dentry_ino(dentry);
@@ -567,9 +573,7 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 
 	if (!oz_mode) {
 		mutex_unlock(&dir->i_mutex);
-		expiring = autofs4_lookup_expiring(sbi,
-						   dentry->d_parent,
-						   &dentry->d_name);
+		expiring = autofs4_lookup_expiring(dentry);
 		if (expiring) {
 			/*
 			 * If we are racing with expire the request might not

