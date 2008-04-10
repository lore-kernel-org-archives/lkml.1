Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbYDJTwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbYDJTwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYDJTwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:52:10 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57984 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYDJTwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:52:09 -0400
To: neilb@suse.de, Trond.Myklebust@netapp.com
CC: akpm@linux-foundation.org, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: nfs: infinite loop in fcntl(F_SETLKW)
References: <E1JjcgO-0004q2-VJ@pomaz-ex.szeredi.hu>
Message-Id: <E1Jk2oI-0007UX-MS@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 10 Apr 2008 21:51:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another infinite loop, this one involving both client and server.

Basically what happens is that on the server nlm_fopen() calls
nfsd_open() which returns -EACCES, to which nlm_fopen() returns
NLM_LCK_DENIED.

On the client this will turn into a -EAGAIN (nlm_stat_to_errno()),
which in will cause fcntl_setlk() to retry forever.

I _think_ the solution is to turn NLM_LCK_DENIED into ENOLCK for
blocking locks, as NLM_LCK_BLOCKED is for the contended case.  For
testing the lock leave NLM_LCK_DENIED as EAGAIN.  That still could be
misleading, but at least there's no infinite loop in that case.

I've minimally tested this patch to verify that it cures the lockup,
and that simple blocking locks keep working.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/lockd/clntproc.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/fs/lockd/clntproc.c
===================================================================
--- linux.orig/fs/lockd/clntproc.c	2008-04-02 13:34:57.000000000 +0200
+++ linux/fs/lockd/clntproc.c	2008-04-10 21:23:46.000000000 +0200
@@ -536,6 +536,9 @@ again:
 		up_read(&host->h_rwsem);
 	}
 	status = nlm_stat_to_errno(resp->status);
+	/* Don't return EAGAIN, as that would make fcntl_setlk() loop */
+	if (status == -EAGAIN)
+		status = -ENOLCK;
 out_unblock:
 	nlmclnt_finish_block(block);
 	/* Cancel the blocked request if it is still pending */

