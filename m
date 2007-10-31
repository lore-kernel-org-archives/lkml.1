Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbXJaGmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbXJaGmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbXJaGmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:42:23 -0400
Received: from ns1.suse.de ([195.135.220.2]:33087 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbXJaGmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:42:23 -0400
Date: Wed, 31 Oct 2007 07:42:21 +0100
From: Nick Piggin <npiggin@suse.de>
To: Duane Griffin <duaneg@dghda.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb causes unkillable spinning
Message-ID: <20071031064221.GC12189@wotan.suse.de>
References: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 12:45:35AM +0000, Duane Griffin wrote:
> Accessing a memory mapped region past the last page containing a valid
> file mapping produces a SIGBUS fault (as it should). Running a program
> that does this under gdb, then accessing the invalid memory from gdb,
> causes it to start consuming 100% CPU and become unkillable. Once in
> that state, SysRq-T doesn't show a stack trace for gdb, although it is
> shown as running and stack traces are dumped for other tasks.


BTW. this has come up for me before, and I have found it useful on
a number of occasions to print the stack of running tasks when they
are looping in the kernel...

Any reason we can't do this?

--
Sysrq+T fails to show the stack trace of a running task. Presumably this
is to avoid a garbled stack, however it can often be useful, and besides
there is no guarantee that the task won't start running in the middle of
show_stack(). If there are any correctness issues, then the archietcture
would have to take further steps to ensure the task is not running.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c	2007-10-31 06:53:22.000000000 +1100
+++ linux-2.6/kernel/sched.c	2007-10-31 06:56:02.000000000 +1100
@@ -4900,8 +4900,7 @@
 	printk(KERN_CONT "%5lu %5d %6d\n", free,
 		task_pid_nr(p), task_pid_nr(p->parent));
 
-	if (state != TASK_RUNNING)
-		show_stack(p, NULL);
+	show_stack(p, NULL);
 }
 
 void show_state_filter(unsigned long state_filter)
