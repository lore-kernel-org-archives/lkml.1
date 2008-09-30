Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbYI3QkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbYI3QkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYI3QkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:40:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337AbYI3QkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:40:07 -0400
Date: Tue, 30 Sep 2008 09:38:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Jonathan Corbet <corbet@lwn.net>, Steven Rostedt <rostedt@goodmis.org>,
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
In-Reply-To: <1222790072.24384.21.camel@twins>
Message-ID: <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org>
References: <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com> 
 <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809291202180.5493@gandalf.stny.rr.com>  <20080929233539.GA31143@Krystal>  <alpine.DEB.1.10.0809292000160.8145@gandalf.stny.rr.com>  <20080930000307.GA2929@Krystal> 
 <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com>  <20080930034603.GA13801@Krystal>  <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com>  <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Sep 2008, Peter Zijlstra wrote:
> 
> Its not that complex IMHO, the thing that is ugly are those struct page
> overloads, what we could do is try and sanitize the regular struct page
> and pull all these things in.

That's not the scary part. The scary part is that somebody may well want 
to access the trace buffer pages in complex ways.

If you mmap them, for example, you can use VM_PFNMAP to make sure that 
nobody should ever look at the "struct page", but if you want to do things 
like direct-to-disk IO on the trace pages (either with splice() or with 
some kind of in-kernel IO logic), then you're officially screwed.

> Because the only reason people are doing these overloads is because
> struct page in mm_types.h is becomming an unreadable mess.

The "unreadable mess" has exactly the same issues, though: people need to 
realize that when you overload fields in the page structure, you can then 
NEVER EVER use those pages for any other thing. 

For the internal VM code, that's ok. The VM knows that a page is either an 
anonymous page or a file mapping etc, and the overloading wrt mm_types.h 
is explicit. The same goes for SL*B, although it does the overloading 
differently.

Trace buffers are different, though. Do people realize that doing the 
overloading means that you never EVER can use those buffers for anything 
else? Do people realize that it means that splice() and friends are out of 
the question?

> Trouble is, looking at it I see no easy way out,

Quite frankly, we could just put it at the head of the page itself. Having 
a "whole page" for the trace data is not possible anyway, since the trace 
header itself will always eat 8 bytes.

And I do think it would potentially be a better model. Or at least safer.

			Linus
