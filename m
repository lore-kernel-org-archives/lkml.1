Return-Path: <linux-kernel-owner+w=401wt.eu-S1766010AbXLMUON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766010AbXLMUON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762714AbXLMUNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:13:53 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:52460 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762196AbXLMUNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:13:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Chdhx4nd1a2agQ7sfaR3gjwmgJq6sI73gEPrXngZ6KoJg/8HK/gdZSiwztfNlBfl62q4eUOl3rB8U2RhNzfmSjoiZ1zd/YHIqM7umdm9soJH5hM6HwgLGhIwqCe5POyG4RukaZp5JleRyT6R60mOVNvWlUhVFKVz3NVRVzOQ3Sg=
Message-ID: <4761930C.3030504@gmail.com>
Date: Thu, 13 Dec 2007 21:16:12 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: auke-jan.h.kok@intel.com, gallatin@myri.com, joonwpark81@gmail.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, jesse.brandeburg@intel.com
Subject: Re: [RFC] net: napi fix
References: <47602B77.2090202@intel.com>	<20071213134953.GA3806@ff.dom.local> <20071213.055013.83963139.davem@davemloft.net>
In-Reply-To: <20071213.055013.83963139.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote, On 12/13/2007 02:50 PM:

> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Thu, 13 Dec 2007 14:49:53 +0100
> 
>> As a matter of fact, since it's "unlikely()" in net_rx_action() anyway,
>> I wonder what is the main reason or gain of leaving such a tricky
>> exception, instead of letting drivers to always decide which is the
>> best moment for napi_complete()? (Or maybe even, in such a case, they
>> should call some function with this list_move_tail() if it's so
>> useful?)
> 
> It is the only sane way to synchronize the list manipulations.
> 
> There has to be a way for ->poll() to tell net_rx_action() two things:
> 
> 1) How much work was completed, so we can adjust 'budget'


The 'budget' line would stay where it is. IMHO, it's only about this
list_move_tail(). (Probably also doing netpoll_poll_unlock()
during n->poll() could be considered to let the driver even destroy
napi just after napi_complete() - but it's another subject.)

> 2) Was the NAPI quota exhausted?  So that we know that
>    net_rx_action() still "owns" the polling context and
>    thus can do the list manipulation safely.
> 
> And these both need to be encoded into one single return value, thus
> the adopted convention that "work == weight" means that the device has
> not done a NAPI complete.

Of course, with some care and explanations to driver maintainers, like in
this case, this all should probably work like it is. But IMHO it would be
easier to remember and maintain if there are some simple rules with no
exceptions, so here e.g. driver always "owns" (with functions like
napi_schedule(), napi_complete(), and maybe napi_move_tail()), and
net_rx_action() only reads the list and runs these functions?!

I see in a nearby thread you would prefer to save some work to drivers
(like this netif_running() check), but I think this all is at the cost
of flexibility, and there will probably appear new problems, when a
driver simply can't wait till the next poll (which btw. looks strange
with all these hotplugging, usb and powersaving).

Regards,
Jarek P.
