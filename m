Return-Path: <linux-kernel-owner+w=401wt.eu-S1759730AbXERPz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730AbXERPz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 11:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbXERPzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 11:55:19 -0400
Received: from as2.cineca.com ([130.186.84.242]:35880 "EHLO as2.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834AbXERPzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 11:55:17 -0400
Message-ID: <464DCC52.7090403@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] log out-of-virtual-memory events
References: <464C81B5.8070101@users.sourceforge.net> <464C9D82.60105@redhat.com> <464D5AA4.8080900@users.sourceforge.net> <20070518091606.GA1010@lnx-holt.americas.sgi.com>
In-Reply-To: <20070518091606.GA1010@lnx-holt.americas.sgi.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Date: Fri, 18 May 2007 17:55:10 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt wrote:
> On Fri, May 18, 2007 at 09:50:03AM +0200, Andrea Righi wrote:
>> Rik van Riel wrote:
>>> Andrea Righi wrote:
>>>> I'm looking for a way to keep track of the processes that fail to
>>>> allocate new
>>>> virtual memory. What do you think about the following approach
>>>> (untested)?
>>> Looks like an easy way for users to spam syslogd over and
>>> over and over again.
>>>
>>> At the very least, shouldn't this be dependant on print_fatal_signals?
>>>
>> Anyway, with print-fatal-signals enabled a user could spam syslogd too, simply
>> with a (char *)0 = 0 program, but we could always identify the spam attempts
>> logging the process uid...
>>
>> In any case, I agree, it should depend on that patch...
>>
>> What about adding a simple msleep_interruptible(SOME_MSECS) at the end of
>> log_vm_enomem() or, at least, a might_sleep() to limit the potential spam/second
>> rate?
> 
> An msleep will slow down this process, but do nothing about slowing
> down the amount of logging.  Simply fork a few more processes and all
> you are doing with msleep is polluting the pid space.
> 

Very true.

> What about a throttling similar to what ia64 does for floating point
> assist faults (handle_fpu_swa()).  There is a thread flag to not log
> the events at all.  It is rate throttled globally, but uses per cpu
> variables for early exits.  This algorithm scaled well to a thousand
> cpus.

Actually using printk_ratelimit() should be enough... BTW print_fatal_signals()
should use it too.

-Andrea

---

Signed-off-by: Andrea Righi <a.righi@cineca.it>

diff -urpN linux-2.6.21/mm/mmap.c linux-2.6.21-vm-log-enomem/mm/mmap.c
--- linux-2.6.21/mm/mmap.c	2007-04-26 05:08:32.000000000 +0200
+++ linux-2.6.21-vm-log-enomem/mm/mmap.c	2007-05-18 17:17:32.000000000 +0200
@@ -77,6 +77,29 @@ int sysctl_max_map_count __read_mostly =
 atomic_t vm_committed_space = ATOMIC_INIT(0);
 
 /*
+ * Print current process informations when it fails to allocate new virtual
+ * memory.
+ */
+static inline void log_vm_enomem(void)
+{
+	unsigned long total_vm = 0;
+	struct mm_struct *mm;
+
+	if (unlikely(!printk_ratelimit()))
+		return;
+
+	task_lock(current);
+	mm = current->mm;
+	if (mm)
+		total_vm = mm->total_vm;
+	task_unlock(current);
+
+	printk(KERN_INFO
+	       "out of virtual memory for process %d (%s): total_vm=%lu, uid=%d\n",
+		current->pid, current->comm, total_vm, current->uid);
+}
+
+/*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
  * succeed and -ENOMEM implies there is not.
@@ -175,6 +198,7 @@ int __vm_enough_memory(long pages, int c
 		return 0;
 error:
 	vm_unacct_memory(pages);
+	log_vm_enomem();
 
 	return -ENOMEM;
 }
