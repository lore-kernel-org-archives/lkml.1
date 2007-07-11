Return-Path: <linux-kernel-owner+w=401wt.eu-S1760231AbXGKQvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231AbXGKQvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbXGKQvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:51:10 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:4641 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbXGKQvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:51:08 -0400
Date: Wed, 11 Jul 2007 17:51:05 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Songmao Tian <tiansm@lemote.com>
cc: LinuxBIOS Mailing List <linuxbios@linuxbios.org>, marc.jones@amd.com,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: about cs5536 interrupt ack
In-Reply-To: <Pine.LNX.4.64N.0707111634430.26459@blysk.ds.pg.gda.pl>
Message-ID: <Pine.LNX.4.64N.0707111729310.26459@blysk.ds.pg.gda.pl>
References: <4694A495.1050006@lemote.com> <Pine.LNX.4.64N.0707111347360.26459@blysk.ds.pg.gda.pl>
 <4694F4EB.8040000@lemote.com> <Pine.LNX.4.64N.0707111634430.26459@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Maciej W. Rozycki wrote:

> > > You can still dispatch interrupts manually by examining the IRR register,
> > > but having a way to ask the 8259A's prioritiser would be nice.  Although
> > > given such a lethal erratum you report I would not count on the prioritiser
> > > to provide any useful flexibility...
> > >   
> > yeah, that's a straight thought, tried but failed:(, patch followed.
> 
>  You may have to modify other functions from arch/mips/kernel/i8259.c; 
> yes, this makes the whole experience not as pretty as one would hope...

 BTW, have you considered skipping the whole 8259A legacy burden and using 
the interrupt mapper directly?  From a brief look at the datasheet I 
conclude you should be able to OR all the interrupt lines to a single 
8259A input (say IRQ0 for the sake of this consideration -- it does not 
matter), set it to the level triggered mode, mask all the 8259A inputs but 
this one and ignore the device from then on.

 It would work as a "virtual wire", using the Intel's terminology, with 
its INT output simply following its IR0 input.  You can type:

$ grep '8259A Virtual Wire' arch/i386/kernel/io_apic.c

for a reference; ;-) you can skip the AEOI setup as in a system based on a 
MIPS processor an INTA cycle will be unlikely to reach the 8259A by 
accident (which may happen in the wild world of broken PCs) -- which you 
have learnt the hard way by now already.

 You can then dispatch interrupts based on the interrupt mapper registers 
which has this nice side effect of much of the sharing having been 
removed.  It will not work with edge-triggered interrupts, but you do not 
need that 8254 timer, do you?

  Maciej
