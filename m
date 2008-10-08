Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbYJHGeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbYJHGeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 02:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYJHGeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 02:34:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57015 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbYJHGeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 02:34:21 -0400
Message-ID: <48EC53D3.9020203@jp.fujitsu.com>
Date: Wed, 08 Oct 2008 15:31:47 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/15] PCI: let the core manage slot names
References: <20081003230125.9989.31145.stgit@bob.kio>
In-Reply-To: <20081003230125.9989.31145.stgit@bob.kio>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex-san,

I have some ideas and made some patches for comments I sent about
your [PATCH v4 02/15] and [PATCH v4 03/15]. Please take a look.
There are three patches.

  - [01/03] Sample patch for [PATCH v4 02/15]

  - [02/03] Sample patch for [PATCH v4 03/15]
    NOTE:This doesn't target the comment about changing exported
         symbol name.

  - [03/03] Sample patch for [PATCH v4 14/15]
    This is needed because above two patches make your [PATCH v4
    14/15] can not be applied.

Note: I made those patches as replacement of your corresponding
ones. So those patches are NOT for applying on top your original
patches.

Thanks,
Kenji Kaneshige


Alex Chiang wrote:
> Hi all,
> 
> This is v4 of the series that implements a series of changes
> that allows the PCI core to manage slot names, rather than
> individual hotplug drivers.
> 
> Thank you to Kenji-san and Taku-san for testing and finding my bugs.
> Thanks to Willy for helping me out with the locking issues in
> pci_hp_register.
> 
> Again, I have tested by loading pci_slot, acpiphp, and fakephp in various
> combinations, and using the new dup_slots=1 param to fakephp. I also had:
> 
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_SPINLOCK_SLEEP=y
> 
> and didn't see any complaints.
> 
> This series applies against Jesse's linux-next branch. I just fetched his
> branch and peeked at it, and based on the log, my series _should_ apply
> with minimal fuzz (but I didn't do a rebase because I didn't think to
> check until writing this mail ;).
> 
> It would be great if folks could give one last (hopefully!) review.
> 
> Thanks.
> 
> /ac
> 
> v3 -> v4:
> 	- Do not access hotplug_slot_name() before name initialization
> 	- Serialize pci_hp_register/deregister
> 
> v2 -> v3:
> 	- incorporate Willy's code review comments
> 	- fix possible memory leak, pointed out by Rolf Eike Beer
> 	- make false name collision detection work for empty slots
> 	- add 'dup_slots' module_param to fakephp to help debug all this ;)
> 
> v1 -> v2:
> 	- fix possible false name collisions
> 
> ---
> 
> Alex Chiang (15):
>       PCI Hotplug: fakephp: add duplicate slot name debugging
>       PCI: Hotplug core: remove 'name'
>       PCI: shcphp: remove 'name' parameter
>       PCI: SGI Hotplug: stop managing bss_hotplug_slot->name
>       PCI: rpaphp: kmalloc/kfree slot->name directly
>       PCI: pciehp: remove 'name' parameter
>       PCI: ibmphp: stop managing hotplug_slot->name
>       PCI: fakephp: remove 'name' parameter
>       PCI: cpqphp: stop managing hotplug_slot->name
>       PCI: cpci_hotplug: stop managing hotplug_slot->name
>       PCI: acpiphp: remove 'name' parameter
>       PCI, PCI Hotplug: introduce slot_name helpers
>       PCI: prevent duplicate slot names
>       PCI Hotplug: serialize pci_hp_register/deregister
>       PCI Hotplug core: add 'name' param pci_hp_register interface
> 
> 
>  drivers/pci/hotplug/acpiphp.h           |    9 +-
>  drivers/pci/hotplug/acpiphp_core.c      |   32 +++--
>  drivers/pci/hotplug/cpci_hotplug.h      |    6 +
>  drivers/pci/hotplug/cpci_hotplug_core.c |   75 +++++--------
>  drivers/pci/hotplug/cpci_hotplug_pci.c  |    4 -
>  drivers/pci/hotplug/cpqphp.h            |   13 +-
>  drivers/pci/hotplug/cpqphp_core.c       |   43 +++----
>  drivers/pci/hotplug/fakephp.c           |   26 +++-
>  drivers/pci/hotplug/ibmphp.h            |    5 -
>  drivers/pci/hotplug/ibmphp_ebda.c       |   19 +--
>  drivers/pci/hotplug/pci_hotplug_core.c  |   68 ++++++------
>  drivers/pci/hotplug/pciehp.h            |    9 +-
>  drivers/pci/hotplug/pciehp_core.c       |   49 +++-----
>  drivers/pci/hotplug/pciehp_ctrl.c       |   53 +++++----
>  drivers/pci/hotplug/pciehp_hpc.c        |    1 
>  drivers/pci/hotplug/rpaphp_slot.c       |    9 +-
>  drivers/pci/hotplug/sgi_hotplug.c       |   18 +--
>  drivers/pci/hotplug/shpchp.h            |    9 +-
>  drivers/pci/hotplug/shpchp_core.c       |   52 +++------
>  drivers/pci/hotplug/shpchp_ctrl.c       |   48 ++++----
>  drivers/pci/slot.c                      |  181 +++++++++++++++++++++++--------
>  include/linux/pci.h                     |    9 +-
>  include/linux/pci_hotplug.h             |   11 +-
>  23 files changed, 407 insertions(+), 342 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


