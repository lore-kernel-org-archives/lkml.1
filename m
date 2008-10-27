Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbYJ0HoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbYJ0HoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 03:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYJ0Hny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 03:43:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:47050 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbYJ0Hnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 03:43:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,491,1220252400"; 
   d="scan'208";a="455764556"
Message-ID: <49057136.9090107@intel.com>
Date: Mon, 27 Oct 2008 15:43:50 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Yu Zhao <yu.zhao@uniscape.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Rakib Mullick <rakib.mullick@gmail.com>
Subject: Re: [PATCH] pci: Fixing drivers/pci/search.c compilation warning.
References: <b9df5fa10809280816u23ef3021k7eee287a237b72ae@mail.gmail.com> <20080928163211.GR27204@parisc-linux.org> <20081021011308.GA3889@parisc-linux.org> <490467CD.3000402@uniscape.net> <20081026183412.GX26094@parisc-linux.org> <49053313.9080706@intel.com> <20081027070745.GY26094@parisc-linux.org> <49056A2F.6030206@intel.com> <20081027072137.GZ26094@parisc-linux.org> <49056EF6.3000904@intel.com>
In-Reply-To: <49056EF6.3000904@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhao, Yu wrote:
> Matthew Wilcox wrote:
>> On Mon, Oct 27, 2008 at 03:13:51PM +0800, Zhao, Yu wrote:
>>> Matthew Wilcox wrote:
>>>> On Mon, Oct 27, 2008 at 11:18:43AM +0800, Zhao, Yu wrote:
>>>>> Matthew Wilcox wrote:
>>>>>> Yes, that's why pci_find_device() is deprecated.  But it doesn't also
>>>>>> need to be buggy ;-)
>>>>> How about pci_get_bus_and_slot()? People would meet the problem with it 
>>>>> anyway.
>>>> What problem with it?  It's documented to return the device with an
>>>> increased refcount, and the implementation appears to do exactly that:
>>>>
>>> The 'dev' returned by pci_get_device() may be destroyed by PCI hotplug. 
>>> I suppose that passing this 'dev' to pci_get_device() in the next loop 
>>> would crash the system, right?
>> Erm, no, the 'dev' cannot be destroyed because the caller has a refcount
>> on it.  The physical device backing it might have gone away.  The dev
> 
> Why does the caller have a reference count? I don't see we increase the 
> reference count after the 'dev' is returned by following in 
> pci_get_dev_by_id():
> 
>          dev = bus_find_device(&pci_bus_type, dev_start, (void *)id,
>                                match_pci_dev_by_id);
> 
> And this 'dev' becomes the 'from' in the next loop, but it may be 
> destroyed before the 'pci_dev_get(from)', isn't it?

I checked the source code, there is no 'pci_dev_get(from)', the 
reference count is increased in bus_find_device().

         while ((dev = next_device(&i)))
                 if (match(dev, data) && get_device(dev))

But the essential problem is same: the reference count of 'dev' above 
may be decreased before the 'get_device(dev)', I guess.
