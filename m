Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbXGBLRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbXGBLRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 07:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbXGBLQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 07:16:52 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:48727 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbXGBLQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 07:16:51 -0400
Message-ID: <4688DE8F.4040902@linux.vnet.ibm.com>
Date: Mon, 02 Jul 2007 16:46:31 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Krzysztof Oledzki <olel@ans.pl>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: IRQ handling difference between i386 and x86_64
References: <Pine.LNX.4.64.0706301617240.16011@bizon.gios.gov.pl> <1183218035.2894.13.camel@laptopd505.fenrus.org>
In-Reply-To: <1183218035.2894.13.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Arjan van de Ven wrote:
> On Sat, 2007-06-30 at 16:55 +0200, Krzysztof Oledzki wrote:
>> Hello,
>>
>> It seems that IRQ handling is somehow different between i386 and x86_64.
>>
>> In my Dell PowerEdge 1950 is it possible to enable interrupts spreading 
>> over all CPUs. This a single CPU, four CORE system (Quad-Core E5335 Xeon) 
>> so I think that interrupts migration may be useful. Unfortunately, it 
>> works only with 32-bit kernel. Booting it with x86_64 leads to situation, 
>> when all interrupts goes only to the first cpu matching a smp_affinity 
>> mask.
> 
> arguably that is the most efficient behavior... round robin of
> interrupts is the worst possible case in terms of performance
> 
> are you using irqbalance ? (www.irqbalance.org)

If you have not been using irqbalance, then setting more bits in
irq/smp_affinity will utilize hardware APIC routing. Sending interrupt
to more than one CPU will work in flat mode only.

In 32 bit kernel the IOAPIC is configured in flat mode while in 64 bit
it is in physical flat mode.  Physical flat mode will support
interrupt routing to only one CPU.

32-bit: Enabling APIC mode:  Flat.  Using 2 I/O APICs
64-bit: Setting APIC routing to physical flat

This is the reason for the observed interrupt routing behavior.  I
guess future kernels will use 'physical flat' mode to avoid hardware
bugs on various complex configurations and also make it scale up to
larger systems.  Also utilizing hardware routing to send interrupts to
many CPUs may not provide desired behavior.

irqbalance application will do the needful.  I agree with Arjan on the
fact that equal interrupt distribution need not provide best
performance.  You will run into complex routing issues only when you
have more NICs than actual number of CPU cores.

--Vaidy


