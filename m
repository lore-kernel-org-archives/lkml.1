Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbZLPUzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbZLPUzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 15:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbZLPUzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 15:55:21 -0500
Received: from outbound-mail-101.bluehost.com ([69.89.22.11]:38422 "HELO
	outbound-mail-101.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751209AbZLPUzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 15:55:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=DUax25J7QlWfFc5g6tTFtipgy4LKAHTxqyOxfbhxOMQoYxMl8s21Xk7JWMC0Q7PDa0nHF7a9L/8N9uXDUrOIv/oqeUuwe9B2PzS9Wqc9EeGNPavmpdHmr82taKj16xLX;
Date: Wed, 16 Dec 2009 12:54:58 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 0/9] pci: update pci bridge resource to get more big
 range for devices under it - v13
Message-ID: <20091216125458.42bf222e@jbarnes-piketon>
In-Reply-To: <4B10D286.4020607@kernel.org>
References: <4ADEB601.8020200@kernel.org>
	<4AE5E37F.8070707@kernel.org>
	<4AE5EFDB.2060908@kernel.org>
	<4AE80170.6030402@jp.fujitsu.com>
	<4AE88305.8020207@kernel.org>
	<m1ljivibrt.fsf@fess.ebiederm.org>
	<4AE899A0.3020006@kernel.org>
	<4AE95247.8080401@jp.fujitsu.com>
	<4AE952B9.1010603@kernel.org>
	<4AE9588E.90708@jp.fujitsu.com>
	<4AE9657F.7010302@kernel.org>
	<4AE965D9.9040702@kernel.org>
	<20091104093044.17ab628a@jbarnes-piketon>
	<4AF1CD79.4010602@kernel.org>
	<4AF22CF1.1020508@kernel.org>
	<4AF22D26.4070500@kernel.org>
	<4AF508F0.9060105@kernel.org>
	<4AF91F54.10507@jp.fujitsu.com>
	<4AF936DB.1030309@kernel.org>
	<4AFCF7D8.1090207@jp.fujitsu.com>
	<4AFCFC0D.4030002@kernel.org>
	<4AFD19DA.7010602@jp.fujitsu.com>
	<4AFE6F39.5080505@kernel.org>
	<4B0B321E.4010103@jp.fujitsu.com>
	<4B0B335E.1070809@kernel.org>
	<4B0B3C13.9030502@jp.fujit! su.com>
	<4B0C69AD.3030106@kernel. org>
	<4B0D13EB.9010403@jp.fujitsu.com>
	<4B10D286.4020607@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009 23:34:30 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> split the two patches in to 9 for easy review...
> 
> please check
> 
> 1. boot time:
> 
> BIOS separate IO range between several IOHs, and on some slots, BIOS
> assign the resource to the bridge, but stop assigning resource to the
> device under that bridge, because the device need big resource.
> 
> so patches (first 6) are trying to 
> a. pci assign unassign and record the failed device resource.
> b. clear the BIOS assigned resource of the parent bridge of fail
> device c. go back and call pci assign unsigned
> d. if it still fail, will go up more bridges. and clear and try again.
> 
> v2: Jesse doesn't like it is in find_free_bus_resource...
>     try to move out of pci_bus_size_bridges loop.
> v3: add pci_setup_bridge calling after
> pci_bridge_release_not_used_res. only clear release those res for x86.
> v4: Bjorn want to release use dev instead of bus.
> v5: Kenji pointed out it will have problem with several level bridge.
>     so let only handle leaf bridge.
> v6: address Kenji's request (new pci_bus_release...). and change
> applying order move back release to pci_assign_unassigned_resource
> v7: change functions name pci_bus_release_unused_bridge_res according
> to Jesse v8: address Eric's concern, only overwrite leaf bridge
> resource that is not big enough need to do it in two steps, and first
> step recore the failed res, and don't touch bridge res that
> programmed by firmware. second step will try to release bridge
> resource that is too small at first. v9: refresh to be applied after
> bjorn's patch, and remove trick about save size and restore resource
> second try. v11:add pci=try=5, about more try to change more bridge
> v12:not shrink pci bridge resource
> 
> 2. hotplug:
> BIOS separate IO range between several IOHs, and on some slots, BIOS
> assign the resource to every bridge. (8M) but when insert one card
> that big resource, the card can not get resource. because kernel will
> not touch the bridge resource.
> 
> so patches (last 3) are trying to
> a. assign resource to devices with that slot. and record fail devices
> b. if there is some failed, will clear sepcifically io port of
> bridge, or mmio of bridge, or mmio pref of bridge. c. try to assign
> the parent bridge of the slot.
> 
> v2: address Alex's concern about pci remove/rescan feature about
>     pci_setup_bridge changes.
> v3: Kenji pointed out that pci_config_slot need to be called before
>     pci_bus_add_devices()
> v4: move out pci_is_enabled checkout of pci_setup_bridge()
> v5: change the applying sequence.
> v6: change the functions name according to Jesse
> v8: address Eric's concern, only overwrite leaf bridge resource that
> is not big enough
> v9: refresh to be applied after bjorn's patch, and remove trick about
> save size and restore resource second try.
> v10:alex found need to have export for
> pci_assign_unassigned_bridge_resources v11: pass check_leaf with
> pci_bus_release_unused_bridge_res
> 
> -v13: change resource_list to resource_list_x, to save size and flags
> aside, otherwise grandchild res will get confused with son's res as
> could be used

Patches 4-6 make me the most nervous, since they have the potential of
really changing our resource allocation (hopefully for the better) on
many platforms.

Linus, can you check them out and see if you're ok with the direction?

Patches 7-9 seem like they've recieved some review from Alex and
Kenji-san, but I don't see acks or reviewed-bys on them.

Alex and Kenji-san, are you ok with them assuming the previous patches
or something like them go upstream?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
