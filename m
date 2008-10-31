Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbYJaOIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbYJaOIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 10:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYJaOIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 10:08:40 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41971 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYJaOIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 10:08:38 -0400
Date: Fri, 31 Oct 2008 09:03:21 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Andrew G. Morgan" <morgan@kernel.org>, dhowells@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org
Subject: [PATCH 1/1] file caps: always start with clear bprm->caps_*
Message-ID: <20081031140321.GA11996@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry, resending as I seemed to have dropped lkml from the headers on
yesterday's post)

>From c7b9b5534182566b4526e6a5bd4641bd0ae99676 Mon Sep 17 00:00:00 2001
From: Serge Hallyn <serue@us.ibm.com>
Date: Thu, 30 Oct 2008 11:52:23 -0500
Subject: [PATCH 1/1] file caps: always start with clear bprm->caps_*

While Linux doesn't honor setuid on scripts.  However, it mistakenly
behaves differently for file capabilities.

This patch fixes that behavior by making sure that get_file_caps()
begins with empty bprm->caps_*.  That way when a script is loaded,
its bprm->caps_* may be filled when binfmt_misc calls prepare_binprm(),
but they will be cleared again when binfmt_elf calls prepare_binprm()
next to read the interpreter's file capabilities.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
---
 security/commoncap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 399bfdb..3976613 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -279,10 +279,10 @@ static int get_file_caps(struct linux_binprm *bprm)
 	struct vfs_cap_data vcaps;
 	struct inode *inode;
 
-	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
-		bprm_clear_caps(bprm);
+	bprm_clear_caps(bprm);
+
+	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
 		return 0;
-	}
 
 	dentry = dget(bprm->file->f_dentry);
 	inode = dentry->d_inode;
-- 
1.5.6.3

