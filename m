Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbZLBA5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbZLBA5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 19:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbZLBA5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 19:57:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:26979 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943AbZLBA5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 19:57:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,324,1257148800"; 
   d="scan'208";a="472050371"
Subject: Re: [tip:x86/apic] x86: Use EOI register in io-apic on intel
 platforms
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "garyhade@us.ibm.com" <garyhade@us.ibm.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Sankaran, Rajesh" <rajesh.sankaran@intel.com>
In-Reply-To: <alpine.LFD.2.00.0911081814540.9725@eddie.linux-mips.org>
References: <20091026230001.947855317@sbs-t61.sc.intel.com>
	 <tip-b3ec0a37a7907813bb4fb85a2d94102c152470b7@git.kernel.org>
	 <alpine.LFD.2.00.0911040038460.9725@eddie.linux-mips.org>
	 <1257301490.2668.280.camel@sbs-t61.sc.intel.com>
	 <1257375875.4716.24.camel@sbs-t61.sc.intel.com>
	 <alpine.LFD.2.00.0911051415340.9725@eddie.linux-mips.org>
	 <1257465692.4394.295.camel@sbs-t61.sc.intel.com>
	 <alpine.LFD.2.00.0911060623390.9725@eddie.linux-mips.org>
	 <1257578870.2536.52.camel@sbs-t61>
	 <alpine.LFD.2.00.0911081814540.9725@eddie.linux-mips.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 01 Dec 2009 16:56:07 -0800
Message-Id: <1259715367.3709.53.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej,

Sorry for delayed response. I was busy with other stuff and didn't get a
chance till now to get back on this. I just posted few patches which
came up as a result of our past discussions here in this thread.

Please see my responses inline for your earlier comments:

On Sun, 2009-11-08 at 11:06 -0800, Maciej W. Rozycki wrote:
> OK, I see what you mean, but that makes me wonder why you are going 
> through such contortions.  In the case of a CPU going offline I would 
> expect it to be done more or less in such a way:
> 
> 1. Write all-zeroes to its local APIC's LDR register and set its TPR to 
>    0xef.  This will take this APIC out from LoPri arbitration and thus 
>    from accepting any I/O APIC interrupts.  Fixed delivery mode IPIs will 
>    still be accepted (if that's not needed then the TPR can be set to 
>    0xff; any received IPIs will be lost).
> 
> 2. Service any outstanding interrupts that have already been accepted by 
>    the local APIC (you may have to poll on the local IRR register with 
>    interrupts enabled for a short while).
> 
> 3. Disable the local APIC via the SVR register, mask local interrupts in 
>    the processor's EFLAGS register and start the offline procedure.  This 
>    is the point of no-return, further IPIs won't be accepted and the CPU 
>    has to be put through an INIT-IPI+StartUp-IPI cycle to get in control 
>    again.
> 
>    If IPI reception was not needed through stage #2 above, then the local 
>    APIC could have been disabled at #1 instead -- interrupts pending in 
>    the local APIC as recorded in the IRR or marked as in-progress in the 
>    ISR are guaranteed to be delivered to the CPU and EOIed (as 
>    appropriate) normally even in the disabled state of the local APIC.

But before these 3 steps you listed here, we need to migrate the irq to
the new destination. And that step will modify the IO-APIC RTE with the
new vector and new destination. And during this process, remoteIRR of
the IO-APIC RTE might be set and this inflight interrupt will get
registered at the original destination that is going offline.

So when we come to step 2 you listed above and service any outstanding
interrupts, EOI broadcast as part of that handling won't clear the
remoteIRR of the IO-APIC RTE, as the vector information in the io-apic
RTE got modified because of irq migration and is different from the
vector information in EOI broadcast message sent by the cpu. This will
result in stuck level interrupt.

This is one of the challenges Eric Biederman had in the past and he
tried things like polling from the process context and modifying the
IO-APIC RTE (with new destination and vector information) only when the
remoteIRR is not set etc. But Eric still saw some hangs and stuck
interrupt conditions with his experimental patches.

We took a route which needed minor changes to the existing code and fix
the local_irq_enable()/local_irq_disable() issue and stuck interrupt
issue in the cpu offline path by using the IO-APIC EOI register. Our
tests on Intel platforms having an EOI register for io-apic's and IBM's
(Gary) tests on io-apic's which don't have EOI register using AMD
platforms worked fine with our approach.

> > Do you agree?
> 
>  If the scenario I have outlined above cannot be made to work for some 
> reason, 

Perhaps we can make it work but it needs more changes and validation.
And atleast Eric's similar experiments in the past didn't yield good
results.

> then please do me and the others a favour and since with this 
> change you are tying new functionality to code originally meant as a 
> workaround for an obscure erratum only, do write a proper explanation and 
> place it next to the original comment describing previous use of the code. 
> With your change as it is, it is all but obvious what this piece of code 
> is meant to do.

This patch was also in the series that I just sent.

>  Your change is OK with me once accompanied with said comment, but please 
> investigate my scenario first -- your approach looks like a horrible hack 
> to me, sorry.

This being a fragile area and considering our experiences in the past, I
leveraged the existing code (of clearing remoteIRR manually on ioapic's
which don't have an EOI register) and luckily we had good success so
far.

thanks,
suresh

