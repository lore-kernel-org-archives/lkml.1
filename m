Return-Path: <linux-kernel-owner+w=401wt.eu-S1764064AbZDAQLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764064AbZDAQLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761621AbZDAQKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:10:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:16192 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759077AbZDAQKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:10:37 -0400
Message-ID: <49D391F5.4080700@codemonkey.ws>
Date: Wed, 01 Apr 2009 11:10:29 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       agraf@suse.de, pmullaney@novell.com, pmorreale@novell.com,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <200904011638.45135.rusty@rustcorp.com.au>
In-Reply-To: <200904011638.45135.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 01 April 2009 05:12:47 Gregory Haskins wrote:
>   
>> Bare metal: tput = 4078Mb/s, round-trip = 25593pps (39us rtt)
>> Virtio-net: tput = 4003Mb/s, round-trip = 320pps (3125us rtt)
>> Venet: tput = 4050Mb/s, round-trip = 15255 (65us rtt)
>>     
>
> That rtt time is awful.  I know the notification suppression heuristic
> in qemu sucks.
>
> I could dig through the code, but I'll ask directly: what heuristic do
> you use for notification prevention in your venet_tap driver?
>
> As you point out, 350-450 is possible, which is still bad, and it's at least
> partially caused by the exit to userspace and two system calls.  If virtio_net
> had a backend in the kernel, we'd be able to compare numbers properly.
>   

I doubt the userspace exit is the problem.  On a modern system, it takes 
about 1us to do a light-weight exit and about 2us to do a heavy-weight 
exit.  A transition to userspace is only about ~150ns, the bulk of the 
additional heavy-weight exit cost is from vcpu_put() within KVM.

If you were to switch to another kernel thread, and I'm pretty sure you 
have to, you're going to still see about a 2us exit cost.  Even if you 
factor in the two syscalls, we're still talking about less than .5us 
that you're saving.  Avi mentioned he had some ideas to allow in-kernel 
thread switching without taking a heavy-weight exit but suffice to say, 
we can't do that today.

You have no easy way to generate PCI interrupts in the kernel either.  
You'll most certainly have to drop down to userspace anyway for that.

I believe the real issue is that we cannot get enough information today 
from tun/tap to do proper notification prevention b/c we don't know when 
the packet processing is completed.

Regards,

Anthony Liguori
