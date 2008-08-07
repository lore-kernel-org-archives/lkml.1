Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbYHGIo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbYHGIo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 04:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYHGIoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 04:44:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37417 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYHGIoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 04:44:12 -0400
Message-ID: <489AB595.7000006@jp.fujitsu.com>
Date: Thu, 07 Aug 2008 17:43:01 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 0/7] Fixups for duplicate slot names
References: <20080806050745.GA31319@ldl.fc.hp.com>
In-Reply-To: <20080806050745.GA31319@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex-san,

Thank you for patches!

I looked at your patches and it looks good. But I have only one
concern about how to allocate/free memory for slot name.

With your change, memory region for slot name will be allocated
by hotplug *controller* driver and it can be freed using kfree()
by hotplug *core* driver (not hotplug controller driver). So all
hotplug controller drivers including drivers implemented in the
future need to take it into account.

I think it will be more robust if we can allocate and free memory
in the same component (maybe hotplug core driver in this case).

Thanks,
Kenji Kaneshige


Alex Chiang wrote:
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>> With this change, kobject_init_and_add() called in
>> pci_create_slot() will show stack trace if a hotplug driver
>> attempts to register multiple slot with the same name. That is,
>> stack trace will be shown on the platform that wrongly assing
>> the physical slot number to multiple slots. I'm very sorry, but
>> I don't have enough time to consider how to fix it today.
> 
> Hello Kenji-san,
> 
> You are obviously correct about my prior bad patch that simply
> removed the check in pci_hp_register() for duplicate names.
> 
> I also talked with Willy, and he thought that the proper way to
> fix all these issues was not in the individual drivers, but in
> the PCI core, which I agree with.
> 
> Here is a patch series that attempts to implement Willy's
> suggestion.
> 
> Patches 1--6 convert the callers of pci_hp_register/pci_create_slot
> from a static char name[] to a dynamically kmalloc'ed char *name.
> 
> There are also cleanups in the individual drivers to remove the
> _slot_with_bus parameters.
> 
> Patch 7/7 implements the collision rename logic. It's not the
> prettiest thing in the world, so your comments are welcome. :)
> 
> It's getting late here and I haven't had time to really test it,
> other than a quick compile test, but I wanted to try and send it
> so that you could take a look and possibly try it. ;)
> 
> These patches apply on top of Linus's latest tree.
> 
> Thanks!
> 
> /ac
> 
>  drivers/acpi/pci_slot.c                |   15 ++++++-
>  drivers/pci/hotplug/acpiphp.h          |    2 -
>  drivers/pci/hotplug/acpiphp_core.c     |   18 +++++----
>  drivers/pci/hotplug/fakephp.c          |   16 ++++++--
>  drivers/pci/hotplug/pci_hotplug_core.c |    4 --
>  drivers/pci/hotplug/pciehp.h           |    6 +--
>  drivers/pci/hotplug/pciehp_core.c      |    7 ---
>  drivers/pci/hotplug/pciehp_hpc.c       |   19 ++++-----
>  drivers/pci/hotplug/pcihp_skeleton.c   |   12 ++++--
>  drivers/pci/hotplug/shpchp.h           |    5 +-
>  drivers/pci/hotplug/shpchp_core.c      |   29 ++++----------
>  drivers/pci/slot.c                     |   65 +++++++++++++++++++++++++++++----
>  include/linux/pci.h                    |    3 -
>  13 files changed, 124 insertions(+), 77 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


