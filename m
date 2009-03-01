Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbZCAOOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbZCAOOu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 09:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbZCAOOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 09:14:40 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:47115 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbZCAOOk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 09:14:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=nsg7MkPJ8kEOmP+3gglPfhX+0qxuI1F5w6LY/2HbHxIkjglKyQwv5deMhkJdooHJe4
         N6Ph/BCfowvpiu6gMp+flQLwkk0fVmwc7FAgQYg1LAG+tGTp+1ocjaR2as3+oyIEqMYe
         jkWTQg1QIKXuykMIJRAN6ZFRILmjniidpdxjM=
Date: Sun, 1 Mar 2009 16:14:32 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Stuart Bennett <stuart@freedesktop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] x86 mmiotrace: fix race with release_kmmio_fault_page()
Message-ID: <20090301161432.127dcefc@daedalus.pq.iki.fi>
In-Reply-To: <20090301160643.05a2219b@daedalus.pq.iki.fi>
References: <20090301160643.05a2219b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c7bc3125d414938b3340a87516ecf47cd27efea4 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Tue, 24 Feb 2009 21:44:15 +0200
Subject: [PATCH] x86 mmiotrace: fix race with release_kmmio_fault_page()

There was a theoretical possibility to a race between arming a page in
post_kmmio_handler() and disarming the page in
release_kmmio_fault_page():

cpu0                             cpu1
------------------------------------------------------------------
mmiotrace shutdown
enter release_kmmio_fault_page
                                 fault on the page
                                 disarm the page
disarm the page
                                 handle the MMIO access
                                 re-arm the page
put the page on release list
remove_kmmio_fault_pages()
                                 fault on the page
                                 page not known to mmiotrace
                                 fall back to do_page_fault()
                                 *KABOOM*

(This scenario also shows the double disarm case which is allowed.)

Fixed by acquiring kmmio_lock in post_kmmio_handler() and checking
if the page is being released from mmiotrace.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/kmmio.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 4c66bd3..9f20503 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -38,7 +38,8 @@ struct kmmio_fault_page {
 	/*
 	 * Number of times this page has been registered as a part
 	 * of a probe. If zero, page is disarmed and this may be freed.
-	 * Used only by writers (RCU).
+	 * Used only by writers (RCU) and post_kmmio_handler().
+	 * Protected by kmmio_lock, when linked into kmmio_page_table.
 	 */
 	int count;
 };
@@ -317,7 +318,11 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 	if (ctx->probe && ctx->probe->post_handler)
 		ctx->probe->post_handler(ctx->probe, condition, regs);
 
-	arm_kmmio_fault_page(ctx->fpage);
+	/* Prevent racing against release_kmmio_fault_page(). */
+	spin_lock(&kmmio_lock);
+	if (ctx->fpage->count)
+		arm_kmmio_fault_page(ctx->fpage);
+	spin_unlock(&kmmio_lock);
 
 	regs->flags &= ~X86_EFLAGS_TF;
 	regs->flags |= ctx->saved_flags;
-- 
1.6.0.6

