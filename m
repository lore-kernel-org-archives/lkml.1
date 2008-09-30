Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbYI3Gv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbYI3Gv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 02:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbYI3GvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 02:51:18 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:51110 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYI3GvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 02:51:17 -0400
Message-ID: <48E1CB96.80109@bull.net>
Date: Tue, 30 Sep 2008 08:47:50 +0200
From: Gilles Carry <Gilles.Carry@bull.net>
User-Agent: Mozilla Thunderbird 1.0 (X11/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chirag Jog <chirag@linux.vnet.ibm.com>
Cc: Gregory Haskins <ghaskins@novell.com>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, dvhltc@us.ibm.com,
       Dinakar Guniguntala <dino@in.ibm.com>
Subject: Re: [BUG][PPC64] BUG in 2.6.26.5-rt9 causing Hang
References: <20080925123235.GA27916@linux.vnet.ibm.com> <48E1460A.5000504@novell.com> <48E14A00.7060105@novell.com> <48E14FE1.7040507@novell.com> <20080930044320.GA4685@linux.vnet.ibm.com>
In-Reply-To: <20080930044320.GA4685@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chirag Jog wrote:
> Hi Gregory,
> * Gregory Haskins <ghaskins@novell.com> [2008-09-29 18:00:01]:
> 
> 
>>Gregory Haskins wrote:
>>
>>>Gregory Haskins wrote:
>>>  
>>>
>>>>Hi Chirag
>>>>
>>>>Chirag Jog wrote:
>>>>  
>>>>    
>>>>
>>>>>Hi Gregory,
>>>>>We see the following BUG followed by a hang on the latest kernel 2.6.26.5-rt9 on a Power6 blade (PPC64)
>>>>>It is easily recreated by running the async_handler or sbrk_mutex (realtime tests from ltp) tests.
>>>>>  
>>>>>    
>>>>>      
>>>>
>>>>Call me an LTP newbie, but where can I get the sbrk_mutex/async_handler
>>>>tests.
>>>>    
>>>
>>>Ok, I figured out this part.  I needed a newer version of the .rpm from
>>>a different repo.  However, both async_handler and sbrk_mutex seem to
>>>segfault for me.  Hmm
>>>  
>>
>>Thanks to help from Darren I got around this issue.  Unfortunately both
>>tests pass so I cannot reproduce this issue, nor do I see the problem
>>via code inspection.  Ill keep digging but I am currently at a loss.  I
>>may need to send you some diagnostic patches to find this, if that is ok
>>with you Chirag?
> 
> This particular bug is not producible on the x86 boxes, i have access
> to. Only on ppc64.
> Please send the diagnostic patches across. 
> I'll try them out! :)
> 

Hi,

I have access to Power6 and x86_64 boxes and so far I could only
reproduce the bug on PPC64.

The bug arised from 2.6.26.3-rt6 since sched-only-push-if-pushable.patch
and sched-only-push-once-per-queue.patch.

Whereas sbrk_mutex definetly shows up the problem, it also can occur
randomly, sometimes during the boot period.

At the beginning, I had system hangs or this (very similar to Chirag's and
not necessarly in sbrk_mutex):

cpu 0x3: Vector: 700 (Program Check) at [c0000000ee30b600]
     pc: c0000000001b9bac: .__list_add+0x70/0xa0
     lr: c0000000001b9ba8: .__list_add+0x6c/0xa0
     sp: c0000000ee30b880
    msr: 8000000000021032
   current = 0xc0000000ee2b1830
   paca    = 0xc0000000005c3980
     pid   = 51, comm = sirq-sched/3
kernel BUG at lib/list_debug.c:33!
enter ? for help
[c0000000ee30b900] c0000000001b8ec0 .plist_del+0x6c/0xcc
[c0000000ee30b9a0] c00000000004d500 .dequeue_pushable_task+0x24/0x3c
[c0000000ee30ba20] c00000000004ec18 .push_rt_task+0x1f0/0x2c0
[c0000000ee30bae0] c00000000004ed0c .push_rt_tasks+0x24/0x44
[c0000000ee30bb70] c00000000004ed58 .post_schedule_rt+0x2c/0x50
[c0000000ee30bc00] c0000000000527c4 .finish_task_switch+0x100/0x1a8
[c0000000ee30bcb0] c0000000002cd1e0 .__schedule+0x688/0x744
[c0000000ee30bd90] c0000000002cd4ec .schedule+0xf4/0x128
[c0000000ee30be20] c000000000061634 .ksoftirqd+0x124/0x37c
[c0000000ee30bf00] c000000000076cf0 .kthread+0x84/0xd4
[c0000000ee30bf90] c000000000029368 .kernel_thread+0x4c/0x68
3:mon>

So I suspected a memory corruption but adding padding fields around
the pointers and extra checks did not reveal any data trashing.


Playing with xmon, I finally found out that when hanging, the system
was stuck in an infinite loop in plist_check_list.
Si I modified lib/plist.c:
I supposed that no list holds more than 100 000 000 elements in
the system. ;-)

  static void plist_check_list(struct list_head *top)
  {
         struct list_head *prev = top, *next = top->next;
+       unsigned long long i = 1;

         plist_check_prev_next(top, prev, next);
         while (next != top) {
+               BUG_ON(i++ >    100000000);
                 prev = next;
                 next = prev->next;
                 plist_check_prev_next(top, prev, next);


and got this:

cpu 0x6: Vector: 700 (Program Check) at [c0000000eeda7530]
     pc: c0000000001ba498: .plist_check_list+0x68/0xb4
     lr: c0000000001ba4b4: .plist_check_list+0x84/0xb4
     sp: c0000000eeda77b0
    msr: 8000000000021032
   current = 0xc0000000ee80dfa0
   paca    = 0xc0000000005d3f80
     pid   = 2602, comm = sbrk_mutex
kernel BUG at lib/plist.c:50!
enter ? for help
[c0000000eeda7850] c0000000001ba530 .plist_check_head+0x4c/0x64
[c0000000eeda78e0] c0000000001ba57c .plist_del+0x34/0xdc
[c0000000eeda7980] c00000000004d734 .dequeue_pushable_task+0x24/0x3c
[c0000000eeda7a00] c00000000004d7c4 .pick_next_task_rt+0x38/0x58
[c0000000eeda7a90] c0000000002cefb0 .__schedule+0x510/0x75c
[c0000000eeda7b70] c0000000002cf44c .schedule+0xf4/0x128
[c0000000eeda7c00] c0000000002cfe4c .do_nanosleep+0x7c/0xe4
[c0000000eeda7c90] c00000000007be68 .hrtimer_nanosleep+0x84/0x10c
[c0000000eeda7d90] c00000000007bf6c .sys_nanosleep+0x7c/0xa0
[c0000000eeda7e30] c0000000000086ac syscall_exit+0x0/0x40
--- Exception: c01 (System Call) at 00000080fdb85880
SP (4000843e660) is in userspace

which corresponds to the BUG_ON stuff.
It seems that the pushable_tasks list is corrupted: it never loops
back to the first element (top). Is there a shortcut anywhere?



Since the patches don't feature any arch-specific change, I'm looking
for arch-specific code triggered by the modifications brought by the
patches. Still searching...

Also for me, using CONFIG_GROUP_SCHED stuffs hides the problem.

I'm going to harden plist_check_list and see what it does.

Gilles.
