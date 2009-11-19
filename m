Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbZKSR7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbZKSR7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbZKSR7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:59:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbZKSR7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:59:17 -0500
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
In-Reply-To: <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
	 <20091119072040.GA23579@elte.hu>
	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 19 Nov 2009 12:59:22 -0500
Message-Id: <1258653562.22249.682.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 09:39 -0800, Linus Torvalds wrote:

> > This modification leads to a hard to solve problem in the kernel
> > function graph tracer which assumes that the stack looks like:
> > 
> >        return address
> >        saved  ebp
> 
> Umm. But it still does, doesn't it? That
> 
> 	pushl  -0x4(%edi)
> 	push   %ebp
> 
> should do it - the "-0x4(%edi)" thing seems to be trying to reload the 
> return address. No? 

Yes that is what it is doing. The problem we have is that it is putting
into the frame pointer a "copy" of the return address, and not the
actual pointer. Which is fine for the function tracer, but breaks the
function graph tracer (which is a much more powerful tracer).

Technically, this is all that mcount must have. And yes, we are making
an assumption that the return address in the frame pointer is the one
that will be used to leave the function. But the reason for making this
copy just seems to be all messed up.

I don't know if the ABI says anything about the return address in the
frame pointer must be the actual return address. But it would be nice if
the gcc folks would let us guarantee that it is.

-- Steve


