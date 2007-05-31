Return-Path: <linux-kernel-owner+w=401wt.eu-S1761539AbXEaS1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbXEaS1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759006AbXEaS1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:27:34 -0400
Received: from [198.99.130.12] ([198.99.130.12]:33939 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758812AbXEaS1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:27:33 -0400
Date: Thu, 31 May 2007 14:19:23 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] Syslets - Fix cachemiss_thread return value
Message-ID: <20070531181923.GA9904@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cachemiss_thread should explicitly return 0 or error instead of
task_ret_reg(current) (which is -ENOSYS anyway) because
async_thread_helper is careful to put the return value in eax anyway.

On x86_64, it looks like async_child_rip is similarly careful.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 kernel/async.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/async.c
===================================================================
--- linux-2.6.orig/kernel/async.c	2007-05-29 20:11:11.000000000 -0400
+++ linux-2.6/kernel/async.c	2007-05-31 14:12:49.000000000 -0400
@@ -575,7 +575,7 @@ static long cachemiss_thread(void *data)
 	struct task_struct *t = current;
 	struct async_head *ah = args->ah;
 	struct async_thread *at;
-	int ret;
+	int ret = 0;
 
 	at = &t->__at;
 	async_thread_init(t, at, ah);
@@ -607,7 +607,7 @@ static long cachemiss_thread(void *data)
 	complete(&ah->start_done);
 
 	async_cachemiss_loop(at, ah, t);
-	return task_ret_reg(t);
+	return ret;
 }
 
 /**
