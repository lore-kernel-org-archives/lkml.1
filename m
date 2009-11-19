Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZKSUFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZKSUFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 15:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbZKSUFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 15:05:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44641 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494AbZKSUFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:05:36 -0500
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
In-Reply-To: <20091119194625.GE4967@nowhere>
References: <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>
	 <1258653562.22249.682.camel@gandalf.stny.rr.com>
	 <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>
	 <4B058CCD.8050605@redhat.com>
	 <alpine.LFD.2.00.0911191039470.2793@localhost.localdomain>
	 <alpine.LFD.2.00.0911191041471.2793@localhost.localdomain>
	 <alpine.LFD.2.00.0911191047350.2793@localhost.localdomain>
	 <4B05982B.6060200@caviumnetworks.com>
	 <1258658886.22249.874.camel@gandalf.stny.rr.com>
	 <20091119194625.GE4967@nowhere>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 19 Nov 2009 15:05:41 -0500
Message-Id: <1258661141.22249.962.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 20:46 +0100, Frederic Weisbecker wrote:
> On Thu, Nov 19, 2009 at 02:28:06PM -0500, Steven Rostedt wrote:

> > 	<function>:
> > 		call __fentry__
> > 		[...]
> > 
> > 	
> > -- Steve
> 
> 
> I would really like this. So that we can forget about other possible
> further suprises due to sophisticated function prologues beeing before
> the mcount call.
> 
> And I guess that would fix it in every archs.

Well, other archs use a register to store the return address. But it
would also be easy to do (pseudo arch assembly):

	<function>:
		mov lr, (%sp)
		add 8, %sp
		blr __fentry__
		sub 8, %sp
		mov (%sp), lr


That way the lr would have the current function, and the parent would
still be at 8(%sp)

		
> 
> That said, Linus had a good point about the fact there might other uses
> of mcount even more tricky than what does the function graph tracer,
> outside the kernel, and those may depend on the strict ABI assumption
> that 4(ebp) is always the _real_ return address, and that through all
> the previous stack call. This is even a concern that extrapolates the
> single mcount case.

As I am proposing a new call. This means that mcount stay as is for
legacy reasons. Yes I know there exists the -finstrument-functions but
that adds way too much bloat to the code. One single call to the
profiler is all I want.


> 
> So I wonder that actually the real problem is the lack of something that
> could provide this guarantee. We may need a -real-ra-before-fp (yeah
> I suck in naming).

Don't worry, so do the C compiler folks, I mean, come on "mcount"?

-- Steve


