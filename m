Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbXISWFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbXISWFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXISWFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:05:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:10631 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbXISWFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Sc1iUoysn4J16+SyO5UIDLoYdIZX5ujkY+iBv+M30HfQF1XYIzCH+r5q0h2B/lV6c9hXlhAhObjoq4hoUwttCzIPb3Ald0qxGZPWhZzMxuQR7fCt1f9y/6pIt0bErrJq82T38rIXb3BcxaniTfphSjP7BuISPMeSdxnxfNKfJow=
Subject: Re: [PATCH] sched: fix to use invalid sched_class
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 20 Sep 2007 00:05:39 +0200
Message-Id: <1190239539.19576.5.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hi Ingo,
> > 
> > I found an issue about the scheduler.
> > If you need a test case, please let me know.
> > Here is a patch.
> > [ ... ]
> > The new thread should be valid scheduler class before queuing.
> > This patch fixes to set the suitable scheduler class.
> 
> Nice fix! It's a 2.6.23 must-have fix - i'll push it out into the 
> scheduler tree. Thanks!

I think, the following approach would be a bit more appropriate
(the missing addition to the already existing "don't leak PI boosting prio"):

(not tested)

---
diff --git a/kernel/sched.c b/kernel/sched.c
index bc1a625..da2139e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1646,6 +1646,8 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	 * Make sure we do not leak PI boosting priority to the child:
 	 */
 	p->prio = current->normal_prio;
+	if (!rt_prio(p->prio))
+		p->sched_class = &fair_sched_class;
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))

---



