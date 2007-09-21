Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbXIUQxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbXIUQxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 12:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbXIUQxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 12:53:05 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:54747 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbXIUQxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:53:04 -0400
Date: Fri, 21 Sep 2007 17:52:56 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Peter Fordham <peter.fordham@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: fpu IO port reservation (arch/i386)
In-Reply-To: <p73y7f07zuz.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64N.0709211724470.2724@blysk.ds.pg.gda.pl>
References: <a71b7b480709210622l23481221pd09302a827b55eb@mail.gmail.com>
 <Pine.LNX.4.64N.0709211440380.2724@blysk.ds.pg.gda.pl> <p73y7f07zuz.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Andi Kleen wrote:

> >  There are two ports used: 0xf0 is the busy latch reset and 0xf1 is the 
> > coprocessor reset.  They are legacy ports resulting from the interesting 
> > way the FPU has been wired by IBM in their PC design. 
> 
> Was it really needed on 386s? I didn't think there was a IBM 386 PC.

 That comes back from the 80286-based original PC/AT and was carried over 
to the 80386 by cloners (and then the i486 and further by Intel itself, 
forced by the market).

 A way to reset the FPU was required by the 80287 part when switching back 
from the protected mode similarly to the 80286.  Like the CPU which had no 
way to clear the MSW.PE bit in software (obscure stuff of LOADALL aside; 
;-) and LMSW carried it over to the 80386 and further for compatibility), 
the FPU had no counterpart to the FSETPM instruction that was used to 
switch to the different internal address format used by the FPU in the 
protected mode (FRSTPM was only introduced to a newer 287 variation, long 
after the original PC/AT).  Note that the 80287 can be used in conjunction 
with the 80386, so some of this black magic may even apply to Linux.

 The busy latch had to be used (and cleared explicitly) because of the 
violation of the FPU exception signalling protocol as the PC/AT 
incorrectly wired the FPU error output line to IRQ 13 rather than the CPU 
error input.  This was done because IBM reused the interrupt vector range 
reserved by Intel for exception handling for hardware interrupts and (in 
this case) some of their BIOS calls.  Unfortunately, in their infinite 
wisdom, the responsible people in IBM provided no way to switch exception 
signalling in the PC/AT to the native mode (for use in the protected mode 
if nothing else).  This, too, was carried over to the 80386 and only 
sorted out by the CR0.NE bit in the i486.

 For the curious the details of all the hassle are reasonably well 
described in the Intel's AP-578 application note.

  Maciej
