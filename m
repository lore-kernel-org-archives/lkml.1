Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbZF2KHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbZF2KHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZF2KHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:07:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52437 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbZF2KHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:07:15 -0400
Date: Mon, 29 Jun 2009 13:06:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCHv2] kvm: remove in_range and switch to rwsem for iobus
Message-ID: <20090629100645.GE19167@redhat.com>
References: <20090628193425.GA14204@redhat.com> <4A487D2C.2020007@redhat.com> <20090629094146.GC19167@redhat.com> <4A488F2C.2060400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A488F2C.2060400@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 12:53:48PM +0300, Avi Kivity wrote:
> On 06/29/2009 12:41 PM, Michael S. Tsirkin wrote:
>> On Mon, Jun 29, 2009 at 11:37:00AM +0300, Avi Kivity wrote:
>>    
>>> On 06/28/2009 10:34 PM, Michael S. Tsirkin wrote:
>>>      
>>>> This changes bus accesses to use high-level kvm_io_bus_read/kvm_io_bus_write
>>>> functions, which utilize read/write semaphore intead of mutex.  in_range now
>>>> becomes unused so it is removed from device ops in favor of read/write
>>>> callbacks performing range checks internally.
>>>>
>>>> This allows aliasing (mostly for in-kernel virtio), as well as better error
>>>> handling by making it possible to pass errors up to userspace. And it's enough
>>>> to look at the diffstat to see that it's a better API anyway.
>>>>
>>>> While we are at it, document locking rules for kvm_io_device_ops.
>>>>
>>>> Note: since the use of the new bus_lock is localized to a small number of
>>>> places, it will be easy to switch to srcu in the future if we so desire.
>>>>
>>>>        
>>> Looks good. But please split into a locking change patch and an API
>>> change patch (in whatever order makes more sense).
>>>      
>>
>> This is harder than it seems. Is this really important?
>>
>> The locking change itself is about 6 lines, but
>> 1. if I do it after in_range removal I get deadlocks
>> as after marcelo's change kvm->lock is taken internally by writers.
>>    
>
> slots_lock is an outer lock to kvm->lock.
>
>> 2. if I do it before in_range removal it's a lot of churn:
>> one of the reasons for code reorg is so that there are less
>> places to change locking.
>>
>>
>>    
>
> I don't think you really need to change anything.  slots_lock is already  
> taken (except where you modify the list).

Are you sure about this? I don't understand the code well enough, so
this reuse of an apparently unrelated lock just makes me nervious.  For
example what about emulate_instruction? It is sometimes called from
svm/vmx without slot lock ...

> How about this:
>
> 1. add slots_lock for write when modifying the list
> 2. change the api
> 3. drop kvm->lock
>
> ?

Looks like I will just have to bite the bullet and switch to RCU.

-- 
MST
