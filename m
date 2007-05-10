Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbXEJMVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbXEJMVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbXEJMVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:21:41 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:51229 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbXEJMVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:21:40 -0400
From: Sripathi Kodi <sripathik@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] Use write_trylock_irqsave in ptrace_attach
Date: Thu, 10 May 2007 17:51:27 +0530
User-Agent: KMail/1.9.5
References: <200705091413.27344.sripathik@in.ibm.com> <20070509185003.34a45673.akpm@linux-foundation.org>
In-Reply-To: <20070509185003.34a45673.akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705101751.27860.sripathik@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Thursday 10 May 2007 07:20, you wrote:
> On Wed, 9 May 2007 14:13:27 +0530 Sripathi Kodi <sripathik@in.ibm.com> 
wrote:

<snip old patch>

> Your changelogs aren't vey logical.  The context for this change is off in
>
> a different patch.  I reproduce it here:
> > I am trying to fix the BUG I mentioned here:
> > http://lkml.org/lkml/2007/04/20/41. I noticed that an elegant way to
> > solve this problem is to have a write_trylock_irqsave helper function.
> > Since we don't have this now, the code in ptrace_attach  implements it
> > using local_irq_disable and write_trylock. I wish to add
> > write_trylock_irqsave to mainline kernel and then fix the -rt specific
> > problem using this.
>
> I can't imagine why -rt's write_unlock_irq() doesn't do local_irq_enable().
>
> I have no problem adding write_trylock_irqsave() - it fills a gap in the
> API.
>
> Once we have write_trylock_irqsave() it makes sense to use it here.
>
> One the downside, we added a few bytes to the SMP kernel, which I guess we
> can live with.
>
> Whether this change is desired in -rt I don't know.  Ingo?
>
> I don't think the initialisation of `flags' there was needed?

I removed the initialization of 'flags' in the following patch. Would you like 
to drop the old one and pick up this?

Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>

diff -uprN linux-2.6.21.1_org/kernel/ptrace.c linux-2.6.21.1/kernel/ptrace.c
--- linux-2.6.21.1_org/kernel/ptrace.c	2007-05-09 13:18:39.000000000 +0530
+++ linux-2.6.21.1/kernel/ptrace.c	2007-05-10 17:40:51.000000000 +0530
@@ -160,6 +160,7 @@ int ptrace_may_attach(struct task_struct
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
+	unsigned long flags;
 
 	retval = -EPERM;
 	if (task->pid <= 1)
@@ -178,9 +179,7 @@ repeat:
 	 * cpu's that may have task_lock).
 	 */
 	task_lock(task);
-	local_irq_disable();
-	if (!write_trylock(&tasklist_lock)) {
-		local_irq_enable();
+	if (!write_trylock_irqsave(&tasklist_lock, flags)) {
 		task_unlock(task);
 		do {
 			cpu_relax();
@@ -208,7 +207,7 @@ repeat:
 	force_sig_specific(SIGSTOP, task);
 
 bad:
-	write_unlock_irq(&tasklist_lock);
+	write_unlock_irqrestore(&tasklist_lock, flags);
 	task_unlock(task);
 out:
 	return retval;
