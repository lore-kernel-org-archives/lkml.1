Return-Path: <linux-kernel-owner+w=401wt.eu-S1751676AbZJWH7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbZJWH7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 03:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbZJWH7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 03:59:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34810 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZJWH7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 03:59:03 -0400
To: David Daney <ddaney@caviumnetworks.com>
Cc: Chris Friesen <cfriesen@nortel.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>
Subject: Re: Irq architecture for multi-core network driver.
References: <4AE0D14B.1070307@caviumnetworks.com>
	<4AE0D72A.4090607@nortel.com> <4AE0DB98.1000101@caviumnetworks.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 23 Oct 2009 00:59:03 -0700
In-Reply-To: <4AE0DB98.1000101@caviumnetworks.com> (David Daney's message of "Thu\, 22 Oct 2009 15\:24\:24 -0700")
Message-ID: <m13a5apmm0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney <ddaney@caviumnetworks.com> writes:

> Chris Friesen wrote:
>> On 10/22/2009 03:40 PM, David Daney wrote:
>>
>>> The main problem I have encountered is how to fit the interrupt
>>> management into the kernel framework.  Currently the interrupt source
>>> is connected to a single irq number.  I request_irq, and then manage
>>> the masking and unmasking on a per cpu basis by directly manipulating
>>> the interrupt controller's affinity/routing registers.  This goes
>>> behind the back of all the kernel's standard interrupt management
>>> routines.  I am looking for a better approach.
>>>
>>> One thing that comes to mind is that I could assign a different
>>> interrupt number per cpu to the interrupt signal.  So instead of
>>> having one irq I would have 32 of them.  The driver would then do
>>> request_irq for all 32 irqs, and could call enable_irq and disable_irq
>>> to enable and disable them.  The problem with this is that there isn't
>>> really a single packets-ready signal, but instead 16 of them.  So If I
>>> go this route I would have 16(lines) x 32(cpus) = 512 interrupt
>>> numbers just for the networking hardware, which seems a bit excessive.
>>
>> Does your hardware do flow-based queues?  In this model you have
>> multiple rx queues and the hardware hashes incoming packets to a single
>> queue based on the addresses, ports, etc. This ensures that all the
>> packets of a single connection always get processed in the order they
>> arrived at the net device.
>>
>
> Indeed, this is exactly what we have.
>
>
>> Typically in this model you have as many interrupts as queues
>> (presumably 16 in your case).  Each queue is assigned an interrupt and
>> that interrupt is affined to a single core.
>
> Certainly this is one mode of operation that should be supported, but I would
> also like to be able to go for raw throughput and have as many cores as possible
> reading from a single queue (like I currently have).

I believe will detect false packet drops and ask for unnecessary
retransmits if you have multiple cores processing a single queue,
because you are processing the packets out of order.

Eric
