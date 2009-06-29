Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbZF2KT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbZF2KT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbZF2KTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:19:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60451 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096AbZF2KTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:19:49 -0400
Message-ID: <4A4895A3.5040402@redhat.com>
Date: Mon, 29 Jun 2009 13:21:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCHv2] kvm: remove in_range and switch to rwsem for iobus
References: <20090628193425.GA14204@redhat.com> <4A487D2C.2020007@redhat.com> <20090629094146.GC19167@redhat.com> <4A488F2C.2060400@redhat.com> <20090629100645.GE19167@redhat.com>
In-Reply-To: <20090629100645.GE19167@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2009 01:06 PM, Michael S. Tsirkin wrote:
>>> 2. if I do it before in_range removal it's a lot of churn:
>>> one of the reasons for code reorg is so that there are less
>>> places to change locking.
>>>
>>>
>>>
>>>        
>> I don't think you really need to change anything.  slots_lock is already
>> taken (except where you modify the list).
>>      
>
> Are you sure about this? I don't understand the code well enough, so
> this reuse of an apparently unrelated lock just makes me nervious.  For
> example what about emulate_instruction? It is sometimes called from
> svm/vmx without slot lock ...
>    

vcpu context always has slots lock taken IIRC, except when in guest mode.

It's not an unrelated lock; slots lock locks memory hotplug, we extend 
it to lock mmio_bus and io_bus hotplug.

I'd really like to avoid a proliferation of locks.

>> How about this:
>>
>> 1. add slots_lock for write when modifying the list
>> 2. change the api
>> 3. drop kvm->lock
>>
>> ?
>>      
>
> Looks like I will just have to bite the bullet and switch to RCU.
>
>    

You still need a lock to prevent concurrent modifications to mmio_bus 
(but can use kvm->lock for this).


-- 
error compiling committee.c: too many arguments to function

