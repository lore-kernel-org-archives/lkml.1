Return-Path: <linux-kernel-owner+w=401wt.eu-S1757832AbZAXC4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbZAXC4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 21:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbZAXC4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 21:56:31 -0500
Received: from smtp-out.google.com ([216.239.33.17]:28736 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbZAXC4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 21:56:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:
	x-operating-system:user-agent:x-gmailtapped-by:x-gmailtapped;
	b=U66/8ODvrfPJ0hjG5JCAr39/JugGcq5INx4F1z2memFhlpOQGZ/4rFstKT92s/49v
	KRq7mIiCkGBT2JR7s/V3w==
Date: Fri, 23 Jan 2009 18:56:18 -0800
From: Mandeep Singh Baines <msb@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org, rientjes@google.com,
       mbligh@google.com, thockin@google.com
Subject: Re: [PATCH v3] softlockup: remove hung_task_check_count
Message-ID: <20090124025618.GB31189@google.com>
References: <20090122083457.GC7438@elte.hu> <20090122195513.GA22146@google.com> <1fe6c7900901221921m586b129dwf8c3446f897b57f0@mail.gmail.com> <20090123092306.GB29820@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123092306.GB29820@elte.hu>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.24.198.77
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar (mingo@elte.hu) wrote:
> 
> not sure i like the whole idea of removing the max iterations check. In 
> theory if there's a _ton_ of tasks, we could spend a lot of time looping 
> there. So it always looked prudent to limit it somewhat.
> 

We could go back to exporting max iterations to proc, and set the nice
value higher.

Or:

Instead of searching the tasklist from the beginning every time, continue
where you left off. On loaded systems, will take a while to search the
entire list but at least all tasks will be checked.

Something like this:

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index ba8ccd4..d220796 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -109,6 +109,15 @@ static void check_hung_task(struct task_struct *t, unsigned long now,
 		panic("hung_task: blocked tasks");
 }
 
+static void wait_till_next_iteration(struct task_struct *t)
+{
+	get_task_state(t);
+	read_unlock(&tasklist_lock);
+	schedule_timeout_interruptible(hung_task_poll_jiffies);
+	read_lock(&tasklist_lock);
+	put_task_state(t);
+}
+
 /*
  * Check whether a TASK_UNINTERRUPTIBLE does not get woken up for
  * a really long time (120 seconds). If that happens, print out
@@ -129,8 +138,14 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 
 	read_lock(&tasklist_lock);
 	do_each_thread(g, t) {
-		if (!--max_count)
-			goto unlock;
+		if (!--max_count) {
+			max_count = HUNG_TASK_CHECK_COUNT;
+			wait_till_next_iteration(t);
+			timeout = sysctl_hung_task_timeout_secs;
+			/* Exit loop if t was unlinked or timeout set to 0. */
+			if (!timeout || t->state == TASK_DEAD)
+				goto unlock;
+		}
 		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
 		if (t->state == TASK_UNINTERRUPTIBLE)
 			check_hung_task(t, now, timeout);
