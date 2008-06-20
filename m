Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038AbYFTFNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbYFTFNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 01:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbYFTFNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 01:13:44 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:25157
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbYFTFNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 01:13:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAITZWkh8qbBs/2dsb2JhbACvdA
X-IronPort-AV: E=Sophos;i="4.27,677,1204470000"; 
   d="scan'208";a="279415609"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH] autofs4 - detect invalid direct mount requests
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Fri, 20 Jun 2008 13:13:03 +0800
Message-ID: <20080620051301.9988.94307.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

autofs v5 dierct and offset mounts within an autofs filesystem are
triggered by existing autofs triger mounts so the mount point dentry
must be positive. If the mount point dentry is negative then the
trigger doesn't exist so we can return fail immediately.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/waitq.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index cd21fd4..ae637d9 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -307,6 +307,10 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 	if (sbi->catatonic)
 		return -ENOENT;
 
+	if (!dentry->d_inode &&
+	    (sbi->type & (AUTOFS_TYPE_DIRECT | AUTOFS_TYPE_OFFSET)))
+		return -ENOENT;
+
 	name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
 	if (!name)
 		return -ENOMEM;
