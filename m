Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZFVTgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZFVTgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZFVTfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:35:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49235 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbZFVTfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:35:51 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       stable@kernel.org, David Howells <dhowells@redhat.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>
Subject: [PATCH] FLAT: fix uninitialized ptr with shared libs
Date: Mon, 22 Jun 2009 15:35:32 -0400
Message-Id: <1245699332-1872-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <alpine.LFD.2.01.0906221137580.3240@localhost.localdomain>
References: <alpine.LFD.2.01.0906221137580.3240@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernd Schmidt <bernds_cb1@t-online.de>

The new credentials code broke load_flat_shared_library() as it now uses
an uninitialized cred pointer.

Signed-off-by: Bernd Schmidt <bernds_cb1@t-online.de>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: David Howells <dhowells@redhat.com>
---
should be cleaned up to apply to the master branch

 fs/binfmt_flat.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 697f6b5..33283cd 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -824,14 +824,23 @@ static int load_flat_shared_library(int id, struct lib_info *libs)
 	/* Open the file up */
 	bprm.filename = buf;
 	bprm.file = open_exec(bprm.filename);
+	bprm.cred = NULL;
 	res = PTR_ERR(bprm.file);
 	if (IS_ERR(bprm.file))
 		return res;
 
+	bprm.cred = prepare_exec_creds();
+	if (!bprm.cred)
+		goto out;
+
 	res = prepare_binprm(&bprm);
 
 	if (res <= (unsigned long)-4096)
 		res = load_flat_file(&bprm, libs, id, NULL);
+ out:
+	if (bprm.cred)
+		abort_creds(bprm.cred);
+
 	if (bprm.file) {
 		allow_write_access(bprm.file);
 		fput(bprm.file);
-- 
1.6.3.1

