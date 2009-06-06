Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZFFUwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZFFUwM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 16:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbZFFUv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 16:51:59 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:21835 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbZFFUv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 16:51:59 -0400
X-Trace: 210621965/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.119.212/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.119.212
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYIAM9zKkpPRXfU/2dsb2JhbACBT4xpAb5tgjGBWQU
X-IronPort-AV: E=Sophos;i="4.41,316,1241391600"; 
   d="scan'208";a="210621965"
Date: Sat, 6 Jun 2009 21:18:09 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Mimi Zohar <zohar@us.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       James Morris <jmorris@namei.org>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] integrity: fix IMA inode leak
Message-ID: <Pine.LNX.4.64.0906062109580.8365@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_IMA=y inode activity leaks iint_cache and radix_tree_node objects
until the system runs out of memory.  Nowhere is calling ima_inode_free()
a.k.a. ima_iint_delete().  Fix that by calling it from destroy_inode().

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 fs/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- 2.6.30-rc8/fs/inode.c	2009-05-16 10:26:15.000000000 +0100
+++ linux/fs/inode.c	2009-06-06 17:41:21.000000000 +0100
@@ -219,6 +219,7 @@ static struct inode *alloc_inode(struct
 void destroy_inode(struct inode *inode)
 {
 	BUG_ON(inode_has_buffers(inode));
+	ima_inode_free(inode);
 	security_inode_free(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
