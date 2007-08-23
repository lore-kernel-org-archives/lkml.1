Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbXHWEcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbXHWEcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 00:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbXHWEb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 00:31:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38554
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbXHWEbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 00:31:55 -0400
Date: Wed, 22 Aug 2007 21:31:53 -0700 (PDT)
Message-Id: <20070822.213153.94751711.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH]: Fix futex compat bug.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The futex list traversal on the compat side appears to have
a bug.

It's loop termination condition compares:

	while (compat_ptr(uentry) != &head->list)

But that can't be right because "uentry" has the special
"pi" indicator bit still potentially set at bit 0.  This
is cleared by fetch_robust_entry() into the "entry"
return value.

What this seems to mean is that the list won't terminate
when list iteration gets back to the the head.  And we'll
also process the list head like a normal entry, which could
cause all kinds of problems.

So we should check for equality with "entry".  That pointer
is of the non-compat type so we have to do a little casting
to keep the compiler and sparse happy.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index f792136..92af955 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -64,7 +64,7 @@ void compat_exit_robust_list(struct task_struct *curr)
 	if (upending)
 		handle_futex_death((void __user *)pending + futex_offset, curr, pip);
 
-	while (compat_ptr(uentry) != &head->list) {
+	while (entry != (struct robust_list *) &head->list) {
 		/*
 		 * A pending lock might already be on the list, so
 		 * dont process it twice:
