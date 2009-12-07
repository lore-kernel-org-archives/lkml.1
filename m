Return-Path: <linux-kernel-owner+w=401wt.eu-S965120AbZLGV6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965120AbZLGV6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 16:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965103AbZLGV6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 16:58:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:59796 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965094AbZLGV6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 16:58:35 -0500
Message-ID: <4B1D7A49.6050608@kernel.org>
Date: Mon, 07 Dec 2009 13:57:29 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: patrick.keller@hp.com
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Chiang, Alexander" <achiang@hp.com>,
       "Helgaas, Bjorn" <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 1/2] pci: pci_bridge_release_res
References: <4ADEB601.8020200@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	 <m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	 <4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	 <4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	 <4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon>	 <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org>	 <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org>	 <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org>	 <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org>	 <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org>	 <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org>	 <4B0B3C13.9030502@jp.fujit! su.com> <4B0C69AD.3030106@kernel. org>	 <4B0D13EB.9010403@jp.fujitsu.com> <4B10D084.8070608@kernel.org>	 <4B10D30D.3020108@ker! nel.org>  <4B146F0D.7050203@kernel.org> <1260222126.5477.11.camel@pLaptop>
In-Reply-To: <1260222126.5477.11.camel@pLaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Keller wrote:
> 
> On Tue, 2009-12-01 at 01:19 +0000, Yinghai Lu wrote:
>> need to apply this after 9/9 patchset
>>
>> prepare for pciehp_realloc
>>
>> it will clear the resource size for bridge
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  drivers/pci/setup-bus.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/pci.h     |    1 +
>>  2 files changed, 43 insertions(+)
>>
>> Index: linux-2.6/drivers/pci/setup-bus.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/pci/setup-bus.c
>> +++ linux-2.6/drivers/pci/setup-bus.c
>> @@ -739,6 +739,48 @@ static void __ref __pci_bridge_assign_re
>>  		break;
>>  	}
>>  }
>> +
>> +void pci_bridge_release_res(struct pci_bus *bus)
>> +{
>> +	int idx;
>> +	bool changed = false;
>> +	struct pci_dev *dev;
>> +	struct resource *r;
>> +
>> +	/* The root bus? */
>> +	if (!bus->self)
>> +		return;
>> +
>> +	/* for pci bridges res only */
>> +	dev = bus->self;
>> +	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_PCI)
>> +		return;
>> +
>> +	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_BRIDGE_RESOURCES + 3;
>> +	     idx++) {
>> +		r = &dev->resource[idx];
>> +		if (!r->parent)
>> +			continue;
>> +
>> +		/* if there are children under that, we should not release it */
>> +		if (r->child)
>> +			continue;
>> +
>> +		if (!release_resource(r)) {
>> +			dev_printk(KERN_DEBUG, &dev->dev,
>> +				 "resource %d %pR released\n", idx, r);
>> +			/* old size is not kept */
>> +			r->start = 0;
>> +			r->end   = 0;
>> +			r->flags = 0;
>> +			changed = true;
>> +		}
>> +	}
>> +
>> +	if (changed)
>> +		pci_setup_bridge(bus);
>> +}
>> +
> 
> Need to add EXPORT_SYMBOL(pci_bridge_release_res); here so the hotplug
> kernel module will find this function.

thanks, will update that in next round.

YH
