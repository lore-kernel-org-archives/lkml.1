Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0BSTrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:47:53 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:38652 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab0BSTrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:47:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Hm3CmQQ87100KPJlRRdG3GM/6dfxGJ8TGkd+INdVMNrRoAZoyCSzhj2AFDZCmfa4QL
         RBjUXKEZRq5yDELGP0oHK8b/6Y9mLd33a14whahoQh1GBwU1CRMF18Hrrx9ojk/Hh3Ir
         ReI/YQzHNVhroLNcVatK+QcAl1U3HLGP1NEDw=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/7] vfs: do not allow inode_setattr() to fail after vfs_dq_transfer()
Date: Fri, 19 Feb 2010 22:47:21 +0300
Message-Id: <1266608845-13212-4-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266608845-13212-3-git-send-email-dmonakhov@openvz.org>
References: <1266608845-13212-1-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-2-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After quota was transfered, inode_setattr() may fail. This
is tricky situation because it may be impossible to
roll-back quota changes. But we have already done all
necessery changes in inode_change_ok() so it is safe to
use nofail version of inode_seattr() here.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/attr.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index cc2a801..c1ae61c 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -243,7 +243,11 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 				error = vfs_dq_transfer(inode, attr) ?
 					-EDQUOT : 0;
 			if (!error)
-				error = inode_setattr(inode, attr);
+				/*
+				 * All necessery check already done, it is
+				 * safe to use nofail version here.
+				 */
+				__inode_setattr(inode, attr);
 		}
 	}
 
-- 
1.6.6

