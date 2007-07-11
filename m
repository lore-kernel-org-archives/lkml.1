Return-Path: <linux-kernel-owner+w=401wt.eu-S933549AbXGKVbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbXGKVbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760339AbXGKVbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:31:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58157 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755134AbXGKVbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:31:05 -0400
Date: Wed, 11 Jul 2007 14:29:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Martin Orr <martin@martinorr.name>
cc: Andi Kleen <andi@firstfloor.org>, Stefano Rivoir <s.rivoir@gts.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
In-Reply-To: <469544D3.90004@martinorr.name>
Message-ID: <alpine.LFD.0.999.0707111410430.20061@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
 <4693327E.6000006@gts.it> <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org>
 <46947ADF.4080605@gts.it> <p73vecrxf0t.fsf@bingen.suse.de>
 <46951892.20406@martinorr.name> <alpine.LFD.0.999.0707111059200.3412@woody.linux-foundation.org>
 <469544D3.90004@martinorr.name>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jul 2007, Martin Orr wrote:

> On 11/07/07 19:01, Linus Torvalds wrote:
> > Can you do
> > 
> > 	make arch/x86_64/kernel/signal.s
> > 
> > with both compilers, and post the results somewhere? It's probably going 
> 
> OK, they are at:
> http://www.srcf.ucam.org/~mpo25/2007/linux-signal/

Ok, do_notify_resume() which inlines the "setup_frame()" code has has been 
totally buggered by the new compiler.

The code is the

        err |= __put_user(0, &frame->uc.uc_flags);
        err |= __put_user(0, &frame->uc.uc_link);
        err |= __put_user(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
        err |= __put_user(sas_ss_flags(regs->rsp),
                          &frame->uc.uc_stack.ss_flags);
        err |= __put_user(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
        err |= setup_sigcontext(&frame->uc.uc_mcontext, regs, set->sig[0], me);
        err |= __put_user(fp, &frame->uc.uc_mcontext.fpstate);

and both compilers do a pretty bad job at this, but at least the old 
compiler generated the errors properly:

-       orl     100(%rsp), %esi # __pu_err, __pu_err
-       orl     96(%rsp), %esi  # __pu_err, __pu_err
-       orl     16(%rsp), %esi  # __pu_err, __pu_err
-       orl     20(%rsp), %esi  # __pu_err, __pu_err
-       orl     24(%rsp), %esi  # __pu_err, __pu_err
-       orl     28(%rsp), %esi  # __pu_err, __pu_err
-       orl     32(%rsp), %esi  # __pu_err, __pu_err
-       orl     36(%rsp), %esi  # __pu_err, __pu_err
-       orl     40(%rsp), %esi  # __pu_err, __pu_err
-       orl     44(%rsp), %esi  # __pu_err, __pu_err
-       orl     48(%rsp), %esi  # __pu_err, __pu_err
-       orl     52(%rsp), %esi  # __pu_err, __pu_err
-       orl     56(%rsp), %esi  # __pu_err, __pu_err
-       orl     60(%rsp), %esi  # __pu_err, __pu_err
-       orl     64(%rsp), %esi  # __pu_err, __pu_err
-       orl     68(%rsp), %esi  # __pu_err, __pu_err
-       orl     72(%rsp), %esi  # __pu_err, __pu_err
-       orl     76(%rsp), %esi  # __pu_err, __pu_err
-       orl     80(%rsp), %esi  # __pu_err, __pu_err
-       orl     84(%rsp), %esi  # __pu_err, __pu_err
-       orl     88(%rsp), %esi  # __pu_err, __pu_err
-       orl     92(%rsp), %esi  # __pu_err, __pu_err

and the new compiler is just incredibly broken:

+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %eax, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err
+       orl     %ecx, %esi      # __pu_err, __pu_err

I don't think this is worth even trying to fix. This is terminal compiler 
breakage. Make a bug-report to the gcc people, the inline asm stuff has 
been totally buggered by that compiler version.

If it mis-compiled that part, it probably miscompiled a lot of other 
things too.

		Linus
