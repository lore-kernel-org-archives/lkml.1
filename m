Return-Path: <linux-kernel-owner+w=401wt.eu-S965494AbXCOFrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965494AbXCOFrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965511AbXCOFrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:47:51 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:39265 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965494AbXCOFru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:47:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Xg8KPEH4z95Q/yWEoKW7qorAn6itHM6JVMUlVOBt/eruB2BMROqZsHvvziqEBzytJWGQ1J0Q3KSE+fPT1RvjP2F+LsCzqvIiYyUQ7xqwYYOXPDrolIQ2tfU1K35blmAyzQC7ZCWAFJkeKeGi2ivpFNyvqgngVAbIH86NO6osPvk=
Message-ID: <45F8DDFE.4080504@gmail.com>
Date: Thu, 15 Mar 2007 14:47:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, michal.k.k.piotrowski@gmail.com,
       linux-ide@vger.kernel.org, tglx@linutronix.de,
       shemminger@linux-foundation.org, mlord@pobox.com,
       linux-pm@lists.osdl.org
CC: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH/RFC] PCI prepare/activate instead of enable to avoid IRQ
 storm and rogue DMA access
References: <20070314152302.GB15600@htj.dyndns.org> <20070314215605.GA7194@flint.arm.linux.org.uk> <45F87863.9040408@garzik.org> <20070314225818.GB7194@flint.arm.linux.org.uk>
In-Reply-To: <20070314225818.GB7194@flint.arm.linux.org.uk>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing Andi, Hi!]

Hello,

Russell King wrote:
> On Wed, Mar 14, 2007 at 06:34:11PM -0400, Jeff Garzik wrote:
>> Russell King wrote:
>>> pci_enable_device() doesn't deal with this; in most PCI setups I've
>>> seen, there is no control at PCI level over whether a device generates
>>> an interrupt on the bus.  Certainly the memory and io command enables
>> PCI grew an interrupt enable while you weren't looking: 
>> PCI_COMMAND_INTX_DISABLE
> 
> That's fine for devices which conform to the later PCI specs, but not
> all do.
> 
>> It was added in PCI 2.3 I think.
> 
> Correct.
> 
>> Older PCI devices certainly do not have this standardized bit.
> 
> No PCI device that I have has that bit - including the raid card I
> bought last year...

Many recent ATA and network controllers do and most new ones will
probably do.

> In any case, relying on such a new control bit to implement this kind
> of functionality would result in a very hit and miss result; Linux
> tends to get used on things other than the bleeding edge of hardware
> technology.

I don't think INTX_DISABLE is on the bleeding edge of hardware
technology and many common cases will benefit from using it (just think
about the number of newish notebook users).  The problem with
INTX_DISABLE is that there doesn't seem to be any way to tell whether
writing to that bit is safe or not.

You are right in that turning off IRQ mechanisms in pci_enable_device()
doesn't fix all the problems as PCI-wise it only enables IO and memory
address space access, but to some extent it does because in the arch
code, it enables the IRQ line and the physical IRQ line might not be
shared even if the final IRQ number is shared (Andi, am I correct)?

Anyways, I think the proper solution is to make sure all generic IRQ
controls including INTX turned off early in the boot during PCI
subsystem initialization (ie. do the disable part of
pcim_prepare_device() early in the boot before any IRQ line is
requested) and let each driver enable after initialization as necessary
and do similar things during resume.  Note that drivers still need to be
modified to signify when the device is initialized enough to enable IRQ,
and bus mastering.

We can also arch-dep IRQ enabling to the activation time.  That will
give us more protection even when INTX_DISABLE is not available.

Thanks.

-- 
tejun
