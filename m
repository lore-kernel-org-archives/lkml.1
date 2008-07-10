Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbYGJXCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbYGJXCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 19:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbYGJXCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 19:02:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48504 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbYGJXCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 19:02:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20080710181634.764954000@linux-os.sc.intel.com>
	<m1prplv71d.fsf@frodo.ebiederm.org>
	<20080710211513.GL1678@linux-os.sc.intel.com>
Date: Thu, 10 Jul 2008 15:52:50 -0700
In-Reply-To: <20080710211513.GL1678@linux-os.sc.intel.com> (Suresh Siddha's
	message of "Thu, 10 Jul 2008 14:15:13 -0700")
Message-ID: <m1bq15gxml.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Suresh Siddha <suresh.b.siddha@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4999]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha <suresh.b.siddha@intel.com> writes:

> Flushing the interrupt entry cache will take care of this. We modify the IRTE
> and then flush the interrupt entry cache before cleaning up the original
> vector allocated.
>
> Any new interrupts from the device will see the new entry. Old in flight
> interrupts will be registered at the CPU before the flush of the cache is
> complete.

That sounds nice in principle.  I saw cpu cache flushes, I saw writes.
I did not see any reads which is necessary to get that behavior with
the standard pci transaction rules.

Having seen enough little races and misbehaving hardware I'm very paranoid
about irq migration.  The current implementation is belt and suspenders
and I still think there are races that I have missed.

>> You are sizing an array as NR_IRQS this is something there should be
> sufficient
>> existing infrastructure to avoid.  Arrays sized by NR_IRQS is a significant
>> problem both for scaling the system up and down so ultimately we need to kill
>> this.  For now we should not introduce any new arrays.
>
> Ok. Ideally dynamic_irq_init()/cleanup() can take care of this. or
> create_irq()/destroy_irq() and embed this as a pointer somewhere inside
> irq_desc. I need to take a look at this more closer and post a fix up patch.

Sounds good.  Ultimately we are looking at handler_data or chip_data.
There are very specific rules that meant I could not use them for
the msi data but otherwise I don't remember exactly what the are for.
IOMMU are covered though.

>> A lot of your code is generic, and some of it is for just x86_64.  Since the
>> cpus are capable of running in 32bit mode.  We really need to implement x86_32
>> and x86_64 support in the same code base.  Which I believe means factoring out
>> pieces of io_apic_N.c into things such as msi.c that can be shared between the
>> two architectures.
>
> Yes, As you and Ingo mentioned, there is nothing 64bit specific and one
> can easily add the 32bit support. But before that we need, some more
> x86 unification and I am very short on resources currently :(

At least for msi the code you are working on was essentially unified
when it was written, it just happened to have two copies.  I don't
think I'm asking for heaving lifting.  Mostly just putting code that
is touched into something other then the growing monstrosity that is
ioapic.c

Further can we please see some better abstractions.  In particular can
we generate a token for the irq destination.  And have the msi and
ioapic setup read that token and program it into the hardware.  The
rules for which bits go where is exactly the same both with and
without irq_remapping so having an if statement there seems to obscure
what is really happening.  Especially if as it appears that we may be used
the new token format with x2apics without remapping.

My primary concern is that the end result be well factored irq handling code
so it is possible to get in there and look at the code and maintain it.

A small part of that is the 32bit support.  Another part are the missing
abstractions I described.  I don't know what else since I have barely scratched the surface patch
review wise.

Eric
