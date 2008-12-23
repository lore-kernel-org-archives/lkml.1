Return-Path: <linux-kernel-owner+w=401wt.eu-S1751915AbYLWQOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbYLWQOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYLWQNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:13:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48925 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbYLWQNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:13:04 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] dlm: remove extra blocking callback check
Date: Tue, 23 Dec 2008 10:58:38 -0600
Message-Id: <1230051523-5478-6-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just before delivering a blocking callback (bast), the dlm_astd
thread checks again that the granted mode of the lkb actually
blocks the mode requested by the bast.  The idea behind this was
originally that the granted mode may have changed since the bast
was queued, making the callback now unnecessary.  Reasons for
removing this extra check are:
- dlm_astd doesn't lock the rsb before reading the lkb grmode, so
  it's not technically safe (this removes the long standing FIXME)
- after running some tests, it doesn't appear the check ever actually
  eliminates a bast
- delivering an unnecessary blocking callback isn't a bad thing and
  can happen anyway

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/ast.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 30c11f3..09b167d 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -89,13 +89,8 @@ static void process_asts(void)
 		if ((type & AST_COMP) && cast)
 			cast(lkb->lkb_astparam);
 
-		/* FIXME: Is it safe to look at lkb_grmode here
-		   without doing a lock_rsb() ?
-		   Look at other checks in v1 to avoid basts. */
-
 		if ((type & AST_BAST) && bast)
-			if (!dlm_modes_compat(lkb->lkb_grmode, bmode))
-				bast(lkb->lkb_astparam, bmode);
+			bast(lkb->lkb_astparam, bmode);
 
 		/* this removes the reference added by dlm_add_ast
 		   and may result in the lkb being freed */
-- 
1.5.5.1

