Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbZJZTir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbZJZTir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbZJZTiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:38:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:49589 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977AbZJZTip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:38:45 -0400
Message-ID: <4AE5FAB0.6070108@kernel.org>
Date: Mon, 26 Oct 2009 12:38:24 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] pci: only release that resource index is less than 3
References: <4AE2C827.8040905@kernel.org> <200910261032.58231.bjorn.helgaas@hp.com>
In-Reply-To: <200910261032.58231.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Saturday 24 October 2009 03:25:59 am Yinghai Lu wrote:
>> after
>>
>> | commit 308cf8e13f42f476dfd6552aeff58fdc0788e566
>> |
>> |    PCI: get larger bridge ranges when space is available
>>
>> found one of resource of peer root bus (0x00) get released from root
>> resource. later one hotplug device can not get big range anymore.
>> other peer root buses is ok.
>>
>> it turns out it is from transparent path.
>>
>> those resources will be used for pci bridge BAR updated.
>> so need to limit it to 3.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  drivers/pci/setup-bus.c |    9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6/drivers/pci/setup-bus.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/pci/setup-bus.c
>> +++ linux-2.6/drivers/pci/setup-bus.c
>> @@ -344,9 +344,14 @@ static struct resource *find_free_bus_re
>>  			 * if there is no child under that, we should release
>>  			 * and use it. don't need to reset it, pbus_size_* will
>>  			 * set it again
>> +			 * need to be less 3, otherwise can not write it to
>> +			 * bridge, also need to avoid releasing it from
>> +			 * transparent bus path
>>  			 */
>> -			if (!r->child && !release_resource(r))
>> -				return r;
>> +			if (i < 3 && !r->child) {
>> +				if (!release_resource(r))
>> +					return r;
>> +			}
> 
> I am bewildered.
> 
> 308cf8e13f42f added the release_resource() call here in
> find_free_bus_resource().  I don't understand why the release
> should be there in the first place -- it doesn't seem to
> logically fit there.  A "release" should be connected to an
> event, maybe a hot-remove or a move of a device from one place
> to another.  It shouldn't be something we do as a side-effect
> of searching for a free resource.

system with several IOHs, and one pci bridge under one IOH,

one of device under that bridge request big range 256M, and the bridge can not find range it, so the device BAR is not initialized. and the bridge already some range preallocated ( about 8M ) for future hotplug support.

so need to release the resource used by that bridge, so it could get new one.

> 
> Now you're adding the magic number "3", which seems even less
> related to the job of "finding an available bus resource."  I'm
> guessing the "3" is related to PCI_BRIDGE_RESOURCES or something,
> but that should be made explicit, and I really don't think it
> belongs in this function.

find_free_bus_resource is only needed by pbus_size_io and bus_size_mem with pci bridge (not card bus) to find position of 
bridge BAR, so later could update corresponding BAR.

YH
