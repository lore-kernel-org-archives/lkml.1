Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbXDKPFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbXDKPFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbXDKPFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:05:40 -0400
Received: from ns.suse.de ([195.135.220.2]:51398 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbXDKPFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:05:40 -0400
Message-ID: <461CF939.9030104@suse.com>
Date: Wed, 11 Apr 2007 11:05:29 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH] autofs4: fix race in unhashed dentry code
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Commit f50b6f8691cae2e0064c499dd3ef3f31142987f0 introduced a
 race in autofs4 between autofs_lookup_unhashed() and
 autofs_dentry_release().

 autofs_dentry_release() ends up clearing the ->dentry and ->inode
 members of autofs_info before removing it from the rehash list. The
 list is protected by the rehash lock in both functions, but
 since autofs_dentry_release() starts tearing the autofs_info struct
 down before removing it from the list, autofs_lookup_unhashed() can
 get a autofs_info with a NULL dentry.

 This patch moves the clearing of ->dentry and ->inode after the removal
 from the rehash list.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

---

 fs/autofs4/root.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/autofs4/root.c	2007-04-11 09:41:44.000000000 -0400
+++ b/fs/autofs4/root.c	2007-04-11 10:54:37.000000000 -0400
@@ -470,9 +470,6 @@ void autofs4_dentry_release(struct dentr
 	if (inf) {
 		struct autofs_sb_info *sbi = autofs4_sbi(de->d_sb);
 
-		inf->dentry = NULL;
-		inf->inode = NULL;
-
 		if (sbi) {
 			spin_lock(&sbi->rehash_lock);
 			if (!list_empty(&inf->rehash))
@@ -480,6 +477,9 @@ void autofs4_dentry_release(struct dentr
 			spin_unlock(&sbi->rehash_lock);
 		}
 
+		inf->dentry = NULL;
+		inf->inode = NULL;
+
 		autofs4_free_ino(inf);
 	}
 }

-- 
Jeff Mahoney
SUSE Labs
