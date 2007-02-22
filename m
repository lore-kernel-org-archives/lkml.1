Return-Path: <linux-kernel-owner+w=401wt.eu-S1751588AbXBVNFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbXBVNFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 08:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbXBVNFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 08:05:15 -0500
Received: from il.qumranet.com ([82.166.9.18]:54727 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbXBVNFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 08:05:12 -0500
Message-ID: <45DD94D3.4030102@qumranet.com>
Date: Thu, 22 Feb 2007 15:04:19 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Dor Laor <dor.laor@qumranet.com>, Pavel Machek <pavel@ucw.cz>,
       kvm-devel@lists.sourceforge.net, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 10/13] KVM: Wire up hypercall handlers to
 a	central arch-independent location
References: <45D979D3.2020907@qumranet.com>	 <20070219103052.4D23725016B@il.qumranet.com><20070221103733.GI3945@ucw.cz>	 <45DD6CF0.3010509@qumranet.com>	 <64F9B87B6B770947A9F8391472E032160A91BAF3@ehost011-8.exch011.intermedia.net>	 <1172140490.3531.236.camel@laptopd505.fenrus.org>	 <45DD7330.1030001@qumranet.com> <1172142081.3531.243.camel@laptopd505.fenrus.org>
In-Reply-To: <1172142081.3531.243.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:

> - execution of hypercall handlers outside vcpu_load() (so they are 
> > preemptible and sleepable)
>   
>
> I don't need this; most of my hypercalls are non-blocking. The ones that
> are can already undo the load themselves, no big deal.
>   

I don't really like exposing the vcpu_load()/vcpu_put() interfaces.

On the other hand, sleeping in a hypercall means the guest vcpu is not 
doing any processing.  Maybe we should declare hypercall handlers atomic 
and let them use a workqueue if they can't be atomic.

On the third hand, sleeping in a hypercall should be a rare event, so 
forcing hypercall handlers to handle the sleeping case introduces a lot 
of complexity for marginal gain.

>> - passing unhandled hypercalls to userspace for qemu-based devices
>>     
>
> hm could do I suppose
>   

One user would be the opengl guest to host tunneling driver/device 
that's being developed for qemu.

> One thing I'd like to see is some way to do batched hypercalls. I don't
> quite know how this will work in general, but let me explain the
> scenario:
> The guest submits a bunch of disk IO requests into a submit queue.
> The host gets a hypercall and goes to process the submit queue
> While this is processing, the guest submits more IO
> The guest would here do another hypercall.. 
>
> .. but what could be done is have the host poll at the end of it's scan
> of the queue if there's more, and while the host is scanning, just
> disable the hypercall the guest would make. So that if there is a
> "submit while scanning/processing" going on, no need for more
> hypercalls. 
>   

Xen does exactly that.  It's actually outside the scope of hypercalls, 
and more related to the protocol between guest and host.  Not that it 
can't be made generic (and the Xen rings are).

Maybe we should just copy the code.

> (Otoh... the current situation isn't all that bad, there's one hypercall
> for an entire batch of IO's, and the blocklayer isn't all that bad at
> giving us nice large batches)
>   

True.  I expect it's more necessary with networking.

Somthing else that came up in a conversation with Dor: the need for a 
clean way to raise a guest interrupt.  The guest may be sleeping in 
userspace, scheduled out, or running on another cpu (and requiring an 
ipi to get it out of guest mode).

Right now I'm thinking about using the signal machinery since it appears 
to do exactly the right thing.

-- 
error compiling committee.c: too many arguments to function

