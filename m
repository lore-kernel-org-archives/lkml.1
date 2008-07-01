Return-Path: <linux-kernel-owner+w=401wt.eu-S1758810AbYGAJ3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbYGAJ3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758278AbYGAJ25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:28:57 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:58646
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758163AbYGAJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:28:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADSWaUjLO9AP/2dsb2JhbACyBw
X-IronPort-AV: E=Sophos;i="4.27,730,1204470000"; 
   d="scan'208";a="242140556"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 2/5] autofs4 - dont make expiring dentry negative fix
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 01 Jul 2008 17:25:58 +0800
Message-ID: <20080701092557.12041.32586.stgit@raven.themaw.net>
In-Reply-To: <20080701092548.12041.69868.stgit@raven.themaw.net>
References: <20080701092548.12041.69868.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The correction to not make a dentry negative has an error.
Currently ->lookup() checks if an expire is in progress and removes
the entry from the list, before the expire is complete so if more
than one process is performing a lookup at this time only one will
wait for expire completion. We need to not remove the list entry
until after waiting for expire completion.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/root.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)


diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 10add99..2a1a631 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -591,7 +591,6 @@ static struct dentry *autofs4_lookup_expiring(struct autofs_sb_info *sbi, struct
 			goto next;
 
 		if (d_unhashed(dentry)) {
-			list_del_init(&ino->expiring);
 			dget(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&sbi->lookup_lock);
@@ -643,6 +642,10 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 			autofs4_wait(sbi, expiring, NFY_NONE);
 			DPRINTK("request completed");
 		}
+		spin_lock(&sbi->lookup_lock);
+		if (!list_empty(&ino->expiring))
+			list_del_init(&ino->expiring);
+		spin_unlock(&sbi->lookup_lock);
 		dput(expiring);
 	}
 
