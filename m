Return-Path: <linux-kernel-owner+w=401wt.eu-S933803AbZDATU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803AbZDATU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759525AbZDATUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:20:44 -0400
Received: from relay3.sgi.com ([192.48.156.57]:58917 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759264AbZDATUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:20:43 -0400
Date: Wed, 1 Apr 2009 14:20:41 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: [Patch 1/1] xpc_sn2: fix max() warning about pointers of different
	types.
Message-ID: <20090401192041.GI8925@sgi.com>
References: <20090401190556.GH8925@sgi.com> <20090401191536.GC29673@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090401191536.GC29673@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a minor compile warning when building on ia64.

drivers/misc/sgi-xp/xpc_sn2.c: In function ‘xpc_clear_remote_msgqueue_flags_sn2’:
drivers/misc/sgi-xp/xpc_sn2.c:1746: warning: comparison of distinct pointer types lacks a cast


Signed-off-by: Robin Holt <holt@sgi.com>

---

 drivers/misc/sgi-xp/xpc_sn2.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)
Index: 20090401-ia64-xpc-no-gru/drivers/misc/sgi-xp/xpc_sn2.c
===================================================================
--- 20090401-ia64-xpc-no-gru.orig/drivers/misc/sgi-xp/xpc_sn2.c	2009-04-01 10:50:19.000000000 -0500
+++ 20090401-ia64-xpc-no-gru/drivers/misc/sgi-xp/xpc_sn2.c	2009-04-01 11:27:42.005011690 -0500
@@ -1737,20 +1737,20 @@ xpc_clear_remote_msgqueue_flags_sn2(stru
 {
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
 	struct xpc_msg_sn2 *msg;
-	s64 put;
+	s64 put, remote_nentries = ch->remote_nentries;
 
 	/* flags are zeroed when the buffer is allocated */
-	if (ch_sn2->remote_GP.put < ch->remote_nentries)
+	if (ch_sn2->remote_GP.put < remote_nentries)
 		return;
 
-	put = max(ch_sn2->w_remote_GP.put, ch->remote_nentries);
+	put = max(ch_sn2->w_remote_GP.put, remote_nentries);
 	do {
 		msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->remote_msgqueue +
-					     (put % ch->remote_nentries) *
+					     (put % remote_nentries) *
 					     ch->entry_size);
 		DBUG_ON(!(msg->flags & XPC_M_SN2_READY));
 		DBUG_ON(!(msg->flags & XPC_M_SN2_DONE));
-		DBUG_ON(msg->number != put - ch->remote_nentries);
+		DBUG_ON(msg->number != put - remote_nentries);
 		msg->flags = 0;
 	} while (++put < ch_sn2->remote_GP.put);
 }
