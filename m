Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYGKRWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYGKRWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 13:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbYGKRWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 13:22:06 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48204 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbYGKRWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 13:22:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Duran, Leo" <leo.duran@amd.com>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
       "Richter, Robert" <rrichter@elbe.amd.com>,
       "Biemueller, Sebastian" <Sebastian.Biemueller@amd.com>,
       <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
       <mingo@redhat.com>, <tglx@linutronix.de>,
       "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>
References: <6453C3CB8E2B3646B0D020C1126132730149A6C6@sausexmb4.amd.com>
Date: Fri, 11 Jul 2008 10:20:33 -0700
In-Reply-To: <6453C3CB8E2B3646B0D020C1126132730149A6C6@sausexmb4.amd.com> (Leo
	Duran's message of "Fri, 11 Jul 2008 11:23:46 -0500")
Message-ID: <m1k5fsfice.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Duran, Leo" <leo.duran@amd.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1306]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/34] AMD IOMMU driver
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Duran, Leo" <leo.duran@amd.com> writes:

> On Friday, July 11, 2008 5:22 AM, Eric W. Biederman wrote:
>
>> Small question.  Does this IOMMU also support irq remapping?
>> 
>> Intel is starting to merge support for their iommu that supports irq
>> remapping and I am curious what the implications are going to be to
>> support both of these iommus?
>> 
>> Assuming their is irq remapping support it isn't tied to x2apic
>> support in the cpus is it?
>> 
> Follow-up questions: 
> (1) Outside of a virtualization environment, is there functional value
> for "irq remapping" by an IOMMU? And, if there is, (2) How would this
> functionality get abstracted? (e.g., as dma_ops abstracts 'address
> remapping' by the IOMMU)

Current x86 hardware ioapics have significant issues with irq
migration.  So things like real cpu hotplug are not really
supportable unless there is better hardware or an iommu.

There is a good case for linux to support kernel bypass for some hardware.
>From kvm where linux acts as a hypervisor to crazy people wanting to
device drivers in user space, to the classic HPC mpi stack that
wants to go as fast as possible.

Then there is the Intel case where the are extending their cpu apicids
to 32bit and require going through a hypervisor to encode all of the
necessary bits.  I think we can go to 16bit cpus without doing that
but it is a squeeze.

If we are going to run under under a hypervisor we need at least the
abstraction of going through an iommu (in that case a hypercall) 
so we can run under a hypervisor.

So right now we are just starting to design the abstraction, and I'm
hoping we can get as large a perspective on what it should look like
as we can.  

I expect the api will look something like:
struct irq_map_info x86_map_irq(irq, cpumask);

Where struct irq_map_info would return the architecture defined bits
that we can program into an msi or an ioapic routing entry.

With x86_map_irq looking up an appropriate ops structure and calling
the iommu specific operation.

Eric
