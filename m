Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYIZVR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYIZVR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYIZVRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:17:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbYIZVRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:17:51 -0400
Message-ID: <48DD50AB.10208@redhat.com>
Date: Fri, 26 Sep 2008 17:14:19 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v6] Unified trace buffer
References: <20080925185154.230259579@goodmis.org>	 <20080925185236.244343232@goodmis.org>	 <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>	 <48DC406D.1050508@redhat.com>	 <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>	 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <1222459730.16700.295.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1222459730.16700.295.camel@lappy.programming.kicks-ass.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2008-09-26 at 14:05 -0400, Steven Rostedt wrote:
>> +static void
>> +rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned
>> nr_pages)
>> +{
>> +       struct page *page;
>> +       struct list_head *p;
>> +       unsigned i;
>> +
>> +       atomic_inc(&cpu_buffer->record_disabled);
> 
> You probably want synchronize_sched() here (and similar other places) to
> ensure any active writer on the corresponding cpu is actually stopped.

Would it really be done in the buffer layer?
I think it should be done by each tracer, because buffer layer
can't ensure truly active writers have stopped.

Thank you,

> 
> Which suggests you want to use something like ring_buffer_lock_cpu() and
> implement that as above.
> 
>> +       for (i = 0; i < nr_pages; i++) {
>> +               BUG_ON(list_empty(&cpu_buffer->pages));
>> +               p = cpu_buffer->pages.next;
>> +               page = list_entry(p, struct page, lru);
>> +               list_del_init(&page->lru);
>> +               __free_page(page);
>> +       }
>> +       BUG_ON(list_empty(&cpu_buffer->pages));
>> +
>> +       __ring_buffer_reset_cpu(cpu_buffer);
>> +
>> +       check_pages(cpu_buffer);
>> +
>> +       atomic_dec(&cpu_buffer->record_disabled);
>> +
>> +}
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

