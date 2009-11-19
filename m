Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbZKSTqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbZKSTqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 14:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbZKSTqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 14:46:23 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:36858 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbZKSTqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 14:46:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KEhVmiQdTOcVRg0jpjXi+ZypbfPGt0AJNKAWc96Gx5VFng4rvasB/s0QYZHqop37gf
         nPnpevOWqaPS3sVgbXlD90HcX84ocfqOztWRnL0/Av/PW5pY5UAP+HQRzQpDZt4sn+Ns
         Zy0chUNDCT/TxNYH/BjYsqLzJDXuUSiwgMF18=
Date: Thu, 19 Nov 2009 20:46:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
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
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
Message-ID: <20091119194625.GE4967@nowhere>
References: <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain> <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain> <1258653562.22249.682.camel@gandalf.stny.rr.com> <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com> <4B058CCD.8050605@redhat.com> <alpine.LFD.2.00.0911191039470.2793@localhost.localdomain> <alpine.LFD.2.00.0911191041471.2793@localhost.localdomain> <alpine.LFD.2.00.0911191047350.2793@localhost.localdomain> <4B05982B.6060200@caviumnetworks.com> <1258658886.22249.874.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258658886.22249.874.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 02:28:06PM -0500, Steven Rostedt wrote:
> On Thu, 2009-11-19 at 11:10 -0800, David Daney wrote:
> > Linus Torvalds wrote:
> 
> > For the MIPS port of GCC and Linux I recently added the 
> > -mmcount-ra-address switch.  It causes the location of the return 
> > address (on the stack) to be passed to mcount in a scratch register.
> 
> Hehe, scratch register on i686 ;-)
> 
> i686 has no extra regs. It just has:
> 
> %eax, %ebx, %ecx, %edx - as the general purpose regs
> %esp - stack
> %ebp - frame pointer
> %edi, %esi - counter regs
> 
> That's just 8 regs, and half of those are special.
> 
> > 
> > Perhaps something similar could be done for x86.  It would make this 
> > patching of the return location more reliable at the expense of more 
> > code at the mcount invocation site.
> 
> I rather not put any more code in the call site.
> 
> > 
> > For the MIPS case the code size doesn't increase, as it is done in the 
> > delay slot of the call instruction, which would otherwise be a nop.
> 
> I showed in a previous post what the best would be for x86. That is just
> calling mcount at the very beginning of the function. The return address
> is automatically pushed onto the stack.
> Perhaps we could create another profiler? Instead of calling mcount,
> call a new function: __fentry__ or something. Have it activated with
> another switch. This could make the performance of the function tracer
> even better without all these exceptions.
> 
> 	<function>:
> 		call __fentry__
> 		[...]
> 
> 	
> -- Steve


I would really like this. So that we can forget about other possible
further suprises due to sophisticated function prologues beeing before
the mcount call.

And I guess that would fix it in every archs.

That said, Linus had a good point about the fact there might other uses
of mcount even more tricky than what does the function graph tracer,
outside the kernel, and those may depend on the strict ABI assumption
that 4(ebp) is always the _real_ return address, and that through all
the previous stack call. This is even a concern that extrapolates the
single mcount case.

So I wonder that actually the real problem is the lack of something that
could provide this guarantee. We may need a -real-ra-before-fp (yeah
I suck in naming).

