Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbYGKJCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbYGKJCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbYGKJCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:02:06 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45507 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbYGKJCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:02:05 -0400
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
	<20080710182239.205057000@linux-os.sc.intel.com>
	<m1fxqhdxji.fsf@frodo.ebiederm.org>
	<20080711060714.GT1678@linux-os.sc.intel.com>
Date: Fri, 11 Jul 2008 01:59:24 -0700
In-Reply-To: <20080711060714.GT1678@linux-os.sc.intel.com> (Suresh Siddha's
	message of "Thu, 10 Jul 2008 23:07:15 -0700")
Message-ID: <m1hcawaj9v.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Suresh Siddha <suresh.b.siddha@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2421]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch 23/26] x64, x2apic/intr-remap: MSI and MSI-X support for interrupt remapping infrastructure
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha <suresh.b.siddha@intel.com> writes:

>> 
>> Can we simplify this a little.  In particular have a function
>> 
>> struct IOAPIC_ROUTE_entry x86_map_irq(irq, mask);
>> 
>> Where x86_map_irq would ultimately figure out the path to the cpu.
>> In the simple case it would just call assign_irq_vector();
>> When irqs are remapped it would perform the additional
>
> But we already know that the irq's are remapped, as we are using different
> irq_chip's when irq's are remapped.
>
>> map_irq_to_irte_handle();
>> modify_irte(irq, &irte);
>> 
>> And then have the generic msi code and the ioapic code.
>> Map from the struct IOAPIC_ROUTE_entry or whatever to the appropriate bits for
> the hardware
>> they control.
>> 
>> That should allows us a lot more flexibility going forward with less code then
> is in your
>> patches.
>
> Are you talking about the setup code or the migration code? Because in migration
> code, we don't even touch MSI/IO-apic devices (for edge atleast) and we
> already use different irq_chip's for that.

I guess I was looking at the setup code.

At any rate the way the code is currently factored does not lend itself easily
to adding another iommu, and things that could be common aren't so maintenance
is harder then it should be.  If we continue on the current path I'm scared
of what that code will look like when we add Xen, VMware, kvm, lguest, and
AMD iommu support in the coming months.

ppc64 and sparc64 seem to have a subarch model where the chipset and
cpu capabilities are pretty standard.  Unfortunately x86 (as usual)
looks like it will become much more pick and choose so I don't think
we can just reuse any of the techniques those other architectures have
done.

What I am ultimately looking for is the x86 iommu irq mapping api.
And how we handle irqs in the context of it.

So as a start I think we can create x86_map_irq, as I suggested.
Since we have the pci dev to lookup the iommu then we really shouldn't
need multiple irq_chip structures (although it may be worth it if we
can detect we can optimize irq migration).

I just don't want to have a MxN problem where we have to implement
every kind of irq chip handler with every kind of iommu if I can help
it.  Even Mx2 starts looking pretty nasty.

> For initial setup, I agree that it can use some simplifications. It's getting
> late here and I will look at all your suggestions tomorrow.

Sounds good.

Eric

