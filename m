Return-Path: <linux-kernel-owner+w=401wt.eu-S1765411AbYESNjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765411AbYESNjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763090AbYESN0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:26:18 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:11499
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763066AbYESN0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:26:17 -0400
Message-ID: <48317FF7.1020707@qumranet.com>
Date: Mon, 19 May 2008 16:26:15 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Mark McLoughlin <markmc@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_net: free transmit skbs in a timer
References: <1209565906-9019-1-git-send-email-markmc@redhat.com> <200805191152.28409.rusty@rustcorp.com.au> <483155D4.2090700@qumranet.com> <200805192221.52072.rusty@rustcorp.com.au>
In-Reply-To: <200805192221.52072.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>>>
>>> Well, we do have such a thing, in the ring suppression flags.
>>>       
>> Can you point me at this?
>>     
>
> Ah, sorry, I misunderstood.  No, we don't have a threshold like this, we
> have an all-or-nothing flag in each direction.
>
>   

Please point me anyway?

> We have the ability to add new fields to the rings.  I've put it on my
> TODO to benchmark what this does.  It may or may not help.  In this case,
> notification when there are no more packets in xmit ring would be
> sufficient.  We already kick the host when we fill a ring even if
> it says it doesn't need it, perhaps this would be symmetry.
>   

Notification on ring full is too late with smp.  You need to warn the 
other side in advance.

The reason I'm interested in adjustable thresholds is that you can then 
to tx mitigation without (usually) suffering the worst-case latency when 
you aren't streaming or streaming slower than what you tuned for.

>   
>>>   Note that DaveM
>>> is talking about moving network tx queue into the net drivers themselves,
>>> which will make them much more efficient (ie. drain entire queue before
>>> kick), which may again change the balance of what the Right Thing is.
>>>       
>> That depends on whether Linux knows whether more packets are coming.
>>     
>
> The current problem is that hard_start_xmit gets called with a packet, and 
> has no idea if there are more in the tx queue.  By having the driver control
> the queue, it can at least tell that.
>   

Yes, definitely an improvement, esp. for sendfile().

> The question remains whether this will be sufficient for tx mitigation.  A
> program may be about to write more to the socket, and we can't know that.
> But it can hardly hurt.
>
>   

Right.

-- 
error compiling committee.c: too many arguments to function

