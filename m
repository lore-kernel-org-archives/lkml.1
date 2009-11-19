Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbZKSUoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbZKSUoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 15:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbZKSUoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 15:44:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46351 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770AbZKSUoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:44:20 -0500
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>, Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
In-Reply-To: <alpine.LFD.2.00.0911191227250.2793@localhost.localdomain>
References: <1258653562.22249.682.camel@gandalf.stny.rr.com>
	 <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>
	 <4B058CCD.8050605@redhat.com>
	 <alpine.LFD.2.00.0911191039470.2793@localhost.localdomain>
	 <alpine.LFD.2.00.0911191041471.2793@localhost.localdomain>
	 <alpine.LFD.2.00.0911191047350.2793@localhost.localdomain>
	 <4B05982B.6060200@caviumnetworks.com>
	 <1258658886.22249.874.camel@gandalf.stny.rr.com>
	 <20091119194625.GE4967@nowhere>
	 <1258661141.22249.962.camel@gandalf.stny.rr.com>
	 <20091119202526.GG4967@nowhere>
	 <alpine.LFD.2.00.0911191227250.2793@localhost.localdomain>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 19 Nov 2009 15:44:24 -0500
Message-Id: <1258663464.22249.999.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 12:36 -0800, Linus Torvalds wrote:
> 
> On Thu, 19 Nov 2009, Frederic Weisbecker wrote:
> >
> > > That way the lr would have the current function, and the parent would
> > > still be at 8(%sp)
> > 
> > Yeah right, we need at least such very tiny prologue for
> > archs that store return addresses in a reg.
> 
> Well, it will be architecture-dependent.

Totally agree, as mcount today is architecture dependent.

> 
> For example, alpha can store the return value in _any_ register if I 
> recall correctly, so you can do the "call to __fentry__" by just picking 
> another register than the default one as the return address.
> 
> And powerpc has two special registers: link and ctr, but iirc you can only 
> load 'link' with a branch instruction. Which means that you could do 
> something like 
> 
> 	mflr 0
> 	bl __fentry__
> 
> in the caller (I forget if R0 is actually a call-trashed register or not), 
> and then __fentry__ could do something like
> 
> 	mflr 12		# save _new_ link
> 	mtlr 0		# restore original link
> 	mtctr 12	# move __fentry__ link to ctr
> 	.. do whatever ..
> 	bctr		# return to __fentry__ caller
> 
> to return with 'link' restored (but ctr and r0/r12 trashed - I don't 
> recall the ppc calling conventions any more, but I think that is ok).
> 
> Saving to stack seems unnecessary and pointless.

I was just using an example. But as you pointed out, each arch can find
its best way to handle it. Having the profiler called at the beginning
of the function is what I feel is the best.

We also get access to the function's parameters :-)


-- Steve


