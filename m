Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab0BDQvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:51:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab0BDQvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:51:40 -0500
Date: Thu, 4 Feb 2010 17:51:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Arjan van de Ven <arjan@linux.intel.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: PATCH? process_32.c:__switch_to() calls __math_state_restore()
	before updating current_task
Message-ID: <20100204165105.GA5905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't try to verify __switch_to()->__math_state_restore() is really
wrong, this is more the question than the patch. But at least the code
looks wrong, it calls __math_state_restore() which uses curent before
current_task was updated.

Uncompiled/untested.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -377,9 +377,6 @@ __switch_to(struct task_struct *prev_p, 
 	 */
 	arch_end_context_switch(next_p);
 
-	if (preload_fpu)
-		__math_state_restore();
-
 	/*
 	 * Restore %gs if needed (which is common)
 	 */
@@ -388,6 +385,9 @@ __switch_to(struct task_struct *prev_p, 
 
 	percpu_write(current_task, next_p);
 
+	if (preload_fpu)
+		__math_state_restore();
+
 	return prev_p;
 }
 

