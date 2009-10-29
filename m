Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZJ2Qbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZJ2Qbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZJ2Qbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:31:50 -0400
Received: from outbound-mail-154.bluehost.com ([67.222.39.34]:57990 "HELO
	outbound-mail-154.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753514AbZJ2Qbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:31:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pNGIusk7muRtlCgy3ip0G6GgpiwUuFIsALxpW9O3Zt5RT42egKpwNp2qAg+/tLgjfmncVnVV328nibtitFPgwYCgyiqdROcs42b886BmgJgzKRx0Z/N9PUTOjSNeU9qD;
Date: Thu, 29 Oct 2009 09:31:44 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 1/2] pci: release that leaf bridge' resource index is
 not used -v6
Message-ID: <20091029093144.6ef9da98@jbarnes-g45>
In-Reply-To: <4AE965C0.30206@kernel.org>
References: <4ADEB601.8020200@kernel.org>
	<4AE52B68.3070501@jp.fujitsu.com>
	<4AE53883.3070709@kernel.org>
	<4AE5545E.1020900@jp.fujitsu.com>
	<4AE55D12.30403@kernel.org>
	<4AE57976.4060107@jp.fujitsu.com>
	<4AE5E37F.8070707@kernel.org>
	<4AE5EFDB.2060908@kernel.org>
	<4AE80170.6030402@jp.fujitsu.com>
	<4AE88305.8020207@kernel.org>
	<m1ljivibrt.fsf@fess.ebiederm.org>
	<4AE899A0.3020006@kernel.org>
	<4AE95247.8080401@jp.fujitsu.com>
	<4AE952B9.1010603@kernel.org>
	<4AE9588E.90708@jp.fujitsu.com>
	<4AE965C0.30206@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 02:52:00 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> only for index < 3
> 
> v2: Jesse doesn't like it is in find_free_bus_resource...
>     try to move out of pci_bus_size_bridges loop.
> need to apply after:
> 	[PATCH] pci: pciehp update the slot bridge res to get big
> range for pcie devices - v4 v3: add pci_setup_bridge calling after
> pci_bridge_release_not_used_res. only clear release those res for x86.
> v4: Bjorn want to release use dev instead of bus.
> v5: Kenji pointed out it will have problem with several level bridge.
>     so let only handle leaf bridge.
> v6: address Kenji's request (new pci_bus_release...). and change
> applying order move back release to pci_assign_unassigned_resource
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Starting to look better...

> 
> ---
>  drivers/pci/setup-bus.c |   65
> +++++++++++++++++++++++++++++++++++++++++++++++-
> include/linux/pci.h     |    1 2 files changed, 65 insertions(+), 1
> deletion(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -573,13 +573,68 @@ void __ref pci_bus_assign_resources(cons
>  }
>  EXPORT_SYMBOL(pci_bus_assign_resources);
>  
> +static void pci_bridge_release_not_used_res(struct pci_bus *bus)

Can we call these functions something else?  Maybe
pci_bridge_release_unused() with a kdoc comment describing exactly what
it does and why?

> +{
> +	int idx;
> +	bool changed = false;
> +	struct pci_dev *dev;
> +	struct resource *r;
> +	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> +				  IORESOURCE_PREFETCH;
> +
> +	/* for pci bridges res only */
> +	dev = bus->self;
> +	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_BRIDGE_RESOURCES
> + 3;
> +	    idx++) {
> +		r = &dev->resource[idx];
> +		if (!(r->flags & type_mask))
> +			continue;
> +		if (!r->parent)
> +			continue;
> +		/* if there is no child under that, we should
> release it */
> +		if (r->child)
> +			continue;
> +		if (!release_resource(r)) {
> +			dev_info(&dev->dev, "resource %d %pRt
> released\n",
> +				 idx, r);
> +			r->flags = 0;
> +			changed = true;
> +		}
> +	}
> +
> +	if (changed)
> +		pci_setup_bridge(bus);
> +}
> +
> +void __ref pci_bus_release_bridges_not_used_res(struct pci_bus *bus)

Likewise, maybe pci_bus_release_unused_bridge_res or something, with
comments again.

> +{
> +	struct pci_bus *b;
> +
> +	/* If the bus is cardbus, do nothing */
> +	if (bus->self && (bus->self->class >> 8) ==
> PCI_CLASS_BRIDGE_CARDBUS)
> +		return;
> +
> +	/* We only release the resources under the leaf bridge */
> +	if (list_empty(&bus->children)) {
> +		if (!pci_is_root_bus(bus))
> +			pci_bridge_release_not_used_res(bus);
> +		return;
> +	}
> +
> +	/* Scan child buses if the bus is not leaf */
> +	list_for_each_entry(b, &bus->children, node)
> +		pci_bus_release_bridges_not_used_res(b);
> +}
> +EXPORT_SYMBOL(pci_bus_release_bridges_not_used_res);
> +
>  static void pci_bus_dump_res(struct pci_bus *bus)
>  {
>          int i;
>  
>          for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
>                  struct resource *res = bus->resource[i];
> -                if (!res || !res->end)
> +
> +		if (!res || !res->end || !res->flags)
>                          continue;
>  
>  		dev_printk(KERN_DEBUG, &bus->dev, "resource %d
> %pRt\n", i, res); @@ -608,6 +663,14 @@
> pci_assign_unassigned_resources(void) {
>  	struct pci_bus *bus;
>  
> +	/*
> +	 * Try to release leaf bridge's resources that there is not
> child
> +	 * under it
> +	 */
> +	list_for_each_entry(bus, &pci_root_buses, node) {
> +		pci_bus_release_bridges_not_used_res(bus);
> +	}
> +

Also I wonder if we need to make this a command line option that isn't
run by default?

Really, as Eric says, we need a real dynamic allocation system with the
ability to move devices around at some point.  Any volunteers? :)

-- 
Jesse Barnes, Intel Open Source Technology Center
