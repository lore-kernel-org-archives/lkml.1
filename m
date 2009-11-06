Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZKFLFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZKFLFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 06:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbZKFLFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 06:05:20 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:57773 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbZKFLFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 06:05:19 -0500
Message-ID: <4AF40282.9080402@monstr.eu>
Date: Fri, 06 Nov 2009 12:03:30 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
       John Williams <john.williams@petalogix.com>
Subject: ftrace - graph tracer for Microblaze
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

I found the problem in my mcount function. I was Microblaze dependent 
fault - I had to save all registers which are not saved across function 
calls.

I am getting some problem is irqsoff tracing. Is there any special 
things which needs to be implemented/changed?

I would like to implement ftrace graph support and stack save support.

I believe that for stack_trace I need just to implement save_stack_trace.
If I understand correctly that feature should look at current process
and trace that process back to zero stack size.
It is just for current task right?

Then output shows which functions are called and size of stack. I found 
your post which is at http://lkml.org/lkml/2009/8/21/319 but you don't 
have any zero size stack size. Here is my log which seems to me weird 
because of zero size values. Is it correct or not?

# echo 1 > /proc/sys/kernel/stack_tracer_enabled
# cat /debug/tracing/stack_trace
         Depth    Size   Location    (63 entries)
         -----    ----   --------
   0)     2100       0   stack_trace_call+0x12c/0x1d8
   1)     2100       0   stack_trace_call+0x12c/0x1d8
   2)     2100       0   _spin_unlock+0x2c/0x3c
   3)     2100     180   __rcu_process_callbacks+0x3e0/0x460
   4)     1920     568   end_graph_tracer+0x24/0x2c
   5)     1352       0   end_graph_tracer+0x24/0x2c
   6)     1352       0   microblaze_read+0x14/0x4c
   7)     1352     184   microblaze_read+0x0/0x4c
...
  63)      156     156   ktime_add_ns+0x88/0x124

Here is my function -> it is the same as we use for dump stack.
I look at mips implementation and is the same

void save_stack_trace(struct stack_trace *trace)
{
	unsigned int sp;
	asm("addik %0, r1, 0" : "=r" (sp));

	while (!kstack_end(sp)) {
		addr = *sp++;
		if (__kernel_text_address(addr)) {
			if (trace->skip > 0)
				trace->skip--;
			else
			   trace->entries[trace->nr_entries++] = addr;

			if (trace->nr_entries >= trace->max_entries)
				break;
		}
	}
}



The second more important is graph part

I read it in ftrace design.txt and I don't understand how this really works.


For function trace without grapth support is calling
  foo()
(ret2foo) -> bar()
    (ret2bar) -> mcount() - I have to save full cpu content
                   -> ftrace_trace_function (ret2bar, ret2foo)
			(do some stuff)
                   <-
                   restore_whole_content and jump back to bar
                   after mcount call (mb do jump +8 - mb convention)
              bar ends -> jump back to foo


For graph is flow a little bit different
  foo()
(ret2foo) -> bar()
    (ret2bar) -> mcount() - I have to save full cpu content
                     ->prepare_ftrace_return(ret2bar, ret2foo)

and here I have to change return address -> Is it mean that from 
prepare_ftrace_return I have to return back to bar and then at the end 
of bar jump to return_to_handler which will call 
ftrace_return_to_handler and then jump back to foo. Is it correct?
What is the correct calling?



This is third topic - maybe I should send three separate emails :-(

I found some incompatibility which IMHO could be synchronize.
There is C implementation for ftrace_graph_entry_stub and ftrace_stub
is implemented in asm. The purpose of that two functions should be the 
same that's I think implementation should be too.

Because of my unresolved issue around irqsoff I traced it in code and 
there is too many tracing_reset_online_cpus() functions. I found one 
calling in __irqsoff_tracer_init and then in tracer_init function. Is 
that correct or one calling is enough?

Then I think that there is some things in Kconfig which should be 
cleared. I found link to /sys/kernel/debug/tracing/profile_branch which 
I don't have in tracing folder. Is it correct?

Thanks for your help,
Michal


