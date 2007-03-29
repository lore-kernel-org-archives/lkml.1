Return-Path: <linux-kernel-owner+w=401wt.eu-S965951AbXC2FEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965951AbXC2FEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 01:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965953AbXC2FEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 01:04:14 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60156 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965951AbXC2FEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 01:04:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, luming.yu@intel.com,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Meyer <thomas@m3y3r.de>, Frederic Riss <frederic.riss@gmail.com>,
       Marcus Better <marcus@better.se>
Subject: Re: [patch] MSI-X: fix resume crash
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	<20070328130326.GA27126@elte.hu> <20070328130630.GA28108@elte.hu>
	<200703290030.31228.lenb@kernel.org>
Date: Wed, 28 Mar 2007 22:57:16 -0600
In-Reply-To: <200703290030.31228.lenb@kernel.org> (Len Brown's message of
	"Thu, 29 Mar 2007 00:30:30 -0400")
Message-ID: <m1irckmytv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:

>> Tony, Len the way pci_disable_device is being used in a suspend/resume 
>> path by a few drivers is completely incompatible with the way irqs are 
>> allocated on ia64.  In particular people the following sequence occurs 
>> in several drivers.
>> 
>> probe:
>>   pci_enable_device(pdev);
>>   request_irq(pdev->irq);
>> suspend:
>>   pci_disable_device(pdev);
>> resume:
>>   pci_enable_device(pdev);
>> remove:
>>   free_irq(pdev->irq);
>>   pci_disable_device(pdev);
>
> There are no IA64 machines that support system suspend/resume today --
> so you have 0 chance of breaking the IA64 suspend/resume installed base.

Ok.  So that is why the inconsistency persists...

> My understanding is that Luming Yu has cobbled IA64 S4 support
> together for a future release though.
>
>> What I'm proposing we do is move the irq allocation code out of 
>> pci_enable_device and the irq freeing code out of pci_disable_device in 
>> the future.  If we move ia64 to a model where the irq number equal the 
>> gsi like we have for x86_64 and are in the middle of for i386 that 
>> should be pretty straight forward. It would even be relatively simple  
>> to delay vector allocation in that context until request_irq, if we 
>> needed the delayed allocation benefit.  Do you two have any problems 
>> with moving in that direction?
>
> I think consistency here would be _wonderful_.
> Of course the beauty of having identity GSI=IRQ and a /proc/interrupts
> that tells you what IOAPIC pin you are using become moot with MSI --
> but hey, showing the IRQ number rather than the vector number
> is consistent and makes sense.

Yes.  It also allows for bigger machines.  And I can get a consistent
number out of MSI if we allocate irq numbers in a sufficiently non-sparse
way.  Something like bus|device|func|irq which is 8+5+3+12 or 28 bits...
I'll never get there though if i keep unearthing this long standing bugs.

>> If fixing the arch code is unacceptable for some reason I'm not aware of 
>> we need to audit the 10-20 drivers that call pci_disable_device in their 
>> suspend/resume processing and ensure that they have freed all of the 
>> irqs before that point.  Given that I have bug reports on the msi path I 
>> know that isn't true.
>
> I think the suspend/resume interrupt logic needs some serious attention.
> We've had several schemes for suspend/resume of interrupts, several
> changes in strategy, and right now I think we are inconsistent,
> and frankly, I'm amazed it works at all.

What I have been doing lately is to aim at consistency in how a function
is called (and thus how it is expected to be used) and how it is actually
implemented.  When I have a choice I try to pick a forgiving implementation
so that driver writers don't have to follow a magic correct path for
things to work correctly.  

Removing the irq assignment from pci_enable_device is something that
matches implementation with use.

As for the rest it seems reasonable to me to allow an irq to be held
requested over suspend/resume and to save and restore apic and msi
capability state.  Especially since irq numbers are a kernel
abstraction we should be able to do with them what we need to.

Honestly the whole suspend/resume thing is beyond me at this point I'm
laptop free...  But I do know how to make code consistent with itself.

Eric
