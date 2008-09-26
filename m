Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbYIZCMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbYIZCMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYIZCLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:11:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63788 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbYIZCLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:11:44 -0400
Date: Thu, 25 Sep 2008 22:11:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH v4] Unified trace buffer
In-Reply-To: <48DC406D.1050508@redhat.com>
Message-ID: <alpine.DEB.1.10.0809252206260.8454@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org> <20080925185236.244343232@goodmis.org> <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com> <48DC406D.1050508@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Sep 2008, Masami Hiramatsu wrote:

> Hi Steven,
> 
> Steven Rostedt wrote:
> > This version has been cleaned up a bit. I've been running it as
> > a back end to ftrace, and it has been handling pretty well.
> 
> Thank you for your great work.
> It seems good to me(especially, encapsulating events :)).

Thanks!

> 
> I have one request of enhancement.
> 
> > +static struct ring_buffer_per_cpu *
> > +ring_buffer_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
> > +{
> [...]
> > +	cpu_buffer->pages = kzalloc_node(ALIGN(sizeof(void *) * pages,
> > +					       cache_line_size()), GFP_KERNEL,
> > +					 cpu_to_node(cpu));
> 
> Here, you are using a slab object for page managing array,
> the largest object size is 128KB(x86-64), so it can contain
> 16K pages = 64MB.
> 
> As I had improved relayfs, in some rare case(on 64bit arch),
> we'd like to use larger buffer than 64MB.
> 
> http://sourceware.org/ml/systemtap/2008-q2/msg00103.html
> 
> So, I think similar hack can be applicable.
> 
> Would it be acceptable for the next version?

I would like to avoid using vmalloc as much as possible, but I do see the 
limitation here. Here's my compromise.

Instead of using vmalloc if the page array is greater than one page, 
how about using vmalloc if the page array is greater than 
KMALLOC_MAX_SIZE?

This would let us keep the vmap area free unless we have no choice.

-- Steve

