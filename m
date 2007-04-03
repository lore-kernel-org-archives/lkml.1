Return-Path: <linux-kernel-owner+w=401wt.eu-S934021AbXDCTzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021AbXDCTzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933104AbXDCTzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:55:32 -0400
Received: from gw.goop.org ([64.81.55.164]:40173 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934021AbXDCTzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:55:31 -0400
Message-ID: <4612B123.2040105@goop.org>
Date: Tue, 03 Apr 2007 12:55:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>, Andi Kleen <ak@suse.de>,
       Christian Borntraeger <borntrae@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
References: <4611652F.700@zytor.com> <200704031951.00544.arnd@arndb.de> <4612A5F0.2080609@goop.org> <200704032142.51976.arnd@arndb.de>
In-Reply-To: <200704032142.51976.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> We already have device drivers for physical devices that can be attached
> to different buses. The EHCI USB is an example of a driver that can 
> be for instance PCI, OF or an on-chip device. Moreover, you can have an
> abstracted device behind it that does not need to know about the transport,
> like the SCSI disk driver does not care if it is talking to an ATA, 
> parallel SCSI or SAS chip, or even which controller that is.
>   

Yes, that kind of layering is useful when there's enough of an
abstraction gap to fit the layers into.  USB is particularly simple in
that way, since it can be made to travel nicely over any number of
transports.

> console is also the least problematic interface, you can do it over
> practically anything.
>   

Sure.  But its interesting that there are savings to be had.

> Doing a SCSI driver has been tried before, with ibmvscsi. Not good.
>   

OK, interesting.  People had proposed using SCSI as the interface, but I
wasn't aware of any results from doing that.  How is it not good?

> The interesting question about block devices is how to handle concurrency
> and interrupt mitigation. An efficient interface should
>
> - have asynchronous notification, not sleep until the transfer is complete
> - allow multiple blocks to be in flight simultaneously, so the host can
>   reorder the requests if it is smart enough
> - give only a single interrupt when multiple transfers have completed
>   

Yes.  The Xen block interface is already pretty efficient in these respects.

>> I'm not sure what similar common code could be extracted for network
>> devices.  I haven't looked into it all that closely.
>>     
>
> One way to do networking would be to simply provide a shared memory area
> that everyone can write to, then use a ring buffer and atomic operations
> to synchronize between the guests, and a method to send interrupts to the
> others for flow control.
>   

Yes, and that's the core of the Xen netfront.  But is there really much
code which can be shared between different hypervisors?  When you get
down to it, all the real code is hypervisor-specific stuff for setting
up ringbuffers and dealing with interrupts.  Like all the other network
drivers.

    J
