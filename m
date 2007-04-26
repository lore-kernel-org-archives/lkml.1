Return-Path: <linux-kernel-owner+w=401wt.eu-S1030367AbXDZKKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030367AbXDZKKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030490AbXDZKKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:10:25 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57596 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030367AbXDZKKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:10:23 -0400
Date: Thu, 26 Apr 2007 15:39:22 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 2.6.21-rc7-mm1: BUG_ON in kthread_bind during _cpu_down
Message-ID: <20070426100922.GB12892@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200704260110.22224.rjw@sisk.pl> <20070425165410.b73443b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425165410.b73443b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 04:54:10PM -0700, Andrew Morton wrote:
> On Thu, 26 Apr 2007 01:10:21 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Hi,
> > 
> > The BUG_ON in khthread_bind (line 165 in kthread.c) triggers for me during
> > attempted suspend to disk, when disable_nonboot_cpus() calls _cpu_down()
> > (on x86_64).
> 
Caused due to Oleg's patch http://lkml.org/lkml/2007/4/13/93.

Agreed that most of the time a kthread_create(p) is followed by a
kthread_bind(p), in which case the assertion 
WARN_ON(p->state != TASK_UNINTERRUPTIBLE) makes sense.

But, in cpu hotplug case, we need to rebind the stop_machine_run thread
from the cpu which has just been offlined to any online cpu.
(kernel/cpu.c line 180)
At this point, the thread would be in TASK_INTERRUPTIBLE waiting for us
to call a kthread_stop on it.(kernel/kthread.c line 161)

We only need to ensure in kthread_bind that the task which is being
bound is not running or exiting. Doesn't matter if it's sleeping in 
TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE state.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 kernel/kthread.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.21-rc7/kernel/kthread.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/kthread.c
+++ linux-2.6.21-rc7/kernel/kthread.c
@@ -162,7 +162,8 @@ EXPORT_SYMBOL(kthread_create);
  */
 void kthread_bind(struct task_struct *k, unsigned int cpu)
 {
-	if (k->state != TASK_UNINTERRUPTIBLE) {
+	if (k->state != TASK_UNINTERRUPTIBLE &&
+	    k->state != TASK_INTERRUPTIBLE) {
 		WARN_ON(1);
 		return;
 	}
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
