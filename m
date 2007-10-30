Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbXJ3WnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbXJ3WnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbXJ3WnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:43:14 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:61457 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753686AbXJ3WnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:43:13 -0400
Message-Id: <20071030224004.417523706@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 30 Oct 2007 15:40:04 -0700
Message-Id: <20071030223635.719787685@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 30 Oct 2007 15:36:35 -0700
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
CC: linux-kernel@vger.kernel.org
CC: linux-rt-users@vger.kernel.org
CC: rostedt@goodmis.org
CC: kraj@mvista.com
Subject: [PATCH -rt] remove in_interrupt() BUG_ON in exit path
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As you can see from the patch there is already a case to catch this type
of problem. This BUG_ON() adds a resursive OOPS , since BUG() causes an OOPS 
and the OOPS just calls do_exit() , and do_exit() just causes another OOPS with
this BUG_ON().. If we call panic() here then it's clear what the problem was,
instead of causing an endless recursive crash.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 kernel/exit.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.23.1/kernel/exit.c
===================================================================
--- linux-2.6.23.1.orig/kernel/exit.c
+++ linux-2.6.23.1/kernel/exit.c
@@ -895,7 +895,6 @@ fastcall NORET_TYPE void do_exit(long co
 
 	WARN_ON(atomic_read(&tsk->fs_excl));
 
-	BUG_ON(in_interrupt());
 	if (unlikely(in_interrupt()))
 		panic("Aiee, killing interrupt handler!");
 	if (unlikely(!tsk->pid))
-- 

-- 
