Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYJGPH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYJGPH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYJGPHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:07:47 -0400
Received: from smtp2a.orange.fr ([80.12.242.140]:35518 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbYJGPHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:07:46 -0400
X-ME-UUID: 20081007150744625.98961700008F@mwinf2a18.orange.fr
Message-ID: <48EB7B39.1020607@cosmosbay.com>
Date: Tue, 07 Oct 2008 17:07:37 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Corey Minyard <minyard@acm.org>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
References: <20081006185026.GA10383@minyard.local> <48EA8197.6080502@cosmosbay.com> <20081006.144002.56418911.davem@davemloft.net> <48EA9A59.1090306@acm.org> <20081007083750.GB17079@2ka.mipt.ru> <48EB6F2D.100@linux-foundation.org> <20081007143346.GA6384@linux.vnet.ibm.com> <48EB7617.3060304@linux-foundation.org>
In-Reply-To: <48EB7617.3060304@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> Paul E. McKenney wrote:
> 
>> But care is required -- SLAB_DESTROY_BY_RCU permits objects to be freed
>> and reallocated while a reader holds a reference.  The only guarantee is
>> that the -type- of the data structure will not change while a reader holds
>> a reference.  With something like UDP, this might well be sufficient.
> 
> Right so after the hash lookup operation you are not assured that the object
> has not been freed or even reallocated for a different purpose. So after
> finding the pointer to the object two things need to happen (under rcu_lock):
> 
> 1. Verify that the object is still in use
> 2. Verify that the object is matching the hash
> 
> If not then the operation needs to be redone because we have a stale hash pointer.

OK... so restart full lookup at the begining of hash chain if we detect
points 1 or 2 invalid.

Not that expensive since everything should be cache hot :)

One has to take care to group all components (keys to compute the hash, 
and the *next* pointer) in one cache line to minimize cache misses,
since we now need to access them all to compute/check hash value.

Now if a freed object is re-inserted with same hash value, 
same hash chain, we'll also restart the lookup, but it is harmless.




