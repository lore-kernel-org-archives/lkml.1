Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbXDCTHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbXDCTHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbXDCTHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:07:43 -0400
Received: from gw.goop.org ([64.81.55.164]:48627 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbXDCTHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:07:43 -0400
Message-ID: <4612A5F0.2080609@goop.org>
Date: Tue, 03 Apr 2007 12:07:28 -0700
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
References: <4611652F.700@zytor.com> <200704031030.36473.ak@suse.de> <20070403111731.52f2102a@gondolin.boeblingen.de.ibm.com> <200704031951.00544.arnd@arndb.de>
In-Reply-To: <200704031951.00544.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> I think we need to separate two problems here:
>
> 1. Probing:
> That's really what triggered the discussion, PCI probing is well-understood
> and implemented on _most_ platforms, so there is some value in reusing it.
> When you talk about 'very simple probing', I'm not sure what the most simple
> approach could be. 

Is probing an interesting problem to consider on its own?  If there's
some hypervisor-agnostic device driver in Linux, then obviously it needs
some way to find the the corresponding (virtual) hardware for it to talk
to.  But that probing mechanism will depend on the actual interface
structure, and is just one of the many problems that need to be solved. 
There's no point in overloading PCI to probe for the device unless
you're actually using PCI to talk to the device.

> Ideas that have been implemented before include:
> a) have a limited set of device IDs (e.g. 65535 devices, or a hierarchic tree),
>    and try to access each one of them in order to find out if it's there. We
>    do that for PCI or CCW, for instance.
> b) Have an iterator in the hypervisor (or firmware), to return a handle to
>    the first, next or child of a device. We do that for open firmware.
> c) ask the hypervisor for an unused device of a given class, which needs to
>    be returned to the hypervisor when no longer used. This is how the PS3
>    hypervisor works, but it does not play well with the Linux driver model.
>   

Xen has xenbus, which is essentially a filesystem-like namespace which
can be walked to find the devices being exposed to a guest.  It is
fairly similar to OFW's device tree.

> 2. Device access:
> When talking to a virtual device, you want to have at least a way to give
> commands to it and a way to get interrupts back. Again, multiple ideas
> have been used in the past, and we should choose a subset:
>   

Let me say up front that I'm skeptical that we can come up with a single
bus-like abstraction which can be a both simple and efficient interface
to all the virtual architectures.  I think a more fruitful path is to
find what pieces of functionality can be made common, with the aim of
having small, simple and self-contained hypervisor-specific backends.

I think this needs to be considered on a class by class basis.  This
thread started with a discussion about entropy sources.  In theory you
could implement it as simply as exposing a mmaped ringbuffer.  There are
some extra complexities deriving from the security requirements though;
for example, all the entropy needs to be kept strictly private to the
domain that consumes it.

But beyond that, there are 3 other important classes of device:

    * console
    * disk
    * networking

(There are obviously more, but these are the must-have.)

Console already provides us with a model to work on, in the form of
hvc-console.  The hvc-console code itself has the bulk of the common
console code, along with a set of very small hypervisor-specific
backends. The Xen console implementation shrunk considerably when we
switched to using it.

If we could do the same thing with disk and net, I would be very happy.

For example, if we wanted to change the Xen frontend/backend disk
interface, we could use SCSI as the basic protocol, and then convert
netfront into a relatively simple scsi driver.  There would still be a
Xen-specific piece, but it should be fairly small and have a clean
interface.  Though the existing interface is pretty simple
shove-this-block-there affair.

I'm not sure what similar common code could be extracted for network
devices.  I haven't looked into it all that closely.

    J
