Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbYJ3ULl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbYJ3ULl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYJ3ULa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:11:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63338 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbYJ3UL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:11:29 -0400
Message-Id: <20081030200831.467420488@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 30 Oct 2008 16:08:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/2] ftrace: handle NMIs safely
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The robustness of ftrace has been the focus of the code modification in
2.6.28. There is one remaining issue that needed to be addressed.
This was the case of NMIs.

To state the problem: if a process on one CPU is modifying code that is
being executed on another CPU, that CPU will have undefined results,
and possibly issue a GPF.  To cover this with dynamic ftrace, it calls
kstop_machine to prevent the other CPUs from issuing interrupts or
executing any other process. The problem we have is that this does not
protect us against NMIs.

Discussing this with Arjan and Ingo, we came up with this RCU like solution.
When the patcher wants to modify code, it must do the following steps:

1) load the instruction pointer to modify into an IP buffer and the
   contents that will be modified into a "code" buffer.
2) set a write_bit flag.
3) wait for any running NMIs to finish.
4) modify the code.
5) clear the write bit flag.
6) wait for any running NMIs to finish
7) return the status of the write.

In the NMI handler, the first thing it will do is to check if the
write_bit is set, and if so, the NMI performs the write.
We do not worry about multiple writers writing to the code at the
same time, they are all writing the same thing.

The idea is that executing code will not have a problem if another
CPU has a process writing to that code with the same value as
what is in the code. In-other-words, the code does not change.

To help verify this, I wrote this module and let it run for a while:

-----------------------------------------------
#include <linux/module.h>
#include <linux/kthread.h>

#define WRITE_SIZE 50

static int write_thread(void *arg)
{
	unsigned char *ptr = (unsigned char *)schedule;
	static unsigned char write_buf[WRITE_SIZE];


	memcpy(write_buf, ptr, WRITE_SIZE);

	while (!kthread_should_stop()) {
		memcpy(ptr, write_buf, WRITE_SIZE);
		msleep(1);
	}

	return 0;
}

static struct task_struct *writer;

static int __init writer_torture_init(void)
{
	int ret;

	writer = kthread_run(write_thread, NULL, "write_tortured");
	ret = PTR_ERR(writer);

	if (IS_ERR(writer)) {
		writer = NULL;
		return ret;
	}

	return 0;
}

static void writer_torture_exit(void)
{
	if (writer)
		kthread_stop(writer);
}

module_init(writer_torture_init);
module_exit(writer_torture_exit);

MODULE_AUTHOR("Steven Rostedt");
MODULE_DESCRIPTION("Write code torture");
MODULE_LICENSE("GPL");
-----------------------------------------------

Do not run the dynamic ftrace while running this module ;-)

The second patch adds stats to the dyn_ftrace_total_info that adds
 NR-times-nmi-detect NR-times-NMI-wrote

-- Steve

