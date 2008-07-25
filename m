Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbYGYQjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbYGYQjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYGYQjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:39:06 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:39124 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYGYQjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:39:05 -0400
Message-ID: <488A015D.4040107@csr.com>
Date: Fri, 25 Jul 2008 17:37:49 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080724)
MIME-Version: 1.0
To: Michal Schmidt <mschmidt@redhat.com>
CC: Matthew Wilcox <matthew@wil.cx>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PCI: MSI interrupts masked using prohibited method
References: <4860D09D.4060801@csr.com>	<48807166.9010006@csr.com>	<20080722155629.1160635e@brian.englab.brq.redhat.com>	<200807221052.26879.jbarnes@virtuousgeek.org>	<20080725152918.43bf3100@brian.englab.brq.redhat.com>	<20080725134252.GG6701@parisc-linux.org> <20080725155329.79821436@brian.englab.brq.redhat.com>
In-Reply-To: <20080725155329.79821436@brian.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jul 2008 16:38:01.0240 (UTC) FILETIME=[CD8F5980:01C8EE74]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Schmidt wrote:
> On Fri, 25 Jul 2008 07:42:52 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
>> On Fri, Jul 25, 2008 at 03:29:18PM +0200, Michal Schmidt wrote:
>>> The interesting thing is that I can see Destination ID bits of MSI
>>> Message Address change correctly in lspci output. But the interrupt
>>> is still delivered load-balanced to all CPUs even though the
>>> Destination ID identifies the single CPU I asked for. It seems the
>>> device only takes the new Message Address setting into account when
>>> the MSI Enable bit in the Message Control register is changed from
>>> 0 to 1. I tested this by setting the MSI enable bit to 0 and then
>>> immediately back to 1 at the end of
>>> io_apic_64.c:set_msi_irq_affinity().
>>>
>>> Is this a permitted behaviour for the device? I couldn't find
>>> anything in the PCI specification that would mentioned it.

The spec says that system software should enable MSI before setting 
message address and data (PCI 3.0 section 6.8.3.1 MSI configuration). 
The kernel doesn't do this.

>> I don't think that's necessary.  However, the thought occurs that we
>> ought to disable MSI, then write the address, then re-enable MSI.  It
>> doesn't cause a problem at the moment because we don't change the
>> top 32 bits of the address (at least on any of my systems ..) but
>> theoretically if we were to use a 64-bit address, we would experience
>> MSIs being sent to an address that was a mixture of the top 32 bits of
>> the old address and the bottom 32 bits of the new address.
>>
>> We definitely can already get tearing when we've written the lower
>> address register but not the data register yet (also true for MSIX, by
>> the way).  So we ought to fix this properly.

I really don't think we should be enabling/disabling MSI while 
interrupts might be being generated.  There are cases where interrupts 
will be lost.  Consider PCIe where we might end up with a situation 
where MSI is disabled and then enabled sufficiently quickly that no 
periodic line interrupt message is sent by the device.

The message address and data should only be modified while the vector is 
masked (to avoid the aforementioned 'tearing').  This means that setting 
IRQ affinity cannot be done on devices without per-vector mask bits.  I 
don't think this is a problem.

In vague psuedo-code, set_affinity() should be something like this:

int did_mask = msi_mask_vector();
if (!did_mask) {
     return -ENOTSUPP;
}
/* fiddle with address and mask now */
msi_unmask_vector();

David
-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ
