Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbZAHCdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbZAHCdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 21:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZAHCdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 21:33:03 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:23530 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbZAHCdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 21:33:01 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=lD5b3MEmRmoQRtdQgecA:9 a=VoucYKxsr7XzKVlZSPkA:7 a=u0QhTJboIn9190GctCZ3RsoJEpQA:4
Message-ID: <496565D9.6040102@shaw.ca>
Date: Wed, 07 Jan 2009 20:32:57 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Vadim Lobanov <vlobanov@speakeasy.net>
CC: thomas.dahlmann@amd.com, linux-kernel@vger.kernel.org
Subject: Re: amd5536udc interrupts bug
References: <200901071510.00673.vlobanov@speakeasy.net>
In-Reply-To: <200901071510.00673.vlobanov@speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vadim Lobanov wrote:
> Hello,
> 
> From perusing the code and playing with the module, it seems to me that 
> the amd5536udc driver's handling of interrupts is currently "bustificated".
> 
> The long story:
> 
> During the amd5536udc initialization sequence within udc_pci_probe(), 
> the code attempts to request a shared irq for the device thusly:
> 	request_irq(pdev->irq, udc_irq, IRQF_SHARED, name, dev)
> where 'dev' is the internal state structure. By the time this call is made, 
> the 'dev' structure is still not fully initialized and contains blank/zero 
> data for many of the fields, in particular both 'dev->lock' and 'dev->regs' 
> which are both clearly used within the udc_irq() handler. Those get 
> initialized a bit later, namely inside the udc_probe() call at the bottom of 
> udc_pci_probe().
> 
> It is my understanding that a handler for a shared interrupt can be 
> invoked at any time after the corresponding request_irq() call is made, 
> simply because some other device on the same interrupt may already 
> be active. This leaves us with a very noticeable race condition, where 
> udc_irq() can be invoked with uninitialized 'dev' data.

Yes, your analysis appears correct.

> 
> In particular, this effect is very noticeable when I try modprobing the 
> amd5536udc driver on a kernel that is built with CONFIG_DEBUG_SHIRQ 
> set. Given that the debug config option forces an invocation of the irq 
> handler from within the request_irq() function, the immediate effect is a 
> masterful kernel NULL-dereference OOPS within udc_irq().
> 
> The simple fix may be to say that amd5536udc does not support shared 
> irqs, and to remove the IRQF_SHARED flag from the request_irq() call. A 

That will bust any other hardware that tries to share the interrupt. If 
a driver requests the interrupt without IRQF_SHARED, nothing else can 
request that interrupt line.

> more complicated fix may be to try to shuffle all the code around to 
> make sure that 'dev' is fully initialized before we request the irq, but I 
> don't understand the code well enough (yet) to comfortably do this.

Yeah, that's the proper fix.

> 
> Comments? Thoughts?
> 
> On a side note, it occurs to me that the CONFIG_DEBUG_SHIRQ option 
> went into the kernel a bit less than two years ago, and that it exposes a 
> very immediate and reproducible OOPS in this driver. Does this mean 
> that noone uses the 5536 UDC functionality with any recent kernels? 
> Should I be worried? :)

Presumably nobody uses it with CONFIG_DEBUG_SHIRQ, that option wouldn't 
normally be used on non-debug kernels..

> 
> -- Vadim Lobanov
> 

