Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbXERQFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbXERQFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 12:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbXERQFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 12:05:17 -0400
Received: from as4.cineca.com ([130.186.84.213]:56290 "EHLO as4.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435AbXERQFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 12:05:15 -0400
Message-ID: <464DCEAB.3090905@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] log out-of-virtual-memory events
References: <464C81B5.8070101@users.sourceforge.net> <464C9D82.60105@redhat.com> <464D5AA4.8080900@users.sourceforge.net> <20070518091606.GA1010@lnx-holt.americas.sgi.com> <464DCC52.7090403@users.sourceforge.net>
In-Reply-To: <464DCC52.7090403@users.sourceforge.net>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Date: Fri, 18 May 2007 18:05:11 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> Robin Holt wrote:
>> On Fri, May 18, 2007 at 09:50:03AM +0200, Andrea Righi wrote:
>>> Rik van Riel wrote:
>>>> Andrea Righi wrote:
>>>>> I'm looking for a way to keep track of the processes that fail to
>>>>> allocate new
>>>>> virtual memory. What do you think about the following approach
>>>>> (untested)?
>>>> Looks like an easy way for users to spam syslogd over and
>>>> over and over again.
>>>>
>>>> At the very least, shouldn't this be dependant on print_fatal_signals?
>>>>
>>> Anyway, with print-fatal-signals enabled a user could spam syslogd too, simply
>>> with a (char *)0 = 0 program, but we could always identify the spam attempts
>>> logging the process uid...
>>>
>>> In any case, I agree, it should depend on that patch...
>>>
>>> What about adding a simple msleep_interruptible(SOME_MSECS) at the end of
>>> log_vm_enomem() or, at least, a might_sleep() to limit the potential spam/second
>>> rate?
>> An msleep will slow down this process, but do nothing about slowing
>> down the amount of logging.  Simply fork a few more processes and all
>> you are doing with msleep is polluting the pid space.
>>
> 
> Very true.
> 
>> What about a throttling similar to what ia64 does for floating point
>> assist faults (handle_fpu_swa()).  There is a thread flag to not log
>> the events at all.  It is rate throttled globally, but uses per cpu
>> variables for early exits.  This algorithm scaled well to a thousand
>> cpus.
> 
> Actually using printk_ratelimit() should be enough... BTW print_fatal_signals()
> should use it too.
> 

I mean, something like this...

---

Limit the rate of the printk()s in print_fatal_signal() to avoid potential DoS
problems.

Signed-off-by: Andrea Righi <a.righi@cineca.it>

diff -urpN linux-2.6.22-rc1-mm1/kernel/signal.c linux-2.6.22-rc1-mm1-limit-print_fatal_signals-rate/kernel/signal.c
--- linux-2.6.22-rc1-mm1/kernel/signal.c	2007-05-18 17:48:55.000000000 +0200
+++ linux-2.6.22-rc1-mm1-limit-print_fatal_signals-rate/kernel/signal.c	2007-05-18 17:58:13.000000000 +0200
@@ -790,6 +790,9 @@ static void print_vmas(void)
 
 static void print_fatal_signal(struct pt_regs *regs, int signr)
 {
+	if (unlikely(!printk_ratelimit()))
+		return;
+
 	printk("%s/%d: potentially unexpected fatal signal %d.\n",
 		current->comm, current->pid, signr);
 
