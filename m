Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbXKJWH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbXKJWH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 17:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbXKJWHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 17:07:52 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:30478 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544AbXKJWHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 17:07:51 -0500
Message-ID: <47362BC6.2080704@codemonkey.ws>
Date: Sat, 10 Nov 2007 16:08:06 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org,
       Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio config_ops refactoring
References: <4730A8F3.6020008@us.ibm.com> <200711092254.08099.rusty@rustcorp.com.au> <4734F122.8000102@codemonkey.ws> <200711101858.19069.rusty@rustcorp.com.au>
In-Reply-To: <200711101858.19069.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Saturday 10 November 2007 10:45:38 Anthony Liguori wrote:
>   
>> The problem is the ABI.  We can either require that PCI configuration
>> values are accessed with natural instructions, or it makes very little
>> sense to use the PCI configuration space for virtio configuration
>> information.
>>     
>
> To me it seems logical and simplest to allow any accesses, lay out your 
> structure and emulate it in the obvious way.
>   

Okay, I've got some updates that I'm going to send out now to the PCI 
virtio driver but I'll also change it to switch over to a memory 
layout.  It's not the best PCI ABI but I can certainly live with it.

> You can put the configuration information somewhere else, but the PCI config 
> space seems the logical place.
>   

If we're treating the PCI config space as an opaque memory blob, instead 
of as distinct registers, I think it makes more sense to just put it in 
memory.  In the backend, I have to treat it as a memory blob anyway and 
using the PCI config space just means that I have to write all the 
various PIO handlers for the different access sizes.  It's much more 
elegant in my mind just to have the driver provide some memory that the 
host fills out.

Thanks for all the review,

Anthony Liguori

>> Either virtio config looks like a shared memory area (as lguest
>> currently implements it), or it looks like hardware registers (like
>> virtio-pci implements it).  After thinking about it for a while, I don't
>> think the two can be reconciled.  There are subtle differences between
>> the two that can't be hidden in the virtio interface.  For instance, in
>> the PCI model, you get notified when values are read/written whereas in
>> the lguest model, you don't and need explicit status bits.
>>     
>
> No.  You need those status bits even if you have your register model, 
> otherwise you can't tell when the configuration as a whole is stable.  
> Consider the feature bits.  Worse, consider extending the feature bits beyond 
> 32 bits.
>
> (We will have to deal with dynamic configuration changes in future; I was 
> planning on using some status bits.  But it's pretty clear that it's going to 
> require an explicit ack of some form.)
>
> Hope that clarifies,
> Rusty.
>
>   

