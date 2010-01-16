Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab0APCpe (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 21:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499Ab0APCn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 21:43:27 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:57724 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab0APCnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 21:43:25 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 15 Jan 2010 18:41:50 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 00/11] pci: update pci bridge resources
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263609721-3921-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patchset is trying to update pci bridge BAR when that BAR is big enough.

1. boot time:

BIOS separate IO range between several IOHs, and on some slots, BIOS assign
the resource to the bridge, but stop assigning resource to the device under
that bridge, because the device need big resource.

so patches (first 8) are trying to
a. pci assign unassign and record the failed device resource.
b. clear the BIOS assigned resource of the parent bridge of fail device
c. go back and call pci assign unsigned
d. if it still fail, will go up more bridges. and clear and try again.

v2: Jesse doesn't like it is in find_free_bus_resource...
    try to move out of pci_bus_size_bridges loop.
v3: add pci_setup_bridge calling after pci_bridge_release_not_used_res.
    only clear release those res for x86.
v4: Bjorn want to release use dev instead of bus.
v5: Kenji pointed out it will have problem with several level bridge.
    so let only handle leaf bridge.
v6: address Kenji's request (new pci_bus_release...). and change applying order
    move back release to pci_assign_unassigned_resource
v7: change functions name pci_bus_release_unused_bridge_res according to Jesse
v8: address Eric's concern, only overwrite leaf bridge resource that is not big
    enough need to do it in two steps, and first step recore the failed res,
    and don't touch bridge res that programmed by firmware. second step will
    try to release bridge resource that is too small at first.
v9: refresh to be applied after bjorn's patch, and remove trick about save
    size and restore resource second try.
v11:add pci=try=5, about more try to change more bridge
v12:not shrink pci bridge resource

2. hotplug:
BIOS separate IO range between several IOHs, and on some slots, BIOS assign
the resource to every bridge. (8M) but when insert one card that big resource,
the card can not get resource. because kernel will not touch the bridge
resource.

so patches (9-11) are trying to
a. assign resource to devices with that slot. and record fail devices
b. if there is some failed, will clear sepcifically io port of bridge, or mmio of bridge, or mmio pref of bridge.
c. try to assign the parent bridge of the slot.

v2: address Alex's concern about pci remove/rescan feature about
    pci_setup_bridge changes.
v3: Kenji pointed out that pci_config_slot need to be called before
    pci_bus_add_devices()
v4: move out pci_is_enabled checkout of pci_setup_bridge()
v5: change the applying sequence.
v6: change the functions name according to Jesse
v8: address Eric's concern, only overwrite leaf bridge resource that is not
     big enough
v9: refresh to be applied after bjorn's patch, and remove trick about save
    size and restore resource second try.
v10:alex found need to have export for pci_assign_unassigned_bridge_resources
v11: pass check_leaf with pci_bus_release_unused_bridge_res

patches (12-13)
will try to shrink, the pci hotplug related pcie port, so could save some for
others.

-v13: change resource_list to resource_list_x, to save size and flags aside,
      otherwise grandchild res will get confused with son's res as could be used

-v14: default it is disabled.  could use pci=try=2 to enable it.
-v15: seperate release_child_resources aside.

-v16: refresh according to new pci/linux-next of 2009_01_15
      change some name according to Jesse

Thanks

Yinghai




