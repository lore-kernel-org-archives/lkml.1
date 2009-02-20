Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbZBTESQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbZBTESQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 23:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbZBTER7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 23:17:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062AbZBTER6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 23:17:58 -0500
Date: Thu, 19 Feb 2009 20:17:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
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
In-Reply-To: <alpine.DEB.2.00.0902192254040.29217@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0902192007400.21686@localhost.localdomain>
References: <20090220011316.379904625@goodmis.org> <alpine.LFD.2.00.0902191753240.21686@localhost.localdomain> <alpine.DEB.1.10.0902192107230.31658@gandalf.stny.rr.com> <alpine.LFD.2.00.0902191923300.21686@localhost.localdomain>
 <alpine.DEB.2.00.0902192254040.29217@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Feb 2009, Steven Rostedt wrote:
> 
> Is this something worthy of 29? I could whip up a patch against your 
> latest tree.

I think it's a real issue, but I do have to admit that I don't see why it 
would only trigegr for you. Is it just because the trace stuff ends up 
setting pages to RW, and you have to have had a lot of read-only stuff to 
get a whole read-only PMD to begin with?

So there's two things that make me nervous:

 - I do think the KERNPG_TABLE thing is the right thing, and I _think_ 
   that code is just confused, and we should just do KERNPG_TABLE rather 
   than play with confused bits one by one (PRESENT, RW, NX) to the point 
   of just making for more confusion.

   But I'd like some of the people involved with that code confirm that. 
   Either a "Yeah, we were just confused" or "No, there's this really 
   subtle thing going on, liek this: ..."

 - The fact that apparently you're the first one to hit this. I realize 
   that you do odd things with ftrace. Was it the fact that you made the 
   "set_memory_ro()" area larger, and then more dynamically mark it back 
   to read-write that you hit it? Haven't we done things like that before?

But that said, I'd love to fix this for 2.6.29, especially if somebody 
can resolve the two worries above. I do _not_ want to take your patch that 
makes confused code even more confused, unless somebody really explains 
why a pure KERNPG_TABLE isn't right.

			Linus
