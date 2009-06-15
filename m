Return-Path: <linux-kernel-owner+w=401wt.eu-S1763620AbZFORhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763620AbZFORhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZFORhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:37:47 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:49133 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbZFORhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:37:46 -0400
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 13:37:46 EDT
Date: Mon, 15 Jun 2009 13:29:02 -0400 (EDT)
From: Andrew Michael Wesie <awesie@andrew.cmu.edu>
To: linux-kernel@vger.kernel.org
Subject: futex and shared memory
Message-ID: <Pine.LNX.4.64-044.0906151305370.4173@unix31.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-PMX-Version: 5.5.5.374460, Antispam-Engine: 2.7.1.369594, Antispam-Data: 2009.6.15.171634
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_1400_1499 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, __CP_NAME_BODY 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a set of LWPs with non-shared page tables (no CLONE_VM flag) and am 
also using the CLONE_CHILD_CLEARTID flag. The ctid variable points to a 
memory that has been mmap'd MAP_SHARED, so that it will be shared with 
both the parent and the child. When the child exits, the expected behavior 
is for the memory pointed to by ctid to be cleared. From what I could 
tell, this wasn't happening.

After looking at mm_release in fork.c, which is responsible for clearing 
the tid variable, it looks like this doesn't work since mm_release checks 
if there is more than one "user" of the memory space. I am including a 
patch to take out the check, but am not confident that this is the 
problem. It would help if I had a clearer understanding of what mm_user 
actually represented.

A patch for 2.6.30 follows.

--
Andrew Wesie
awesie@andrew.cmu.edu


--- linux-2.6.30/kernel/fork.c.orig     2009-06-15 13:25:52.000000000 
-0400
+++ linux-2.6.30/kernel/fork.c  2009-06-15 13:26:25.000000000 -0400
@@ -569,8 +569,7 @@ void mm_release(struct task_struct *tsk,
          * trouble otherwise.  Userland only wants this done for a 
sys_exit.
          */
         if (tsk->clear_child_tid
-           && !(tsk->flags & PF_SIGNALED)
-           && atomic_read(&mm->mm_users) > 1) {
+           && !(tsk->flags & PF_SIGNALED)) {
                 u32 __user * tidptr = tsk->clear_child_tid;
                 tsk->clear_child_tid = NULL;

