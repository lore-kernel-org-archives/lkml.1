Return-Path: <linux-kernel-owner+w=401wt.eu-S932146AbYETKCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbYETKCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbYETKAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:00:24 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:15798 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765634AbYETKAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:00:21 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Denis V. Lunev" <den@openvz.org>, David Miller <davem@davemloft.net>,
       Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/4] proc: proc_get_inode should get module only once
Date: Tue, 20 May 2008 13:59:46 +0400
Message-Id: <1211277589-8565-1-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any file under /proc/net opened more than once leaked the refcounter
on the module it belongs to.

The problem is that module_get is called for each file opening while
module_put is called only when /proc inode is destroyed. So, lets put
module counter if we are dealing with already initialised inode.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: David Miller <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Robert Olsson <robert.olsson@its.uu.se>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 6f4e8dc..b08d100 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -425,7 +425,8 @@ struct inode *proc_get_inode(struct super_block *sb, unsigned int ino,
 			}
 		}
 		unlock_new_inode(inode);
-	}
+	} else
+	       module_put(de->owner);
 	return inode;
 
 out_ino:
-- 
1.5.3.rc5

