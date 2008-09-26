Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbYIZQKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbYIZQKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 12:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbYIZQJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 12:09:59 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:41176 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbYIZQJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 12:09:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAKef3EhMQWq+/2dsb2JhbACBXrtogWQ
Date: Fri, 26 Sep 2008 12:04:56 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH v4] Unified trace buffer
Message-ID: <20080926160456.GB27381@Krystal>
References: <20080925185154.230259579@goodmis.org> <20080925185236.244343232@goodmis.org> <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com> <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809252206260.8454@gandalf.stny.rr.com> <20080926032045.GA28771@Krystal> <1222413507.16700.235.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1222413507.16700.235.camel@lappy.programming.kicks-ass.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:04:30 up 113 days, 20:44,  8 users,  load average: 0.15, 0.26,
	0.28
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2008-09-25 at 23:20 -0400, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > 
> > > On Thu, 25 Sep 2008, Masami Hiramatsu wrote:
> > > 
> > > > Hi Steven,
> > > > 
> > > > Steven Rostedt wrote:
> > > > > This version has been cleaned up a bit. I've been running it as
> > > > > a back end to ftrace, and it has been handling pretty well.
> > > > 
> > > > Thank you for your great work.
> > > > It seems good to me(especially, encapsulating events :)).
> > > 
> > > Thanks!
> > > 
> > > > 
> > > > I have one request of enhancement.
> > > > 
> > > > > +static struct ring_buffer_per_cpu *
> > > > > +ring_buffer_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
> > > > > +{
> > > > [...]
> > > > > +	cpu_buffer->pages = kzalloc_node(ALIGN(sizeof(void *) * pages,
> > > > > +					       cache_line_size()), GFP_KERNEL,
> > > > > +					 cpu_to_node(cpu));
> > > > 
> > > > Here, you are using a slab object for page managing array,
> > > > the largest object size is 128KB(x86-64), so it can contain
> > > > 16K pages = 64MB.
> > > > 
> > > > As I had improved relayfs, in some rare case(on 64bit arch),
> > > > we'd like to use larger buffer than 64MB.
> > > > 
> > > > http://sourceware.org/ml/systemtap/2008-q2/msg00103.html
> > > > 
> > > > So, I think similar hack can be applicable.
> > > > 
> > > > Would it be acceptable for the next version?
> > > 
> > > I would like to avoid using vmalloc as much as possible, but I do see the 
> > > limitation here. Here's my compromise.
> > > 
> > > Instead of using vmalloc if the page array is greater than one page, 
> > > how about using vmalloc if the page array is greater than 
> > > KMALLOC_MAX_SIZE?
> > > 
> > > This would let us keep the vmap area free unless we have no choice.
> > > 
> > > -- Steve
> > > 
> > 
> > You could also fallback on a 2-level page array when buffer size is >
> > 64MB. The cost is mainly a supplementary pointer dereference, but one
> > more should not make sure a big difference overall.
> 
> I'm still not sure why we don't just link the pages using the page
> frames, we don't need the random access, do we?
> 

Yes, that's a brilliant idea :)

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
