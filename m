Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156Ab0AHVeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab0AHVeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 16:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180Ab0AHVeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 16:34:06 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:23462 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab0AHVeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 16:34:00 -0500
Subject: Re: [PATCH 00/14] pci: update pci bridge resources
From: Patrick Keller <patrick.keller@hp.com>
Reply-To: patrick.keller@hp.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "Chiang, Alexander" <achiang@hp.com>,
       "Helgaas, Bjorn" <bjorn.helgaas@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 14:33:37 -0700
Message-ID: <1262986417.2877.1.camel@pLaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2009-12-22 at 23:02 +0000, Yinghai Lu wrote:
> this patchset is trying to update pci bridge BAR when that BAR is big enough.
> 
> 1. boot time:
> 
> BIOS separate IO range between several IOHs, and on some slots, BIOS assign
> the resource to the bridge, but stop assigning resource to the device under
> that bridge, because the device need big resource.
> 
> so patches (first 8) are trying to
> a. pci assign unassign and record the failed device resource.
> b. clear the BIOS assigned resource of the parent bridge of fail device
> c. go back and call pci assign unsigned
> d. if it still fail, will go up more bridges. and clear and try again.
> 
> v2: Jesse doesn't like it is in find_free_bus_resource...
>     try to move out of pci_bus_size_bridges loop.
> v3: add pci_setup_bridge calling after pci_bridge_release_not_used_res.
>     only clear release those res for x86.
> v4: Bjorn want to release use dev instead of bus.
> v5: Kenji pointed out it will have problem with several level bridge.
>     so let only handle leaf bridge.
> v6: address Kenji's request (new pci_bus_release...). and change applying order
>     move back release to pci_assign_unassigned_resource
> v7: change functions name pci_bus_release_unused_bridge_res according to Jesse
> v8: address Eric's concern, only overwrite leaf bridge resource that is not big
>     enough need to do it in two steps, and first step recore the failed res,
>     and don't touch bridge res that programmed by firmware. second step will
>     try to release bridge resource that is too small at first.
> v9: refresh to be applied after bjorn's patch, and remove trick about save
>     size and restore resource second try.
> v11:add pci=try=5, about more try to change more bridge
> v12:not shrink pci bridge resource
> 
> 2. hotplug:
> BIOS separate IO range between several IOHs, and on some slots, BIOS assign
> the resource to every bridge. (8M) but when insert one card that big resource,
> the card can not get resource. because kernel will not touch the bridge
> resource.
> 
> so patches (9-11) are trying to
> a. assign resource to devices with that slot. and record fail devices
> b. if there is some failed, will clear sepcifically io port of bridge, or mmio of bridge, or mmio pref of bridge.
> c. try to assign the parent bridge of the slot.
> 
> v2: address Alex's concern about pci remove/rescan feature about
>     pci_setup_bridge changes.
> v3: Kenji pointed out that pci_config_slot need to be called before
>     pci_bus_add_devices()
> v4: move out pci_is_enabled checkout of pci_setup_bridge()
> v5: change the applying sequence.
> v6: change the functions name according to Jesse
> v8: address Eric's concern, only overwrite leaf bridge resource that is not
>      big enough
> v9: refresh to be applied after bjorn's patch, and remove trick about save
>     size and restore resource second try.
> v10:alex found need to have export for pci_assign_unassigned_bridge_resources
> v11: pass check_leaf with pci_bus_release_unused_bridge_res
> 
> patches (12-13)
> will try to shrink, the pci hotplug related pcie port, so could save some for
> others.
> 
> -v13: change resource_list to resource_list_x, to save size and flags aside,
>       otherwise grandchild res will get confused with son's res as could be used
> 
> -v14: default it is disabled.  could use pci=try=2 to enable it.
> -v15: seperate release_child_resources aside.
> 
> Thanks
> 
> Yinghai
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I'm going to work on testing this patch series today with a focus on
hotplug and fakephp functionality. 

Pat

