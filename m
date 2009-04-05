Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbZDEQpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbZDEQpc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 12:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZDEQpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 12:45:20 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:20673 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZDEQpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 12:45:18 -0400
Message-ID: <49D8E018.8050907@codemonkey.ws>
Date: Sun, 05 Apr 2009 11:45:12 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       agraf@suse.de, pmullaney@novell.com, pmorreale@novell.com,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <200904011638.45135.rusty@rustcorp.com.au> <49D391F5.4080700@codemonkey.ws> <200904051314.23170.rusty@rustcorp.com.au> <49D8BC87.8030401@codemonkey.ws> <49D8D809.8040503@redhat.com>
In-Reply-To: <49D8D809.8040503@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Anthony Liguori wrote:
>>
>> What we need is:
>>
>> 1) Lockless MMIO/PIO dispatch (there should be two IO registration 
>> interfaces, a new lockless one and the legacy one)
>
> Not sure exactly how much this is needed, since when there is no 
> contention, locks are almost free (there's the atomic and cacheline 
> bounce, but no syscall).

There should be no contention but I strongly suspect there is more often 
than we think.  The IO thread can potentially hold the lock for a very 
long period of time.  Take into consideration things like qcow2 metadata 
read/write, VNC server updates, etc..

> For any long operations, we should drop the lock (of course we need 
> some kind of read/write lock or rcu to avoid hotunplug or 
> reconfiguration).
>
>> 2) A virtio-net thread that's independent of the IO thread.
>
> Yes -- that saves us all the select() prologue (calculating new 
> timeout) and the select() itself.

In an ideal world, we could do the submission via io_submit in the VCPU 
context, not worry about the copy latency (because we're zero copy).  
Then our packet transmission latency is consistently low because the 
path is consistent and lockless.  This is why dropping the lock is so 
important, it's not enough to usually have low latency.  We need to try 
and have latency as low as possible as often as possible.

Regards,

Anthony Liguori
>
>

