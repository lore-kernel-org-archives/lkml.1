Return-Path: <linux-kernel-owner+w=401wt.eu-S1763902AbZAGXSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763902AbZAGXSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763410AbZAGXPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:15:19 -0500
Received: from mail.impinj.com ([206.169.229.170]:57187 "EHLO earth.impinj.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762721AbZAGXPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:15:15 -0500
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Jan 2009 18:15:15 EST
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: thomas.dahlmann@amd.com
Subject: amd5536udc interrupts bug
Date: Wed, 7 Jan 2009 15:10:00 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.9-159.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901071510.00673.vlobanov@speakeasy.net>
X-OriginalArrivalTime: 07 Jan 2009 23:10:00.0951 (UTC) FILETIME=[10F8F070:01C9711D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

>From perusing the code and playing with the module, it seems to me that 
the amd5536udc driver's handling of interrupts is currently "bustificated".

The long story:

During the amd5536udc initialization sequence within udc_pci_probe(), 
the code attempts to request a shared irq for the device thusly:
	request_irq(pdev->irq, udc_irq, IRQF_SHARED, name, dev)
where 'dev' is the internal state structure. By the time this call is made, 
the 'dev' structure is still not fully initialized and contains blank/zero 
data for many of the fields, in particular both 'dev->lock' and 'dev->regs' 
which are both clearly used within the udc_irq() handler. Those get 
initialized a bit later, namely inside the udc_probe() call at the bottom of 
udc_pci_probe().

It is my understanding that a handler for a shared interrupt can be 
invoked at any time after the corresponding request_irq() call is made, 
simply because some other device on the same interrupt may already 
be active. This leaves us with a very noticeable race condition, where 
udc_irq() can be invoked with uninitialized 'dev' data.

In particular, this effect is very noticeable when I try modprobing the 
amd5536udc driver on a kernel that is built with CONFIG_DEBUG_SHIRQ 
set. Given that the debug config option forces an invocation of the irq 
handler from within the request_irq() function, the immediate effect is a 
masterful kernel NULL-dereference OOPS within udc_irq().

The simple fix may be to say that amd5536udc does not support shared 
irqs, and to remove the IRQF_SHARED flag from the request_irq() call. A 
more complicated fix may be to try to shuffle all the code around to 
make sure that 'dev' is fully initialized before we request the irq, but I 
don't understand the code well enough (yet) to comfortably do this.

Comments? Thoughts?

On a side note, it occurs to me that the CONFIG_DEBUG_SHIRQ option 
went into the kernel a bit less than two years ago, and that it exposes a 
very immediate and reproducible OOPS in this driver. Does this mean 
that noone uses the 5536 UDC functionality with any recent kernels? 
Should I be worried? :)

-- Vadim Lobanov

