Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbZIAR4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbZIAR4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 13:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZIAR4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 13:56:52 -0400
Received: from relais.videotron.ca ([24.201.245.36]:18554 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbZIAR4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 13:56:51 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 01 Sep 2009 13:56:17 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       venki kaps <venkiece2005@gmail.com>,
       "sagar.abhishek@gmail.com" <sagar.abhishek@gmail.com>,
       "jkenisto@us.ibm.com" <jkenisto@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "prasanna@in.ibm.com" <prasanna@in.ibm.com>
Subject: Re: ARM + jprobes/kretprobes SEGV/hangs/OOPS in 2.6.29 kernel
In-reply-to: <1251816239.10349.66.camel@pc1117.cambridge.arm.com>
Message-id: <alpine.LFD.2.00.0909011347470.6044@xanadu.home>
References: <6d53329e0908250342g2cfb73f6v90f73c283c0d391c@mail.gmail.com>
 <alpine.LFD.2.00.0908251333410.6044@xanadu.home>
 <6d53329e0908302227l63420351m1005d0c76346e2ec@mail.gmail.com>
 <6d53329e0908310311v55ef3909na0cbec756e63ccab@mail.gmail.com>
 <6d53329e0908312355y7bd2038ds6ba8efe671d98bc9@mail.gmail.com>
 <tnxocpu7osx.fsf@pc1117.cambridge.arm.com>
 <20090901142549.GA21501@flint.arm.linux.org.uk>
 <1251816239.10349.66.camel@pc1117.cambridge.arm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009, Catalin Marinas wrote:

> On Tue, 2009-09-01 at 15:25 +0100, Russell King wrote:
> > On Tue, Sep 01, 2009 at 02:54:54PM +0100, Catalin Marinas wrote:
> > > venki kaps <venkiece2005@gmail.com> wrote:
> > > > I have found the exact problem with respect to ARM jprobes.
> > > >
> > > > The problem with configure i.e, CONFIG_ARM_UNWIND = y; is enabled.
> > > 
> > > I haven't followed the kprobes implementation for ARM but does it make
> > > any assumptions about the existence of a frame pointer on the stack?
> > > Enabling stack unwinding automatically disables the framepointer.
> > 
> > If it uses CALLER_ADDRESSx() then it won't work with unwinding enabled.
> > See 5613/1 (which is pending in the devel branch.)
> 
> In addition to that, when CONFIG_FRAME_POINTER is disabled, the lr
> register isn't always saved on the stack by the called function. I'm not
> sure whether kretprobe_trampoline is aware of this.

The way a kretprobe works is to put a trap at the very first instruction 
of the targetted function, preserve the value of LR when the trap is 
hit, and substitute it with the address of kretprobe_trampoline.  Then 
the original first instruction is emulated to pass over the trap point 
and normal execution is resumed.  So whether or not LR is then saved on 
the stack doesn't matter to kretprobe_trampoline as it will restore the 
LR value saved during the initial trap.

Of course if you end up generating a backtrace within a kretprobed 
function then the result might look funny.


Nicolas
