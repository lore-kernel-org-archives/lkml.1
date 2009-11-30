Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbZK3HKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbZK3HKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 02:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbZK3HKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 02:10:52 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41697 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbZK3HKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 02:10:51 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B136FEE.7060305@jp.fujitsu.com>
Date: Mon, 30 Nov 2009 16:10:38 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 0/9] pci: update pci bridge resource to get more big range
 for devices under it - v13
References: <4ADEB601.8020200@kernel.org>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit! su.com> <4B0C69AD.3030106@kernel. org> <4B0D13EB.9010403@jp.fujitsu.com> <4B10D286.4020607@kernel
 .org>
In-Reply-To: <4B10D286.4020607@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> split the two patches in to 9 for easy review...
> 
> please check
> 
> 1. boot time:
> 
> BIOS separate IO range between several IOHs, and on some slots, BIOS assign the resource to the bridge, but stop
> assigning resource to the device under that bridge, because the device need big resource.
> 
> so patches (first 6) are trying to 
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
> BIOS separate IO range between several IOHs, and on some slots, BIOS assign the resource to every bridge. (8M)
> but when insert one card that big resource, the card can not get resource. because kernel will not touch the 
> bridge resource.
> 
> so patches (last 3) are trying to
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
> -v13: change resource_list to resource_list_x, to save size and flags aside, otherwise grandchild res will
>       get confused with son's res as could be used
> 

My system doesn't boot (hangup) with the following error messages
from Fusion MPT SAS driver. Those are different from the one
captured with the previous version of your patches.


Fusion MPT SAS Host driver 3.04.12
mptsas 0000:09:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
mptbase: ioc0: Initiating bringup
mptbase: ioc0: WARNING - Unexpected doorbell active!
mptbase: ioc0: ERROR - Failed to come READY after reset! IocState=f0000000
mptbase: ioc0: WARNING - ResetHistory bit failed to clear!
mptbase: ioc0: ERROR - Diagnostic reset FAILED! (ffffffffh)
mptbase: ioc0: WARNING - NOT READY WARNING!
mptbase: ioc0: ERROR - didn't initialize properly! (-1)
mptsas: probe of 0000:09:00.0 failed with error -1
mptsas 0000:0a:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
mptbase: ioc1: Initiating bringup
mptbase: ioc1: WARNING - Unexpected doorbell active!
mptbase: ioc1: ERROR - Failed to come READY after reset! IocState=f0000000
mptbase: ioc1: WARNING - ResetHistory bit failed to clear!
mptbase: ioc1: ERROR - Diagnostic reset FAILED! (ffffffffh)
mptbase: ioc1: WARNING - NOT READY WARNING!
mptbase: ioc1: ERROR - didn't initialize properly! (-1)
mptsas: probe of 0000:0a:00.0 failed with error -1


I'll send the whole boot log privately.

Thanks,
Kenji Kaneshige


