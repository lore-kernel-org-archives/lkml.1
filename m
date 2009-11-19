Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbZKSRxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbZKSRxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbZKSRxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:53:23 -0500
Received: from www.tglx.de ([62.245.132.106]:37952 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbZKSRxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:53:22 -0500
Date: Thu, 19 Nov 2009 18:51:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
In-Reply-To: <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911191846350.24119@localhost.localdomain>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain> <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org> <20091119072040.GA23579@elte.hu> <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain> <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain> <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009, Linus Torvalds wrote:
> Umm. But it still does, doesn't it? That
> 
> 	pushl  -0x4(%edi)
> 	push   %ebp
> 
> should do it - the "-0x4(%edi)" thing seems to be trying to reload the 
> return address. No? 
> 
> Maybe I misread the code - but regardless, it does look like a gcc code 
> generation bug if only because we really don't want a 16-byte aligned 
> stack anyway, and have asked for it to not be done.
> 
> So I agree that gcc shouldn't do that crazy prologue (and certainly _not_ 
> before calling mcount anyway), but I'm not sure I agree with that detail 
> of your analysis or explanation.

Yes, it does store the return address before the pushed ebp, but this
is a copy of the real stack entry which is before the pushed edi.

The function graph tracer needs to redirect the return into the tracer
and it therefor saves the real return address and modifies the stack
so the return ends up in the tracer code which then goes back to the
real return address.

But in this prologue/aligment case we modify the copy and not the real
return address on the stack, so we return without calling into the
tracer which is causing the headache because the state of the tracer
becomes confused.

Thanks,

	tglx
