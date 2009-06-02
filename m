Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbZFBB3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbZFBB3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 21:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbZFBB3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 21:29:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57568 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbZFBB3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 21:29:39 -0400
Message-ID: <4A2480D4.8030205@cn.fujitsu.com>
Date: Tue, 02 Jun 2009 09:31:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/irq: use softirq_to_name instead of __print_symbolic
References: <4A2396C7.3000700@cn.fujitsu.com> <20090601143626.GA26981@infradead.org> <alpine.DEB.2.00.0906011045460.14994@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0906011045460.14994@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 1 Jun 2009, Christoph Hellwig wrote:
> 
>> On Mon, Jun 01, 2009 at 04:52:23PM +0800, Li Zefan wrote:
>>> It's great to boost recording of softirq events, but why not simply
>>> use softirq_to_name in TP_printk()?
>> Because userspace programs using the binary trace buffer have no chance to
>> retrieve the values from softirq_to_name.
>>

Do you mean, by parsing the format file?

# cat events/irq/softirq_entry/format
	...
print fmt: "softirq=%d action=%s", REC->vec, ({ static const struct trace_print_flags
symbols[] =  { { HI_SOFTIRQ, "HI_SOFTIRQ" }, { TIMER_SOFTIRQ, "TIMER_SOFTIRQ" },
{ NET_TX_SOFTIRQ, "NET_TX_SOFTIRQ" }, { NET_RX_SOFTIRQ, "NET_RX_SOFTIRQ" },
{ BLOCK_SOFTIRQ, "BLOCK_SOFTIRQ" }, { TASKLET_SOFTIRQ, "TASKLET_SOFTIRQ" }, 
{ SCHED_SOFTIRQ, "SCHED_SOFTIRQ" }, { HRTIMER_SOFTIRQ, "HRTIMER_SOFTIRQ" },
{ RCU_SOFTIRQ, "RCU_SOFTIRQ" },  { -1, ((void *)0) }};
ftrace_print_symbols_seq(p, REC->vec, symbols); })

>>> The above commit has 2 flaws:
>>>
>>>   - we waste memory defining local static struct trace_print_flags array
>>>     in each softirq TRACE_EVENT
>> That could be solved by declaring the array manually and just passing
>> the address to __print_symbolic.  Steve, would that work?  (also for
>> __print_flags)
> 
> I added the code to make it an array, but we still need to allocate it for 
> every trace call. Otherwise, how do we export the information to 
> userspace. One trace event (currently) has no way of depending on another 
> trace event. If two trace events want the same array, currently they both 
> must allocate it. I haven't looked too deeply into seeing how to manage 
> that. It's not that much memory duplicated. I hate to make the code even 
> more complex just to save a couple of hundred of bytes.
> 
>>>   - if someone adds/removes a softirq, he may not know show_softirq_name()
>>>     needs to be updated
>> Just make sure you have the translation defined next to the actual
>> flags.  This is what I do in the XFS tracer:
>>
>> typedef enum xfs_alloctype
>> {
>> 	XFS_ALLOCTYPE_ANY_AG,           /* allocate anywhere, use rotor */
>> 	XFS_ALLOCTYPE_FIRST_AG,         /* ... start at ag 0 */
>> 	XFS_ALLOCTYPE_START_AG,         /* anywhere, start in this a.g. */
>> 	XFS_ALLOCTYPE_THIS_AG,          /* anywhere in this a.g. */
>> 	XFS_ALLOCTYPE_START_BNO,	/* near this block else anywhere */
>> 	XFS_ALLOCTYPE_NEAR_BNO,		/* in this a.g. and near this block */
>> 	XFS_ALLOCTYPE_THIS_BNO		/* at exactly this block */
>> } xfs_alloctype_t;
>>
>> #define XFS_ALLOC_TYPES \
>> 	{ XFS_ALLOCTYPE_ANY_AG,         "ANY_AG" }, \
>> 	{ XFS_ALLOCTYPE_FIRST_AG,       "FIRST_AG" }, \
>> 	{ XFS_ALLOCTYPE_START_AG,       "START_AG" }, \
>> 	{ XFS_ALLOCTYPE_THIS_AG,	"THIS_AG" }, \
>> 	{ XFS_ALLOCTYPE_START_BNO,	"START_BNO" }, \
>> 	{ XFS_ALLOCTYPE_NEAR_BNO,	"NEAR_BNO" }, \
>> 	{ XFS_ALLOCTYPE_THIS_BNO,	"THIS_BNO" }
>>
>>> Another issue with the above commit, that the output of softirq events
>>> becomes:
>>>
>>>   X-1701  [000]  1595.220739: softirq_entry: softirq=1 action=TIMER_SOFTIRQ
>>>
>>> Compared to the original output:
>>>
>>>   X-1701  [000]  1595.220739: softirq_entry: softirq=1 action=TIMER
>> Which is trivially fixable, see above :)
> 
> Hmm, I thought I fixed that already. Perhaps it is in the code that Ingo 
> has not pulled.
> 

I guess you forgot to fix it. ;)

I made a comment on that patch, but seems you didn't update the patch:
	http://lkml.org/lkml/2009/5/21/9

I'll make a patch for this.
