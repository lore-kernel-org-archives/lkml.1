Return-Path: <linux-kernel-owner+w=401wt.eu-S1423405AbXDYXyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423405AbXDYXyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423407AbXDYXyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:54:43 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423405AbXDYXym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:54:42 -0400
Date: Wed, 25 Apr 2007 16:54:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 2.6.21-rc7-mm1: BUG_ON in kthread_bind during _cpu_down
Message-Id: <20070425165410.b73443b4.akpm@linux-foundation.org>
In-Reply-To: <200704260110.22224.rjw@sisk.pl>
References: <200704260110.22224.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 01:10:21 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Hi,
> 
> The BUG_ON in khthread_bind (line 165 in kthread.c) triggers for me during
> attempted suspend to disk, when disable_nonboot_cpus() calls _cpu_down()
> (on x86_64).

I guess the backtrace would be pretty important here.

Guys, please don't add BUG_ONs unless there is simply no sane way to recover.

Because when someone goofs up, the BUG_ON will kill the whole machine and
everyone else who has code being tested in -mm loses a tester.

Plus a BUG_ON *greatly* decreases our chances of getting a trace from the
tester: dead box, nothing in the logs.


--- a/kernel/kthread.c~fix-kthread_create-vs-freezer-theoretical-race-dont-be-obnoxious
+++ a/kernel/kthread.c
@@ -162,7 +162,10 @@ EXPORT_SYMBOL(kthread_create);
  */
 void kthread_bind(struct task_struct *k, unsigned int cpu)
 {
-	BUG_ON(k->state != TASK_UNINTERRUPTIBLE);
+	if (k->state != TASK_UNINTERRUPTIBLE) {
+		WARN_ON(1);
+		return;
+	}
 	/* Must have done schedule() in kthread() before we set_task_cpu */
 	wait_task_inactive(k);
 	set_task_cpu(k, cpu);
_

