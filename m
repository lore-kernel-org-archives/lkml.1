Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032199Ab0B1WnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 17:43:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:42334 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032075Ab0B1WnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 17:43:10 -0500
Message-ID: <4B8AF121.2060106@kernel.org>
Date: Sun, 28 Feb 2010 14:41:37 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] PCI changes for 2.6.34
References: <20100226093957.7b99d09c@jbarnes-piketon> <alpine.LFD.2.00.1002281227300.3851@localhost.localdomain> <alpine.LFD.2.00.1002281246120.3637@localhost.localdomain> <33223F6C-10BD-4671-937D-6D5E4956DD3F@kernel.org> <alpine.LFD.2.00.1002281314110.3637@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002281314110.3637@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2010 01:19 PM, Linus Torvalds wrote:
> 
> 
> On Sun, 28 Feb 2010, Yinghai wrote:
>>
>> Maybe we need to put back pci=try=num back
>> And set pci_try_num=1 by default
> 
> Well, why does your patch trigger any changes at all in the first place? 
> The old situation was fine. All the resources were mapped.
> 
> Sure, there were ROM resources that aren't even enabled, but that is 
> _normal_. Iirc, several graphics chips actually alias the ROM resources 
> with the regular memory-mapped IO resource, ie you can't even map both of 
> them at the same time at some separate address, because the hardware 
> shares address decoding resources.
> 
> There's a reson PCI ROM resources are treated specially by the kernel.
> 
> And as far as I can see, all the other resources are already allocated 
> even without your patch. So there is some fundamental _bug_ there. This is 
> not about enabling/disabling your patch, this is about your patch 
> apparently simply being wrong.
> 

looks like

[    0.942502] pci 0000:04:00.0: reg 10: [mem 0xc6000000-0xc6ffffff]

[    0.942510] pci 0000:04:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]

[    0.942519] pci 0000:04:00.0: reg 1c: [mem 0xc4000000-0xc5ffffff 64bit]

[    0.942523] pci 0000:04:00.0: reg 24: [io  0x3000-0x307f]

[    0.942528] pci 0000:04:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]

[    0.942558] pci 0000:03:00.0: PCI bridge to [bus 04-04]

[    0.942613] pci 0000:03:00.0:   bridge window [io  0x3000-0x3fff]

[    0.942616] pci 0000:03:00.0:   bridge window [mem 0xc4000000-0xc6ffffff]

[    0.942619] pci 0000:03:00.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]

[    0.942657] pci 0000:05:00.0: reg 10: [mem 0xc2000000-0xc2ffffff]

[    0.942665] pci 0000:05:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]

[    0.942675] pci 0000:05:00.0: reg 1c: [mem 0xc0000000-0xc1ffffff 64bit]

[    0.942679] pci 0000:05:00.0: reg 24: [io  0x2000-0x207f]

[    0.942684] pci 0000:05:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.942715] pci 0000:03:02.0: PCI bridge to [bus 05-05]

[    0.942770] pci 0000:03:02.0:   bridge window [io  0x2000-0x2fff]

[    0.942773] pci 0000:03:02.0:   bridge window [mem 0xc0000000-0xc2ffffff]

[    0.942777] pci 0000:03:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]

later
[    0.977506] pci 0000:04:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]

[    0.977575] pci 0000:05:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]

that trigger the reallocating...

it seems old code
1. read out from pci rom bar
2. disable it, if it is enabled, but don't registered it
3. before pci_assign_unassigned..., will check PCI_ASSIGN_ROMS, and could register it...
3. to allocate for ROM bar together with other bar, for disabled or enabled but don't have PCI_ASSIGN_ROMS
4. it will not update the BAR if old setting is not enabled by BIOS.

looks like we should not allocate for those ROM bar at first place?

YH
