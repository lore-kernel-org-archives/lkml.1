Return-Path: <linux-kernel-owner+w=401wt.eu-S966988AbXFGX20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966988AbXFGX20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965199AbXFGX2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:28:14 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:57609 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965335AbXFGX2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:28:12 -0400
Date: Thu, 7 Jun 2007 16:27:33 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Syslets - Fix cachemiss_thread return value
Message-ID: <20070607232733.GM17082@mami.zabbo.net>
References: <20070531181923.GA9904@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531181923.GA9904@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 02:19:23PM -0400, Jeff Dike wrote:
> cachemiss_thread should explicitly return 0 or error instead of
> task_ret_reg(current) (which is -ENOSYS anyway) because
> async_thread_helper is careful to put the return value in eax anyway.

Here's the fix I came up with for this.  Untested (my test boxes are
busy doing some aio+syslet perf runs :)).  What do you guys think?

- z

- - -

async: return task_ret_reg() from async_cachemiss_loop()

When a thread blocks in __async_schedule() it finds a thread waiting in
async_cachemiss_loop() to return to userspace.  The return value of
async_cachemiss_loop() is propagated to userspace as the return code of the
call which the thread blocked in.

Previously this return code was hard-coded to 0 and -1, which worked fine for
the first syslet syscall APIs.  sys_io_submit() wants a different return call
convention when it uses syslets.  So cachemiss_thread() was changed to return
task_ret_reg(), sys_io_submit() would set it to the value it wanted returned to
userspace.

But this, by itself, was buggy.  The syslet syscall APIs didn't set
task_ret_reg() like sys_io_submit() did, so they got garbage returned.  Both
Jeff Dike and Chris Mason saw this in testing, though I was lucky enough to
have my returned garbage pass the tests I initially tried.  It also didn't
catch the other callers of async_cachemiss_loop() which would be returning to
userspace on behalf of calls which blocked in __async_schedule().  This would
be a problem, say, if people mixed sys_threadlet_on() and sys_io_submit() in
the same task.

So this patch fixes those up.

We always return task_ret_reg() from async_cachemiss_loop().  If we're
returning to the user's stack and IP instead of on behalf of a blocking call we
set task_ret_reg() to -1 and then return it.

__exec_atom() sets task_ret_reg() to NULL if there's a chance that it will
block while executing the syscall in the atom.

Signed-off-by: Zach Brown <zach.brown@oracle.com>

diff -r f0d8ee165e2e kernel/async.c
--- a/kernel/async.c	Thu Jun 07 14:32:31 2007 -0700
+++ b/kernel/async.c	Thu Jun 07 16:14:16 2007 -0700
@@ -206,6 +206,13 @@ static long __exec_atom(struct task_stru
 
 	if (unlikely(atom->nr >= atom->nr_syscalls))
 		return -ENOSYS;
+
+	/*
+	 * If the syslet goes asynchronous then we want the cachemiss
+	 * thread to return NULL to userspace on our behalf.
+	 */
+	if (likely(t->async_ready))
+		task_ret_reg(t) = 0;
 
 	ret = atom->call_table[atom->nr](atom->args[0], atom->args[1],
 					 atom->args[2], atom->args[3],
@@ -515,7 +522,22 @@ exec_atom(struct async_head *ah, struct 
 
 	return last_uatom;
 }
-
+/**
+ * async_cachemiss_loop - wait as a "cachemiss" thread
+ * @at:	this thread's async_thread in its task_struct
+ * @ah:	The async_head for this thread's group of threads
+ * @t:	this thread's task_struct
+ *
+ * Sleep as a ready async "cachemiss" thread.  If another thread in our
+ * async_head blocks then __async_schedule may block that thread and transfer
+ * its userspace over to us to return in to.
+ *
+ * Before threads get to __async_schedule() they set task_ret_reg() to the
+ * value that should be returned to userspace if they block.  We return it so
+ * that our caller can return it to userspace, either through the usual syscall
+ * return path or through the helper which cachemiss_thread() returns to after
+ * being created.
+ */
 long async_cachemiss_loop(struct async_thread *at, struct async_head *ah,
 			  struct task_struct *t)
 {
@@ -542,10 +564,13 @@ long async_cachemiss_loop(struct async_t
 		 */
 		set_task_stack_reg(t, at->user_stack);
 		task_ip_reg(t) = at->user_ip;
-
-		return -1;
-	}
-	return 0;
+		/*
+		 * We're not returning on behalf of some call, communicate
+		 * that.
+		 */
+		task_ret_reg(t) = -1;
+	}
+	return task_ret_reg(t);
 }
 
 struct cachemiss_args {
@@ -559,14 +584,6 @@ struct cachemiss_args {
  * first time: initialize, pick up the user stack/IP addresses from
  * the head and then execute the cachemiss loop. If the cachemiss
  * loop returns then we return back to user-space.
- *
- * Our return code overwrites the task_ret_reg() in ptregs in the assembly
- * stub which execution returns to before returning to userspace.  We may
- * be returning to userspace on behalf of an interrupted call which might
- * want us to return something specific to user space.  We return 
- * task_ret_reg() from this function so that the tasks we're returning
- * on behalf of can use it to pass return codes to userspace.  Perhaps
- * we shouldn't have the asm stub overwrite task_ret_reg() instead..
  */
 static long cachemiss_thread(void *data)
 {
@@ -606,8 +623,7 @@ static long cachemiss_thread(void *data)
 	}
 	complete(&ah->start_done);
 
-	async_cachemiss_loop(at, ah, t);
-	return task_ret_reg(t);
+	return async_cachemiss_loop(at, ah, t);
 }
 
 /**
