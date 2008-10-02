Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYJBXSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYJBXSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYJBXSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:18:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43466 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbYJBXSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:18:11 -0400
Date: Thu, 2 Oct 2008 19:18:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] ring_buffer: map to cpu not page
In-Reply-To: <20081002093835.GA17699@elte.hu>
Message-ID: <alpine.DEB.1.10.0810021917030.26504@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com> <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins> <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com>
 <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com> <20081002085030.GF26084@elte.hu> <20081002085145.GA3202@elte.hu> <20081002090517.GA8708@elte.hu> <20081002093835.GA17699@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My original patch had a compile bug when NUMA was configured. I
referenced cpu when it should have been cpu_buffer->cpu.

Ingo quickly fixed this bug by replacing cpu with 'i' because that
was the loop counter. Unfortunately, the 'i' was the counter of
pages, not CPUs. This caused a crash when the number of pages allocated
for the buffers exceeded the number of pages, which would usually
be the case.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-tip.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ring_buffer.c	2008-10-02 09:09:01.000000000 -0400
+++ linux-tip.git/kernel/trace/ring_buffer.c	2008-10-02 18:58:44.000000000 -0400
@@ -232,7 +232,7 @@ static int rb_allocate_pages(struct ring
 
 	for (i = 0; i < nr_pages; i++) {
 		page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
-				    GFP_KERNEL, cpu_to_node(i));
+				    GFP_KERNEL, cpu_to_node(cpu_buffer->cpu));
 		if (!page)
 			goto free_pages;
 		list_add(&page->list, &pages);


