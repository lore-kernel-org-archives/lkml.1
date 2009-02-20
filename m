Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZBTEeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZBTEeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 23:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbZBTEeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 23:34:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47216 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZBTEeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 23:34:08 -0500
Date: Thu, 19 Feb 2009 23:34:06 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Huang Ying <ying.huang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] changes for tip, and a nasty x86 page table bug 
In-Reply-To: <alpine.LFD.2.00.0902192007400.21686@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0902192322240.29217@gandalf.stny.rr.com>
References: <20090220011316.379904625@goodmis.org> <alpine.LFD.2.00.0902191753240.21686@localhost.localdomain> <alpine.DEB.1.10.0902192107230.31658@gandalf.stny.rr.com> <alpine.LFD.2.00.0902191923300.21686@localhost.localdomain>
 <alpine.DEB.2.00.0902192254040.29217@gandalf.stny.rr.com> <alpine.LFD.2.00.0902192007400.21686@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 19 Feb 2009, Linus Torvalds wrote:
> 
> On Thu, 19 Feb 2009, Steven Rostedt wrote:
> > 
> > Is this something worthy of 29? I could whip up a patch against your 
> > latest tree.
> 
> I think it's a real issue, but I do have to admit that I don't see why it 
> would only trigegr for you. Is it just because the trace stuff ends up 
> setting pages to RW, and you have to have had a lot of read-only stuff to 
> get a whole read-only PMD to begin with?

The PMD read only has been there before ftrace. Setting the 
CONFIG_DEBUG_RODATA causes the issue. After the the 2M page is set to read 
only, the change to set the NX bits for the data section creates the PMD 
with the read write bit cleared.

The thing I do differently was that I needed to modify the text section
after this has been set. ftrace does a mass change upon user request, so 
the simple thing was to enable the pages as read-write, modify, then set 
back to read only.

Other code (kprobes and such) uses text_poke to make their changes. This 
goes through the process of creating vmalloc areas to point to the 
necessary code to change. The kernel proper page tables are not touched. 
So basically, it does a back door to make the change. This avoids the bug 
by not needing to convert those PTEs protected by a read only PMD into 
read-write pages.

I hit the bug by trying to write to the addresses protected by the
read only PMD.

> 
> So there's two things that make me nervous:
> 
>  - I do think the KERNPG_TABLE thing is the right thing, and I _think_ 
>    that code is just confused, and we should just do KERNPG_TABLE rather 
>    than play with confused bits one by one (PRESENT, RW, NX) to the point 
>    of just making for more confusion.

I agree with you here. I just did this change on my local tree and my code 
still works.

> 
>    But I'd like some of the people involved with that code confirm that. 
>    Either a "Yeah, we were just confused" or "No, there's this really 
>    subtle thing going on, liek this: ..."
> 
>  - The fact that apparently you're the first one to hit this. I realize 
>    that you do odd things with ftrace. Was it the fact that you made the 
>    "set_memory_ro()" area larger, and then more dynamically mark it back 
>    to read-write that you hit it? Haven't we done things like that before?

No, I was just the first one to try to convert these pages back to rw and
write to them.

> 
> But that said, I'd love to fix this for 2.6.29, especially if somebody 
> can resolve the two worries above. I do _not_ want to take your patch that 
> makes confused code even more confused, unless somebody really explains 
> why a pure KERNPG_TABLE isn't right.

OK, agreed. I'll wait on Thomas et.al. for a response, and let me get to 
bed.

-- Steve

