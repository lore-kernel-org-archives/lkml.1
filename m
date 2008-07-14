Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYGNBMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYGNBMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 21:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbYGNBMC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 21:12:02 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53455 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbYGNBMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 21:12:00 -0400
Message-ID: <487AA71E.7000900@jp.fujitsu.com>
Date: Mon, 14 Jul 2008 10:08:46 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] x86-64: Support for multiple MSIs
References: <20080711005719.GO14894@parisc-linux.org> <1215738002-4961-5-git-send-email-matthew@wil.cx> <4876E68F.3050200@jp.fujitsu.com> <20080711085035.GP14894@parisc-linux.org>
In-Reply-To: <20080711085035.GP14894@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, Jul 11, 2008 at 01:50:23PM +0900, Kenji Kaneshige wrote:
>> I'm very sorry for very delayed comment, but I have a concern
>> about irq affinity code. Since I didn't have enough time to
>> look at your patch, I might be misunderstanding something...
>>
>> In my understanding, when irq affinity is changed on one of
>> the IRQs corresponding to MSI, it will not completed until
>> interrupts occur on all the IRQs. Attempts to change irq
>> affinity before previous affinity change is finished will be
>> ignored. Here, suppose that device uses three MSI irqs. In
>> this case, your patch manages four irqs, but only three
>> interrupts are used. If irq affinity changed on this MSI
>> interrupts, will it be completed?
> 
> I have tested the affinity code with an ICH9 AHCI:
> 
> 495:     117233     117966     118033     117797   PCI-MSI-edge      ahci
> 496:      29860      29106      30191      28705   PCI-MSI-edge      ahci
> 497:          0          0          0          0   PCI-MSI-edge      ahci
> 498:          0          0          0          0   PCI-MSI-edge      ahci
> 499:          0          0          0          0   PCI-MSI-edge      ahci
> 500:          0          0          0          0   PCI-MSI-edge      ahci
> 
> This chip requires 16 MSIs to be registered, and it has 6 ports.
> Only ports 0 and 1 have a device attached.  If I change the mask of
> an active irq (eg 495 or 496), it takes effect on both of them.  If I
> change the mask of an inactive irq (497-500), nothing happens.  But I
> can subsequently change the mask on 495 or 496 successfully.
> 
> I can't tell you why this works this way; I haven't looked in enough
> detail at the irq affinity code, but this is my observation.
> 

What I was worrying about was around irq_cfg->move_in_progress.
Since your environment has less than 8 cpus according to your
/proc/interrupts, I think your environment seems to use "apic_flat"
mode for interrupt handling. In this case, irq_cfg->move_in_progress
is not used for irq migration. I think this is why your environment
didn't encounter the problem I worried about. We should note that
vector allocation logic varies depending on the environment.

BTW, I looked at your take 4 patch. The problem I worried about
seems not to exist in this version (as a good side effect).

Thanks,
Kenji Kaneshige



