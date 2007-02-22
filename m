Return-Path: <linux-kernel-owner+w=401wt.eu-S933081AbXBVOVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081AbXBVOVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 09:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933085AbXBVOVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 09:21:52 -0500
Received: from il.qumranet.com ([82.166.9.18]:47238 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933081AbXBVOVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 09:21:51 -0500
Message-ID: <45DDA6CB.4020603@qumranet.com>
Date: Thu, 22 Feb 2007 16:20:59 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Dor Laor <dor.laor@qumranet.com>, Pavel Machek <pavel@ucw.cz>,
       kvm-devel@lists.sourceforge.net, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 10/13] KVM: Wire up hypercall handlers to
 a	central arch-independent location
References: <45D979D3.2020907@qumranet.com>	 <20070219103052.4D23725016B@il.qumranet.com><20070221103733.GI3945@ucw.cz>	 <45DD6CF0.3010509@qumranet.com>	 <64F9B87B6B770947A9F8391472E032160A91BAF3@ehost011-8.exch011.intermedia.net>	 <1172140490.3531.236.camel@laptopd505.fenrus.org>	 <45DD7330.1030001@qumranet.com>	 <1172142081.3531.243.camel@laptopd505.fenrus.org>	 <45DD94D3.4030102@qumranet.com>	 <1172149924.3531.260.camel@laptopd505.fenrus.org>	 <45DD9A9D.4060500@qumranet.com> <1172153373.3531.268.camel@laptopd505.fenrus.org>
In-Reply-To: <1172153373.3531.268.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>> Can't it be done by a helper function using a timer and a signal (or 
>> whatever mechanism we use to wake up vcpus)?
>>     
>
> one could do that but it's not optimal; if the process DOES get waken up
> earlier, it should take the interrupt then immediately, so that it
> doesn't have to wake up again when the timer fires. 
>
> (in fact it would be nice if the guest could somehow poll at the irq
> mask at waking from idle, so that it wouldn't need a vmexit/entry for
> every such interrupt, but just do the right thing for all pending work)
>
> In addition, yes it'll be a helper function, but since all drivers will
> want the functionality its probably best off in the generic code
>
>   

That's what Xen does (I'm not sure about the timer, but they do avoid 
unnecessary interrupts).  As you can have memory shared between the 
guest and host, it's quite simple:

0. host puts data in ring
1. host sets interrupt timer
2. guest wakes up for unrelated reasons
3. guest sees data in ring, consumes it, and bumps the consumer pointer
4. timer fires, host sees consumer == producer, no need to issue interrupt

They have that code abstracted out and reusable by multiple drivers.

-- 
error compiling committee.c: too many arguments to function

