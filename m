Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYGKDWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYGKDWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 23:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYGKDWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 23:22:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41867 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbYGKDWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 23:22:03 -0400
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
	<m1bq15gxml.fsf@frodo.ebiederm.org>
	<20080711023509.GR1678@linux-os.sc.intel.com>
Date: Thu, 10 Jul 2008 20:15:01 -0700
In-Reply-To: <20080711023509.GR1678@linux-os.sc.intel.com> (Suresh Siddha's
	message of "Thu, 10 Jul 2008 19:35:09 -0700")
Message-ID: <m1tzexaz7u.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Suresh Siddha <suresh.b.siddha@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4992]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha <suresh.b.siddha@intel.com> writes:

>> That sounds nice in principle.  I saw cpu cache flushes, I saw writes.
>> I did not see any reads which is necessary to get that behavior with
>> the standard pci transaction rules.
>
> qi_flush_iec() will submit an invalidation descriptor and will wait
> till it finishes the invalidation of the interrupt entry cache.
> qi_submit_sync() will do the job. Descriptor completion ensures that
> the inflight interrupts are flushed.

I will have to look a second time.  It seems I did not see the wait.

>> Having seen enough little races and misbehaving hardware I'm very paranoid
>> about irq migration.  The current implementation is belt and suspenders
>> and I still think there are races that I have missed.
>
> Eric, This process irq migration is done on the cutting edge hardware
> which was designed with all the feedback and experiences in the mind ;)
>
> And also, I don't think we are deviating much from what we are currently doing.
> We are still using cleanup vector etc, to clean up the previous vector
> allocation.

Yes.  In general I think the design appears sound.  I'm just not certain
of the implementation details.  Having spent way to many hours
debugging some very subtle hardware issues, I am paranoid.


>> Sounds good.  Ultimately we are looking at handler_data or chip_data.
>> There are very specific rules that meant I could not use them for
>> the msi data but otherwise I don't remember exactly what the are for.
>> IOMMU are covered though.
>
> IOMMU is covered as part of pci_dev (pci_sysdata). But in the case of
> interrupt-remapping, there are some interrupt resources like ioapics and
> hpet, which don't have the corresponding pci dev. Will take a look at this.
>
>> At least for msi the code you are working on was essentially unified
>> when it was written, it just happened to have two copies.  I don't
>> think I'm asking for heaving lifting.  Mostly just putting code that
>> is touched into something other then the growing monstrosity that is
>> ioapic.c
>
> We can create msi.c which handles MSI specific handling. I will
> look into this. But I def welcome somone beating me in posting those
> patches :) I made a note of this however.

Thanks.  It is all of these little things.  My hope is that we can
whittle down the unshared core instead of increasing the amount of
non-shared code.

>> Further can we please see some better abstractions.  In particular can
>> we generate a token for the irq destination.  And have the msi and
>> ioapic setup read that token and program it into the hardware.  The
>> rules for which bits go where is exactly the same both with and
>> without irq_remapping so having an if statement there seems to obscure
>> what is really happening.  Especially if as it appears that we may be used
>> the new token format with x2apics without remapping.
>
> unfortunately x2apic can't be enabled with out enabling interrupt-remapping.
> Interrupts don't work in majority of the configurations (as I mentioned
> earlier). Programming IOAPIC RTE's and MSI address/data registers are
> completely different based on the presence of interrupt-remapping.

Regardless of the x2apic mode issues there is a different issue here (address better in
another response where I gave an example).

There are a set of architecturally defined bits that can be
programmed.  These same bits exist in the ioapic routing entry and in
the msi message.

Therefore we should have a generic mapping function that says give the architecturally
defined bits.

Then both the ioapic setup and the msi setup can call x86_irq_map(irq) get those
architectural bits and program them in their architecturally defined location.

For MSI it looks like you be able to take advantage of a few more bits, but the
same principle applies.

Getting these intermediate abstractions relatively clean is important so we can do
things with the hardware.

Eric
