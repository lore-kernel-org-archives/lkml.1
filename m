Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbZFAPGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbZFAPGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 11:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZFAPGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 11:06:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36112 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbZFAPGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 11:06:18 -0400
Date: Mon, 1 Jun 2009 11:06:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Christoph Hellwig <hch@infradead.org>
cc: Li Zefan <lizf@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/irq: use softirq_to_name instead of
 __print_symbolic
In-Reply-To: <20090601143626.GA26981@infradead.org>
Message-ID: <alpine.DEB.2.00.0906011045460.14994@gandalf.stny.rr.com>
References: <4A2396C7.3000700@cn.fujitsu.com> <20090601143626.GA26981@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 1 Jun 2009, Christoph Hellwig wrote:

> On Mon, Jun 01, 2009 at 04:52:23PM +0800, Li Zefan wrote:
> > It's great to boost recording of softirq events, but why not simply
> > use softirq_to_name in TP_printk()?
> 
> Because userspace programs using the binary trace buffer have no chance to
> retrieve the values from softirq_to_name.
> 
> > The above commit has 2 flaws:
> > 
> >   - we waste memory defining local static struct trace_print_flags array
> >     in each softirq TRACE_EVENT
> 
> That could be solved by declaring the array manually and just passing
> the address to __print_symbolic.  Steve, would that work?  (also for
> __print_flags)

I added the code to make it an array, but we still need to allocate it for 
every trace call. Otherwise, how do we export the information to 
userspace. One trace event (currently) has no way of depending on another 
trace event. If two trace events want the same array, currently they both 
must allocate it. I haven't looked too deeply into seeing how to manage 
that. It's not that much memory duplicated. I hate to make the code even 
more complex just to save a couple of hundred of bytes.

> 
> >   - if someone adds/removes a softirq, he may not know show_softirq_name()
> >     needs to be updated
> 
> Just make sure you have the translation defined next to the actual
> flags.  This is what I do in the XFS tracer:
> 
> typedef enum xfs_alloctype
> {
> 	XFS_ALLOCTYPE_ANY_AG,           /* allocate anywhere, use rotor */
> 	XFS_ALLOCTYPE_FIRST_AG,         /* ... start at ag 0 */
> 	XFS_ALLOCTYPE_START_AG,         /* anywhere, start in this a.g. */
> 	XFS_ALLOCTYPE_THIS_AG,          /* anywhere in this a.g. */
> 	XFS_ALLOCTYPE_START_BNO,	/* near this block else anywhere */
> 	XFS_ALLOCTYPE_NEAR_BNO,		/* in this a.g. and near this block */
> 	XFS_ALLOCTYPE_THIS_BNO		/* at exactly this block */
> } xfs_alloctype_t;
> 
> #define XFS_ALLOC_TYPES \
> 	{ XFS_ALLOCTYPE_ANY_AG,         "ANY_AG" }, \
> 	{ XFS_ALLOCTYPE_FIRST_AG,       "FIRST_AG" }, \
> 	{ XFS_ALLOCTYPE_START_AG,       "START_AG" }, \
> 	{ XFS_ALLOCTYPE_THIS_AG,	"THIS_AG" }, \
> 	{ XFS_ALLOCTYPE_START_BNO,	"START_BNO" }, \
> 	{ XFS_ALLOCTYPE_NEAR_BNO,	"NEAR_BNO" }, \
> 	{ XFS_ALLOCTYPE_THIS_BNO,	"THIS_BNO" }
> 
> > Another issue with the above commit, that the output of softirq events
> > becomes:
> > 
> >   X-1701  [000]  1595.220739: softirq_entry: softirq=1 action=TIMER_SOFTIRQ
> > 
> > Compared to the original output:
> > 
> >   X-1701  [000]  1595.220739: softirq_entry: softirq=1 action=TIMER
> 
> Which is trivially fixable, see above :)

Hmm, I thought I fixed that already. Perhaps it is in the code that Ingo 
has not pulled.

-- Steve

