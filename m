Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbZKHTGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbZKHTGY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 14:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZKHTGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 14:06:24 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:33738 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbZKHTGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 14:06:23 -0500
Date: Sun, 8 Nov 2009 19:06:19 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: Ingo Molnar <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "garyhade@us.ibm.com" <garyhade@us.ibm.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Sankaran, Rajesh" <rajesh.sankaran@intel.com>
Subject: Re: [tip:x86/apic] x86: Use EOI register in io-apic on intel
 platforms
In-Reply-To: <1257578870.2536.52.camel@sbs-t61>
Message-ID: <alpine.LFD.2.00.0911081814540.9725@eddie.linux-mips.org>
References: <20091026230001.947855317@sbs-t61.sc.intel.com>  <tip-b3ec0a37a7907813bb4fb85a2d94102c152470b7@git.kernel.org>  <alpine.LFD.2.00.0911040038460.9725@eddie.linux-mips.org>  <1257301490.2668.280.camel@sbs-t61.sc.intel.com> 
 <1257375875.4716.24.camel@sbs-t61.sc.intel.com>  <alpine.LFD.2.00.0911051415340.9725@eddie.linux-mips.org>  <1257465692.4394.295.camel@sbs-t61.sc.intel.com>  <alpine.LFD.2.00.0911060623390.9725@eddie.linux-mips.org> <1257578870.2536.52.camel@sbs-t61>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009, Suresh Siddha wrote:

> >  What I mean is if the serial delivery type is used, then an interrupt 
> > will be acked twice -- once via an EOI message sent from the local APIC 
> > over the serial bus and then again via the write to the EOI register.  
> 
> Maciej, Case where we are doing an explicit EOI to the io-apic (using
> EOI register) is when the level triggered interrupt gets registered at
> the cpu as an edge interrupt (in the local apic's trigger mode
> register).
> 
> It will arrive as an edge interrupt for two cases.
> a) for corner conditions which hit the 82093AA (io-apic version 0x11)
> erratum
> b) with my recent patch in -tip, during a cpu offline, when we send an
> ipi (IPI is always registered as an edge triggered at the cpu) to
> service the interrupt at the new cpu destination, instead of servicing
> at it's old destination cpu (as it has already disabled interrupts and
> going down -- like not being on the cpu_online_map etc).
> 
> So we are not acking the io-apic twice in this case, as the eoi to the
> local apic won't brodcast the eoi to the io-apic (because of the edge
> mode in trigger mode register of the local apic).

 OK, I see what you mean, but that makes me wonder why you are going 
through such contortions.  In the case of a CPU going offline I would 
expect it to be done more or less in such a way:

1. Write all-zeroes to its local APIC's LDR register and set its TPR to 
   0xef.  This will take this APIC out from LoPri arbitration and thus 
   from accepting any I/O APIC interrupts.  Fixed delivery mode IPIs will 
   still be accepted (if that's not needed then the TPR can be set to 
   0xff; any received IPIs will be lost).

2. Service any outstanding interrupts that have already been accepted by 
   the local APIC (you may have to poll on the local IRR register with 
   interrupts enabled for a short while).

3. Disable the local APIC via the SVR register, mask local interrupts in 
   the processor's EFLAGS register and start the offline procedure.  This 
   is the point of no-return, further IPIs won't be accepted and the CPU 
   has to be put through an INIT-IPI+StartUp-IPI cycle to get in control 
   again.

   If IPI reception was not needed through stage #2 above, then the local 
   APIC could have been disabled at #1 instead -- interrupts pending in 
   the local APIC as recorded in the IRR or marked as in-progress in the 
   ISR are guaranteed to be delivered to the CPU and EOIed (as 
   appropriate) normally even in the disabled state of the local APIC.

> Do you agree?

 If the scenario I have outlined above cannot be made to work for some 
reason, then please do me and the others a favour and since with this 
change you are tying new functionality to code originally meant as a 
workaround for an obscure erratum only, do write a proper explanation and 
place it next to the original comment describing previous use of the code. 
With your change as it is, it is all but obvious what this piece of code 
is meant to do.

 Your change is OK with me once accompanied with said comment, but please 
investigate my scenario first -- your approach looks like a horrible hack 
to me, sorry.

  Maciej
