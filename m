Return-Path: <linux-kernel-owner+w=401wt.eu-S1760705AbYDCBsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbYDCBsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 21:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbYDCBsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 21:48:31 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:18183 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462AbYDCBsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 21:48:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fWAwTqYKBJBd3qpfby5q5y+Vi501tFowdsSlD1ZwzmprWZVg3UxbcRNDm2VtqVEdLgys8l+tctq4/CiC880Uev9fxkYtZXU/ej3xDrzta1kvtLqxaX9slzsofU7cwT2jVilcXndJHZnqe3MR3wW76sJMN2Vm2AwUNbX6eEiyyWM=
Message-ID: <47F43766.2070207@gmail.com>
Date: Thu, 03 Apr 2008 10:48:22 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Peer Chen <pchen@nvidia.com>, Kuan Luo <kluo@nvidia.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200803191455.14380.volker.armin.hemmann@tu-clausthal.de> <47F30438.40506@gmail.com> <200804021909.41609.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200804021909.41609.volker.armin.hemmann@tu-clausthal.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Volker.

Volker Armin Hemmann wrote:
> On Mittwoch, 2. April 2008, Tejun Heo wrote:
>> Volker Armin Hemmann wrote:
>>> On Mittwoch, 19. März 2008, Tejun Heo wrote:
>>>> Volker Armin Hemmann wrote:
>>>>> On Mittwoch, 19. März 2008, Tejun Heo wrote:
>>>>>> x UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200
>>>>>>
>>>>>>> irq 315
>>>>>>> [   38.125479] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port
>>>>>>> 0xf9dfc280 irq 315
>>>>>>> [   38.597035] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>>>>>> [   38.597732] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max
>>>>>>> UDMA/133 [   38.597775] ata1.00: 312581808 sectors, multi 16: LBA48
>>>>>>> [   38.598405] ata1.00: configured for UDMA/133
>>>>>>> [   39.069342] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>>>>>> [   39.084225] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
>>>>>>> [   39.084264] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth
>>>>>>> 0/32) [   39.086268] ata2.00: configured for UDMA/133
>>>>>> So, just to confirm.  With the updated patch, you don't see any
>>>>>> problem, right?
>>>>> Correct. With the updated patch I don't see problems in 'non-raid'
>>>>> mode. AHCI mode still has problems without nosmi. But that is an
>>>>> entirely different problem, right?
>>>> Yeap, can you please post the result of "lspci -nn"?
>>> with AHCI+nosmi, 2.6.24.3:
>>> 00:0a.0 SATA controller [0106]: nVidia Corporation MCP65 AHCI Controller
>>> [10de:044d] (rev a1)
>> Sorry about the long delay.  Can you please test the attached patch in
>> both ahci and non-ahci modes w/o pci=nomsi and post resulting boot logs?
> 
> patch -p1 < /home/energyman/mcp65-ahci-debug.patch
> patching file drivers/ata/libata-core.c
> Hunk #1 succeeded at 7136 (offset 2 lines).
> patching file drivers/ata/libata-eh.c
> Hunk #1 succeeded at 2083 (offset -107 lines).
> patching file drivers/pci/quirks.c
> Hunk #1 succeeded at 1733 with fuzz 1 (offset -122 lines).
> 
> saved config, removed linux-2.6.24.3, unpacked 2.6.24.3 from tarball, reiser4 
> and your patch, make oldconfig, make menuconfig, make all modules_install 
> install.
> 
> dmesgs are below. 
[--snip--]
> In short, no changes at all.

Thanks for confirming.

Peer, Kuan.  Volker is reporting detection problems on MCP65 AHCI.
The followings are what we've discovered till now.

1. When the controller is put into non-raid mode in BIOS

  * If softreset is used, either the softreset itself or IDENTIFY
    following it times out once.  On retrial, it works fine.  It
    doesn't matter whether the SRST is issued by itself or as
    follow-up-srst after hardreset.  Using only hardreset works fine.

  * The controller doesn't indicate MSI capability and MSI isn't used
    by default.

2. When the controller is put into ahci mode in BIOS

  * SRST works fine.

  * The controller indicates MSI capability but MSI doesn't work
    properly resulting in IRQ delivery failure.  Adding
    intx_disable_bug quirk doesn't help.

I've performed similar test on MCP67 and everything worked fine on it.

Both problems (SRST and MSI) can be worked around but I need more
information to work around those.

* Which chips are affected?  Are there proper fixes?

* For the MSI problem, is it system wide problem or local to the ahci
  controller?

Thanks.

-- 
tejun
