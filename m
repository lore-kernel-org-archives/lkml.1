Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbXIJTVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbXIJTVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760288AbXIJTVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:21:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:62983 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760164AbXIJTVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:21:36 -0400
Message-Id: <20070910191648.561256021@arndb.de>
References: <20070910191324.847651727@arndb.de>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 21:13:25 +0200
From: arnd@arndb.de
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: [patch 1/3] futex_compat: fix list traversal bugs
Content-Disposition: inline; filename=futex_compat.diff
X-Provags-ID: V01U2FsdGVkX18SsiJEyPYL0vyOkyoRuEsNZ1E8nEzzbVqvaD/
 syVzBsmqtEkiuCN19Dc21R9posmkRgjwMi31b6auVY4PMWFCoM
 YsY0I0+mDvWYhi2yjclLA==
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

The same problem can in theory occur with the 'pending'
variable, although that has not been reported from users
so far.

Based on the original patch from David Miller.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/kernel/futex_compat.c
===================================================================
--- linux-2.6.orig/kernel/futex_compat.c
+++ linux-2.6/kernel/futex_compat.c
@@ -61,10 +61,10 @@ void compat_exit_robust_list(struct task
 	if (fetch_robust_entry(&upending, &pending,
 			       &head->list_op_pending, &pip))
 		return;
-	if (upending)
+	if (pending)
 		handle_futex_death((void __user *)pending + futex_offset, curr, pip);
 
-	while (compat_ptr(uentry) != &head->list) {
+	while (entry != (struct robust_list __user *) &head->list) {
 		/*
 		 * A pending lock might already be on the list, so
 		 * dont process it twice:

-- 

