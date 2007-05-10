Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbXEJFdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbXEJFdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbXEJFdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:33:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52658 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbXEJFdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:33:46 -0400
Message-ID: <4642AEB2.5090303@garzik.org>
Date: Thu, 10 May 2007 01:33:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, ak@suse.de, jmorris@namei.org
Subject: Re: [patch 7/9] lguest: the net driver
References: <200705090951.l499pdOr020406@shell0.pdx.osdl.net>	 <4641BE65.3030807@garzik.org> <1178723695.7286.164.camel@localhost.localdomain>
In-Reply-To: <1178723695.7286.164.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Hi Jeff,
> 
> 	Thanks for your review.  Questions below.
> 
> On Wed, 2007-05-09 at 08:28 -0400, Jeff Garzik wrote:
>> akpm@linux-foundation.org wrote:
>>> +static void transfer_packet(struct net_device *dev,
> ...
>>> +	hcall(LHCALL_SEND_DMA, peer_key(info,peernum), __pa(&dma), 0);
>> __pa() should not be used in any driver.
>>
>> At the very least, lguest helper code should wrap this.
> 
> 	I realize your continual battle with this, but adding a layer of
> indirection doesn't seem like it will add clarity.  The issues with
> __pa() are reasonably known (don't hand it a vmalloc address, for
> example).  Any wrapper I create would be another hurdle to jump 8(

You don't want this low level stuff in drivers.

All such details should be hidden away in the arch code, which in your 
case is the lguest support code.

lguest should present a nice, friendly driver API that any Computer 
Science freshman at university will understand.  Because that's the 
level at which we driver writers exist... :)


>>> +static irqreturn_t lguestnet_rcv(int irq, void *dev_id)
> ...
>>> +	return done ? IRQ_HANDLED : IRQ_NONE;
>> Using NAPI would be preferable...
> 
> I'm not so convinced: scheduling tends to give us pretty good interrupt
> mitigation.  However, if you wish to send a patch, I'd be happy to
> benchmark the two 8)

NAPI means system-wide load leveling, across multiple network 
interfaces.  Lack of NAPI can mean competition at higher loads.  Though 
maybe that's less important with lguest.


>>> +	/* Ethernet defaults with some changes */
>>> +	ether_setup(dev);
>>> +	dev->set_mac_address = NULL;
>> why NULL?
> 
> Because it's not implemented: our MAC is advertised in the device page
> and we'd have to change it there too.
> 
> Trivial to do, but is there a compelling reason to implement it?

Bonding, and situations where you /do/ want the MAC address to "leak" 
out of the host onto the wider net.


>>> +	dev->mem_start = ((unsigned long)desc->pfn << PAGE_SHIFT);
>>> +	dev->mem_end = dev->mem_start + PAGE_SIZE * desc->num_pages;
>>> +	dev->irq = lgdev->index+1;
>> don't fill in mem_start, mem_end and irq.  they are useless, and for 
>> lguest, misleading.
> 
> You meant to type "useful and accurate", I think?  They show up in
> ifconfig, so you can see what the underlying devices are using.  They're
> as useful for virtual hardware as they are for physical hardware.

Indeed -- they are useless for physical hardware, as well.

Those items have not been used since the ISA days.  Hardware is far more 
complex than those three variables can provide, so the wise choice is to 
SET_NETDEV_DEV() to your device, which reveals all manner of bus 
information by reference.

Storing information in those variables is needless duplication, which is 
why they have been relegated only to ancient ISA drivers -- or in the 
case of ->mem_start, repurposed as a method of passing options.



>>> +	dev->features = NETIF_F_SG;
>>> +	if (desc->features & LGUEST_NET_F_NOCSUM)
>>> +		dev->features |= NETIF_F_NO_CSUM;
>> do not set SG without an accompanying csum bitflag
> 
> That seems... odd.  My driver can do SG, and may or may not need csums.
> The current Linux code turns SG off if I need csums and that's fine, but
> it hardly seems like my device should be making that decision.

The net stack does not have a safety cushion.  Set the wrong flags, and 
things can and will go wrong.  SG without CSUM support is illogical, and 
can and will break things.  Remember what SG is for.  If you cannot 
offload the csum, you have to build the csum yourself, at which point 
you might as well copy it too.  grep around for skb_copy_and_csum_dev() 
to see if that helps you at all.


>>> +static struct lguest_driver lguestnet_drv = {
>>> +	.name = "lguestnet",
>>> +	.owner = THIS_MODULE,
>>> +	.device_type = LGUEST_DEVICE_T_NET,
>>> +	.probe = lguestnet_probe,
>>> +};
>> You are distinctly missing module remove support
> 
> Yes.  It is never built as a module currently (though it should work).

That's my point.  It won't work as a module, because it lacks remove 
support.  It is not unrealistic to think of [un|re|]loading the net 
support module in an lguest guest.  And, adding module support makes the 
programmer more responsible, because they now have to learn to clean up 
after themselves.  Any driver that cannot clean up after itself is an 
incomplete driver in my book.

	Jeff


