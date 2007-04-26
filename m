Return-Path: <linux-kernel-owner+w=401wt.eu-S1031494AbXDZUBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031494AbXDZUBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031490AbXDZUA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:00:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55829 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031491AbXDZUAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:00:54 -0400
Date: Thu, 26 Apr 2007 15:00:47 -0500
From: Dean Nelson <dcn@sgi.com>
To: akpm@osdl.org
Cc: ebiederm@xmission.com, containers@lists.osdl.org, oleg@tv-sign.ru,
       hch@infradead.org, jes@sgi.com, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, dcn@sgi.com
Subject: Re: [PATCH] ia64 sn xpc: Convert to use kthread API.
Message-ID: <20070426200047.GA1959@sgi.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <1176969574439-git-send-email-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176969574439-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 01:58:44AM -0600, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> This patch starts the xpc kernel threads using kthread_run
> not a combination of kernel_thread and daemonize.  Resuling
> in slightly simpler and more maintainable code.
> 
> Cc: Jes Sorensen <jes@sgi.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  arch/ia64/sn/kernel/xpc_main.c |   31 +++++++++++++------------------
>  1 files changed, 13 insertions(+), 18 deletions(-)

Acked-by: Dean Nelson <dcn@sgi.com>

Andrew, I've tested Eric's patch in conjunction with a fix from Christoph
Lameter, which you've already got (it cleaned up a couple of compiler errors),
and the following patch that I'd like added (it cleans up a couple of
compiler warning errors and makes a few cosmetic changes).

Thanks,
Dean


Signed-off-by: Dean Nelson <dcn@sgi.com>

Index: mm-tree/arch/ia64/sn/kernel/xpc_main.c
===================================================================
--- mm-tree.orig/arch/ia64/sn/kernel/xpc_main.c	2007-04-25 14:04:51.701213426 -0500
+++ mm-tree/arch/ia64/sn/kernel/xpc_main.c	2007-04-26 06:29:02.447330438 -0500
@@ -568,7 +568,6 @@
 
 	task = kthread_run(xpc_activating, (void *) ((u64) partid),
 			  "xpc%02d", partid);
-
 	if (unlikely(IS_ERR(task))) {
 		spin_lock_irqsave(&part->act_lock, irq_flags);
 		part->act_state = XPC_P_INACTIVE;
@@ -808,7 +807,6 @@
 			int ignore_disconnecting)
 {
 	unsigned long irq_flags;
-	pid_t pid;
 	u64 args = XPC_PACK_ARGS(ch->partid, ch->number);
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
 	struct task_struct *task;
@@ -840,7 +838,7 @@
 		(void) xpc_part_ref(part);
 		xpc_msgqueue_ref(ch);
 
-		task = kthread_run(xpc_daemonize_kthread, args,
+		task = kthread_run(xpc_daemonize_kthread, (void *) args,
 				   "xpc%02dc%d", ch->partid, ch->number);
 		if (IS_ERR(task)) {
 			/* the fork failed */
@@ -1381,7 +1379,8 @@
 	 * activate based on info provided by SAL. This new thread is short
 	 * lived and will exit once discovery is complete.
 	 */
-	task = kthread_run(xpc_initiate_discovery, NULL, XPC_DISCOVERY_THREAD_NAME);
+	task = kthread_run(xpc_initiate_discovery, NULL,
+			   XPC_DISCOVERY_THREAD_NAME);
 	if (IS_ERR(task)) {
 		dev_err(xpc_part, "failed while forking discovery thread\n");
 
