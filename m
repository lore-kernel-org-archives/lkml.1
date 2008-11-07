Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYKGIRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYKGIRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 03:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYKGIRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 03:17:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:56543 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYKGIRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 03:17:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,563,1220252400"; 
   d="scan'208";a="401043219"
Message-ID: <4913F97E.7030408@intel.com>
Date: Fri, 07 Nov 2008 16:17:02 +0800
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
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081022084531.GP3773@yzhao12-linux.sh.intel.com> <20081106043235.GA30292@kroah.com> <4913AA03.5060807@intel.com> <20081107025032.GA12824@kroah.com> <4913B8A5.5010806@intel.com> <20081107061603.GC3860@kroah.com> <4913F34A.8020805@intel.com> <20081107080222.GA6284@kroah.com>
In-Reply-To: <20081107080222.GA6284@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Nov 07, 2008 at 03:50:34PM +0800, Zhao, Yu wrote:
>> Greg KH wrote:
>>> On Fri, Nov 07, 2008 at 11:40:21AM +0800, Zhao, Yu wrote:
>>>> Greg KH wrote:
>>>>> On Fri, Nov 07, 2008 at 10:37:55AM +0800, Zhao, Yu wrote:
>>>>>> Greg KH wrote:
>>>>>>> This seems like a big problem.  How are we going to know to add these
>>>>>>> command line options for devices we haven't even seen/known about yet?
>>>>>>> How do we know the bus ids aren't going to change between boots (hint,
>>>>>>> they are, pci bus ids change all the time...)
>>>>>>> We need to be able to do this kind of thing dynamically, not fixed at
>>>>>>> boot time, which seems way to early to even know about this, right?
>>>>>>> thanks,
>>>>>>> greg k-h
>>>>>> Yes, I totally agree. Doing things dynamically is better.
>>>>>>
>>>>>> The purpose of these parameters is to rebalance and align resources for 
>>>>>> device that has BARs encapsulated in various new capabilities (SR-IOV, 
>>>>>> etc.), because most of existing BIOSes don't take care of those BARs.
>>>>> But how are you going to know what the proper device ids are going to
>>>>> be before the machine boots?  I don't see how these options are ever
>>>>> going to work properly for a "real" user.
>>>>>> If we do resource rebalance after system is up, do you think there is 
>>>>>> any side effect or impact to other subsystem other than PCI (e.g. 
>>>>>> MTRR)?
>>>>> I don't think so.
>>>>>> I haven't had much thinking on the dynamical resource rebalance. If you 
>>>>>> have any idea about this, can you please suggest?
>>>>> Yeah, it's going to be hard :)
>>>>> We've thought about this in the past, and even Microsoft said it was
>>>>> going to happen for Vista, but they realized in the end, like we did a
>>>>> few years previously, that it would require full support of all PCI
>>>>> drivers as well (if you rebalance stuff that is already bound to a
>>>>> driver.)  So they dropped it.
>>>>> When would you want to do this kind of rebalancing?  Before any PCI
>>>>> driver is bound to any devices?  Or afterwards?
>>>> I guess if we want the rebalance dynamic, then we should have it full -- 
>>>> the rebalance would be functional even after the driver is loaded.
>>>>
>>>> But in most cases, there will be problem when we unload driver from a 
>>>> hard disk controller, etc. We can mount root on a ramdisk and do the 
>>>> rebalance there, but it's complicated for a real user.
>>>>
>>>> So looks like doing rebalancing before any driver is bound to any device 
>>>> is also a nice idea, if user can get a shell to do rebalance before 
>>>> built-in PCI driver grabs device.
>>> That's not going to work, it needs to happen before any PCI device is
>>> bound, which is before init runs.
>> I don't think it can work either. Then we have to do rebalance after the 
>> driver bounding. But what should we do if we can't unload the driver (hard 
>> disk controller, etc.)?
> 
> Well, to do it "correctly" you are going to have to tell the driver to
> shut itself down, and reinitialize itself.
> 
> Turns out, that doesn't really work for disk and network devices without
> dropping the connection (well, network devices should be fine probably).
> 
> So you just can't do this, sorry.  That's why the BIOS handles all of
> these issues in a PCI hotplug system.
> 
> How does the hardware people think we are going to handle this in the
> OS?  It's not something that any operating system can do, is it part of
> the IOV PCI spec somewhere?

No, it's not part of the PCI IOV spec.

I just want the IOV (and whole PCI subsystem) have more flexibility on 
various BIOSes. So can we reconsider about resource rebalance as boot 
option, or should we forget about this idea?

Regards,
Yu
