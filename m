Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZKST2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZKST2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 14:28:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbZKST2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 14:28:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZKST2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 14:28:01 -0500
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: David Daney <ddaney@caviumnetworks.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
In-Reply-To: <4B05982B.6060200@caviumnetworks.com>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
	 <20091119072040.GA23579@elte.hu>
	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>
	 <1258653562.22249.682.camel@gandalf.stny.rr.com>
	 <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>
	 <4B058CCD.8050605@redhat.com>
	 <alpine.LFD.2.00.0911191039470.2793@localhost.localdomain>
	 <alpine.LFD.2.00.0911191041471.2793@localhost.localdomain>
	 <alpine.LFD.2.00.0911191047350.2793@localhost.localdomain>
	 <4B05982B.6060200@caviumnetworks.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 19 Nov 2009 14:28:06 -0500
Message-Id: <1258658886.22249.874.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 11:10 -0800, David Daney wrote:
> Linus Torvalds wrote:

> For the MIPS port of GCC and Linux I recently added the 
> -mmcount-ra-address switch.  It causes the location of the return 
> address (on the stack) to be passed to mcount in a scratch register.

Hehe, scratch register on i686 ;-)

i686 has no extra regs. It just has:

%eax, %ebx, %ecx, %edx - as the general purpose regs
%esp - stack
%ebp - frame pointer
%edi, %esi - counter regs

That's just 8 regs, and half of those are special.

> 
> Perhaps something similar could be done for x86.  It would make this 
> patching of the return location more reliable at the expense of more 
> code at the mcount invocation site.

I rather not put any more code in the call site.

> 
> For the MIPS case the code size doesn't increase, as it is done in the 
> delay slot of the call instruction, which would otherwise be a nop.

I showed in a previous post what the best would be for x86. That is just
calling mcount at the very beginning of the function. The return address
is automatically pushed onto the stack.

Perhaps we could create another profiler? Instead of calling mcount,
call a new function: __fentry__ or something. Have it activated with
another switch. This could make the performance of the function tracer
even better without all these exceptions.

	<function>:
		call __fentry__
		[...]

	
-- Steve


