Return-Path: <linux-kernel-owner+w=401wt.eu-S932629AbXBEOGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbXBEOGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932614AbXBEOGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:06:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629AbXBEOGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:06:47 -0500
Subject: [DLM] fix lost flags in stub replies
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:14:51 +0000
Message-Id: <1170684891.11001.284.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From b08c5ad55e470d1cb05d1dc3e7159996903cc701 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Wed, 13 Dec 2006 10:40:26 -0600
Subject: [PATCH] [DLM] fix lost flags in stub replies

When the dlm fakes an unlock/cancel reply from a failed node using a stub
message struct, it wasn't setting the flags in the stub message.  So, in
the process of receiving the fake message the lkb flags would be updated
and cleared from the zero flags in the message.  The problem observed in
tests was the loss of the USER flag which caused the dlm to think a user
lock was a kernel lock and subsequently fail an assertion checking the
validity of the ast/callback field.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index d8e919b..ed52485 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -3148,6 +3148,7 @@ static void recover_convert_waiter(struct dlm_ls *ls, struct dlm_lkb *lkb)
 	if (middle_conversion(lkb)) {
 		hold_lkb(lkb);
 		ls->ls_stub_ms.m_result = -EINPROGRESS;
+		ls->ls_stub_ms.m_flags = lkb->lkb_flags;
 		_remove_from_waiters(lkb);
 		_receive_convert_reply(lkb, &ls->ls_stub_ms);
 
@@ -3221,6 +3222,7 @@ void dlm_recover_waiters_pre(struct dlm_ls *ls)
 		case DLM_MSG_UNLOCK:
 			hold_lkb(lkb);
 			ls->ls_stub_ms.m_result = -DLM_EUNLOCK;
+			ls->ls_stub_ms.m_flags = lkb->lkb_flags;
 			_remove_from_waiters(lkb);
 			_receive_unlock_reply(lkb, &ls->ls_stub_ms);
 			dlm_put_lkb(lkb);
@@ -3229,6 +3231,7 @@ void dlm_recover_waiters_pre(struct dlm_ls *ls)
 		case DLM_MSG_CANCEL:
 			hold_lkb(lkb);
 			ls->ls_stub_ms.m_result = -DLM_ECANCEL;
+			ls->ls_stub_ms.m_flags = lkb->lkb_flags;
 			_remove_from_waiters(lkb);
 			_receive_cancel_reply(lkb, &ls->ls_stub_ms);
 			dlm_put_lkb(lkb);
-- 
1.4.4.2



