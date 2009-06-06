Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbZFFBWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbZFFBWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 21:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbZFFBV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 21:21:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:20638 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbZFFBVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 21:21:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,313,1241420400"; 
   d="scan'208";a="464007833"
Subject: Re: [patch] x64: Avoid irq_chip mask/unmask in fixup_irqs for
 interrupt-remapping
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "travis@sgi.com" <travis@sgi.com>, "steiner@sgi.com" <steiner@sgi.com>,
       Gary Hade <garyhade@us.ibm.com>
In-Reply-To: <m1vdnb4fki.fsf@fess.ebiederm.org>
References: <1244141989.27006.10369.camel@localhost.localdomain>
	 <m1iqjbd243.fsf@fess.ebiederm.org>
	 <1244164694.27006.10374.camel@localhost.localdomain>
	 <1244164783.27006.10375.camel@localhost.localdomain>
	 <m1vdnb4fki.fsf@fess.ebiederm.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 05 Jun 2009 18:19:30 -0700
Message-Id: <1244251170.27006.10537.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-04 at 18:47 -0700, Eric W. Biederman wrote:
> As far as this patch goes it looks like an improvement.
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Thanks. Ingo, Peter: Can you please queue this patch? Eric, more
comments below.

> However after looking at Gary's issues I see some things that are still wrong
> on this path.
> 
> 1) We don't do the part of irq migration that moves irq threads.
>    We aren't using irq threads yet but still
> 

Ok. Will look at the irq threads code (-rt tree?).

>    If we could figure out how to call irq_set_affinity for the IRQ_MOVE_PCNTXT
>    code path that would make the maintenance a lot simpler.

Ok. Will post this cleanup sometime.

> 
> 2) We still diverge on 32bit vs 64bit for no reason.
>    I expect the fixed 64bit version should be moved into apic/io_apic.c

Agree.

> 
> 3) We still enable irqs for a short while after this to let things drain.
>    I am wondering if that is really necessary.    It does very simply
>    allow the irq cleanup ipi to happen, and it unjams any irqs that happened
>    before we migrated them.

Yes.

>    If we wanted to very strictly follow the rules I guess we could do something
>    like the cleanup_ipi by hand on the cpu that is going down and rebroadcast
>    all of the pending irqs to another cpu to process.
> 

This will be ok for all the cases except the most difficult case (non
interrupt-remapping and IO-APIC level triggered). We should service the
pending interrupt from the same cpu 'X' (that is going down) because of
the vector information (that is cpu 'X' specific) in the IO-APIC RTE.
Otherwise we have to do directed EOI ( and I am not sure if all the
IO-APIC's support that) to the io-apic.

Is there a problem with enabling irqs in the fixup_irqs()?

My old proposal (which will fix the stuck IRR issue seen by Gary) for
fixing the level irq migration in fixup_irqs() is to do something like:

Disable interrupts
..
Mask io-apic RTE
check if the IRR is set
if so,
   unmask the io-apic RTE
   enable interrupts
   and go back to top
else
   ok to migrate the io-apic rte.

So if there is any other reason for keeping the interrupts disabled
during fixup_irqs(), then we need to think of another strategy to
address this.

Otherwise, If everyone agrees with this direction then we can try to
comeup with a clean patch for this.

thanks,
suresh

