Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbZKEUr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbZKEUr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758852AbZKEUrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:47:55 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16423 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468AbZKEUry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:47:54 -0500
Date: Thu, 5 Nov 2009 13:47:58 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 2/2] pci: pciehp update the slot bridge res to get big
	range for pcie devices - v9
Message-ID: <20091105204758.GA2091@ldl.fc.hp.com>
References: <4AE899A0.3020006@kernel.org> <4AE95247.8080401@jp.fujitsu.com> <4AE952B9.1010603@kernel.org> <4AE9588E.90708@jp.fujitsu.com> <4AE9657F.7010302@kernel.org> <4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF22D26.4070500@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu <yinghai@kernel.org>:
> 
> move out bus_size_bridges and assign resources out of pciehp_add_bridge()
> and at last do them all together one time including slot bridge, to avoid to
> call assign resources several times, when there are several bridges under the
> slot bridge.
> 
> need to introduce pci_bridge_assign_resources there.
> 
> handle the case the slot bridge that doesn't get pre-allocated big enough res
> from FW.
> for example pcie devices need 256M, but the bridge only get preallocated 2M...
> 
> pci_setup_bridge() will take extra check_enabled for the slot bridge, otherwise
> update res is not updated to bridge BAR. that is bridge is enabled already for
> port service.
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
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

How did you build and test this? I got this during building:

ERROR: "pci_assign_unassigned_bridge_resources" [drivers/pci/hotplug/pciehp.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....

This patch fixed it for me:
---
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 95fe3f4..2f15473 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -962,3 +962,4 @@ again:
 
 	goto again;
 }
+EXPORT_SYMBOL_GPL(pci_assign_unassigned_bridge_resources);
