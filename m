Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbYKGHut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbYKGHut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 02:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYKGHui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 02:50:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:20648 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYKGHuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 02:50:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,563,1220252400"; 
   d="scan'208";a="636597826"
Message-ID: <4913F34A.8020805@intel.com>
Date: Fri, 07 Nov 2008 15:50:34 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 16/16 v6] PCI: document the new PCI boot parameters
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081022084531.GP3773@yzhao12-linux.sh.intel.com> <20081106043235.GA30292@kroah.com> <4913AA03.5060807@intel.com> <20081107025032.GA12824@kroah.com> <4913B8A5.5010806@intel.com> <20081107061603.GC3860@kroah.com>
In-Reply-To: <20081107061603.GC3860@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Nov 07, 2008 at 11:40:21AM +0800, Zhao, Yu wrote:
>> Greg KH wrote:
>>> On Fri, Nov 07, 2008 at 10:37:55AM +0800, Zhao, Yu wrote:
>>>> Greg KH wrote:
>>>>> On Wed, Oct 22, 2008 at 04:45:31PM +0800, Yu Zhao wrote:
>>>>>>  Documentation/kernel-parameters.txt |   10 ++++++++++
>>>>>>  1 files changed, 10 insertions(+), 0 deletions(-)
>>>>>>
>>>>>> diff --git a/Documentation/kernel-parameters.txt 
>>>>>> b/Documentation/kernel-parameters.txt
>>>>>> index 53ba7c7..5482ae0 100644
>>>>>> --- a/Documentation/kernel-parameters.txt
>>>>>> +++ b/Documentation/kernel-parameters.txt
>>>>>> @@ -1677,6 +1677,16 @@ and is between 256 and 4096 characters. It is 
>>>>>> defined in the file
>>>>>>  		cbmemsize=nn[KMG]	The fixed amount of bus space which is
>>>>>>  				reserved for the CardBus bridge's memory
>>>>>>  				window. The default value is 64 megabytes.
>>>>>> +		assign-mmio=[dddd:]bb	[X86] reassign memory resources of all
>>>>>> +				devices under bus [dddd:]bb (dddd is the domain
>>>>>> +				number and bb is the bus number).
>>>>>> +		assign-pio=[dddd:]bb	[X86] reassign io port resources of all
>>>>>> +				devices under bus [dddd:]bb (dddd is the domain
>>>>>> +				number and bb is the bus number).
>>>>>> +		align-mmio=[dddd:]bb:dd.f  [X86] relocate memory resources of a
>>>>>> +				device to minimum PAGE_SIZE alignment (dddd is
>>>>>> +				the domain number and bb, dd and f is the bus,
>>>>>> +				device and function number).
>>>>> This seems like a big problem.  How are we going to know to add these
>>>>> command line options for devices we haven't even seen/known about yet?
>>>>> How do we know the bus ids aren't going to change between boots (hint,
>>>>> they are, pci bus ids change all the time...)
>>>>> We need to be able to do this kind of thing dynamically, not fixed at
>>>>> boot time, which seems way to early to even know about this, right?
>>>>> thanks,
>>>>> greg k-h
>>>> Yes, I totally agree. Doing things dynamically is better.
>>>>
>>>> The purpose of these parameters is to rebalance and align resources for 
>>>> device that has BARs encapsulated in various new capabilities (SR-IOV, 
>>>> etc.), because most of existing BIOSes don't take care of those BARs.
>>> But how are you going to know what the proper device ids are going to
>>> be before the machine boots?  I don't see how these options are ever
>>> going to work properly for a "real" user.
>>>> If we do resource rebalance after system is up, do you think there is any 
>>>> side effect or impact to other subsystem other than PCI (e.g. MTRR)?
>>> I don't think so.
>>>> I haven't had much thinking on the dynamical resource rebalance. If you 
>>>> have any idea about this, can you please suggest?
>>> Yeah, it's going to be hard :)
>>> We've thought about this in the past, and even Microsoft said it was
>>> going to happen for Vista, but they realized in the end, like we did a
>>> few years previously, that it would require full support of all PCI
>>> drivers as well (if you rebalance stuff that is already bound to a
>>> driver.)  So they dropped it.
>>> When would you want to do this kind of rebalancing?  Before any PCI
>>> driver is bound to any devices?  Or afterwards?
>> I guess if we want the rebalance dynamic, then we should have it full -- 
>> the rebalance would be functional even after the driver is loaded.
>>
>> But in most cases, there will be problem when we unload driver from a hard 
>> disk controller, etc. We can mount root on a ramdisk and do the rebalance 
>> there, but it's complicated for a real user.
>>
>> So looks like doing rebalancing before any driver is bound to any device is 
>> also a nice idea, if user can get a shell to do rebalance before built-in 
>> PCI driver grabs device.
> 
> That's not going to work, it needs to happen before any PCI device is
> bound, which is before init runs.

I don't think it can work either. Then we have to do rebalance after the 
driver bounding. But what should we do if we can't unload the driver 
(hard disk controller, etc.)?

Thanks,
Yu
