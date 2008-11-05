Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbYKEIKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbYKEIKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 03:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbYKEIJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 03:09:58 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:38823 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYKEIJ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 03:09:57 -0500
Message-ID: <491154C8.3040401@cosmosbay.com>
Date: Wed, 05 Nov 2008 09:09:44 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: ut <mchan@broadcom.com>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [BUG] linux-2.6.28-rc3 regression: IRQ smp_affinities not respected
References: <C27F8246C663564A84BB7AB343977242151F4B18B5@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <C27F8246C663564A84BB7AB343977242151F4B18B5@IRVEXCHCCR01.corp.ad.broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 05 Nov 2008 09:09:54 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Chan a écrit :
> Eric Dumazet wrote:
> 
>> Hi all
>>
>> One more problem it seems on 2.6.28-rc3
>>
>> I wanted to get maximal throughput from my machine on a
>> network bench with 3 Gigabit
>> links delivering 600.000 packets per second, so I tried to
>> play with smp_affinity to
>> dedicate one CPU for each NIC.
>>
>> It worked with 2.6.27, so there is a regression on this part.
> 
> I believe this may be the patch that broke it:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ce6fce4295ba727b36fdc73040e444bd1aae64cd
> 
> I don't remember all the details, but the Broadcom 5708 chip is
> affected because it does not support MSI per-vector masking.
> 
> One way to get around is to disable MSI with bnx2 parameter
> disable_msi=1.
> 

Thanks Michael for your fast answer


I tried this MSI disabling and yes, it now works.

 16:      42726        128        105        106         89         89        145        152   IO-APIC-fasteoi   uhci_hcd:usb1, eth0, eth1

But I now have same interrupt used on two NIC, so I cannot split the load on two CPUS, unless
using a smp_affinity with 2 CPUS on it. Not exactly what I wanted to do..

Do you know if BCM5715S (tg3 driver) have same problem ?

03:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708S Gigabit Ethernet (rev 12)
        Subsystem: Hewlett-Packard Company NC373i Integrated Multifunction Gigabit Server Adapter
        Flags: bus master, 66Mhz, medium devsel, latency 64, IRQ 16
        Memory at f6000000 (64-bit, non-prefetchable) [size=32M]
        [virtual] Expansion ROM at d1300000 [disabled] [size=16K]
        Capabilities: [40] PCI-X non-bridge device.
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Vital Product Data
        Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-

07:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708S Gigabit Ethernet (rev 12)
        Subsystem: Hewlett-Packard Company NC373i Integrated Multifunction Gigabit Server Adapter
        Flags: bus master, 66Mhz, medium devsel, latency 64, IRQ 16
        Memory at fa000000 (64-bit, non-prefetchable) [size=32M]
        [virtual] Expansion ROM at d1000000 [disabled] [size=16K]
        Capabilities: [40] PCI-X non-bridge device.
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Vital Product Data
        Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-

14:04.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5715S Gigabit Ethernet (rev a3)
        Subsystem: Hewlett-Packard Company NC326m PCIe Dual Port Adapter
        Flags: bus master, 66Mhz, medium devsel, latency 64, IRQ 46
        Memory at fdff0000 (64-bit, non-prefetchable) [size=64K]
        Memory at fdfe0000 (64-bit, non-prefetchable) [size=64K]
        [virtual] Expansion ROM at d1200000 [disabled] [size=128K]
        Capabilities: [40] PCI-X non-bridge device.
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Vital Product Data
        Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable+

14:04.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5715S Gigabit Ethernet (rev a3)
        Subsystem: Hewlett-Packard Company NC326m PCIe Dual Port Adapter
        Flags: bus master, 66Mhz, medium devsel, latency 64, IRQ 16
        Memory at fdfd0000 (64-bit, non-prefetchable) [size=64K]
        Memory at fdfc0000 (64-bit, non-prefetchable) [size=64K]
        [virtual] Expansion ROM at d1220000 [disabled] [size=128K]
        Capabilities: [40] PCI-X non-bridge device.
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Vital Product Data
        Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable-

