Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbYI3R5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbYI3R5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYI3R5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:57:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43543 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbYI3R53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:57:29 -0400
Date: Tue, 30 Sep 2008 13:56:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v10 Golden] Unified trace buffer
In-Reply-To: <1222796952.24384.25.camel@twins>
Message-ID: <alpine.DEB.1.10.0809301350410.6224@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com> 
 <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809291202180.5493@gandalf.stny.rr.com>  <20080929233539.GA31143@Krystal>  <alpine.DEB.1.10.0809292000160.8145@gandalf.stny.rr.com>  <20080930000307.GA2929@Krystal> 
 <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com>  <20080930034603.GA13801@Krystal>  <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com>  <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins> 
 <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org>  <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com>  <1222794043.24384.22.camel@twins>  <alpine.DEB.1.10.0809301339140.6224@gandalf.stny.rr.com> <1222796952.24384.25.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 30 Sep 2008, Peter Zijlstra wrote:
> 
> The problem with storing the page link information inside the page is
> that it doesnt transfer to another address space, so if you do indeed
> mmap these pages, then the link information is bogus.
> 
> Of course, in such a situation you could ignore these headers, but
> somehow that doesn't sound too apealing.


No that's not what I'm proposing. I'm proposing to allocate a page_header 
structure for every page we alloc, and make a link list of them.
In other words:


struct ring_buffer_per_cpu {
	[...]
	struct list_head pages;
	[...]
};

struct buffer_page {
	[...];
	void *page;
	struct list_head list;
	[...];
};

In ring_buffer_allocate_cpu:

	struct buffer_page *bpage;
	struct unsigned long addr;

	[...]

	for every page() {
		bpage = kzalloc(sizeof(*bpage), GFP_KERNEL);
		addr = get_free_page();
		bpage->page = (void *)addr;
		list_add(&bpage->list, &cpu_buffer->pages);
	}


Obviously need to add the error checking, but you get the idea. Here I do 
not need to change any of the later logic, because we are still dealing 
with the buffer_page. I only need to update way to index the page which is 
already encapsulated in its own function.

-- Steve


