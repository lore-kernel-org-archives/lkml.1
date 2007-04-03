Return-Path: <linux-kernel-owner+w=401wt.eu-S966209AbXDCTnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966209AbXDCTnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966213AbXDCTnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:43:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:56252 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966192AbXDCTnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:43:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: A set of "standard" virtual devices?
Date: Tue, 3 Apr 2007 21:42:51 +0200
User-Agent: KMail/1.9.6
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Andi Kleen <ak@suse.de>,
       Christian Borntraeger <borntrae@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
References: <4611652F.700@zytor.com> <200704031951.00544.arnd@arndb.de> <4612A5F0.2080609@goop.org>
In-Reply-To: <4612A5F0.2080609@goop.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704032142.51976.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Yegn8vusy1TBpyUwQBgEgvHhvg65N7Ah3bVS
 gXv0AuOWMqNKB4ISZL3LQjNVuwoU8L/U0KlITXV3FwVHIsJR3Z
 aoWl8tPmACa5TwQC7SkzA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 April 2007, Jeremy Fitzhardinge wrote:
> Arnd Bergmann wrote:
> > I think we need to separate two problems here:
> >
> > 1. Probing:
> > That's really what triggered the discussion, PCI probing is well-understood
> > and implemented on _most_ platforms, so there is some value in reusing it.
> > When you talk about 'very simple probing', I'm not sure what the most simple
> > approach could be. 
> 
> Is probing an interesting problem to consider on its own?  If there's
> some hypervisor-agnostic device driver in Linux, then obviously it needs
> some way to find the the corresponding (virtual) hardware for it to talk
> to.  But that probing mechanism will depend on the actual interface
> structure, and is just one of the many problems that need to be solved. 
> There's no point in overloading PCI to probe for the device unless
> you're actually using PCI to talk to the device.

We already have device drivers for physical devices that can be attached
to different buses. The EHCI USB is an example of a driver that can 
be for instance PCI, OF or an on-chip device. Moreover, you can have an
abstracted device behind it that does not need to know about the transport,
like the SCSI disk driver does not care if it is talking to an ATA, 
parallel SCSI or SAS chip, or even which controller that is.

> Let me say up front that I'm skeptical that we can come up with a single
> bus-like abstraction which can be a both simple and efficient interface
> to all the virtual architectures.  I think a more fruitful path is to
> find what pieces of functionality can be made common, with the aim of
> having small, simple and self-contained hypervisor-specific backends.
> 
> I think this needs to be considered on a class by class basis.  This
> thread started with a discussion about entropy sources.  In theory you
> could implement it as simply as exposing a mmaped ringbuffer.  There are
> some extra complexities deriving from the security requirements though;
> for example, all the entropy needs to be kept strictly private to the
> domain that consumes it.
> 
> But beyond that, there are 3 other important classes of device:
> 
>     * console
>     * disk
>     * networking
> 
> (There are obviously more, but these are the must-have.)
> 
> Console already provides us with a model to work on, in the form of
> hvc-console.  The hvc-console code itself has the bulk of the common
> console code, along with a set of very small hypervisor-specific
> backends. The Xen console implementation shrunk considerably when we
> switched to using it.

console is also the least problematic interface, you can do it over
practically anything.
 
> If we could do the same thing with disk and net, I would be very happy.
> 
> For example, if we wanted to change the Xen frontend/backend disk
> interface, we could use SCSI as the basic protocol, and then convert
> netfront into a relatively simple scsi driver.  There would still be a
> Xen-specific piece, but it should be fairly small and have a clean
> interface.  Though the existing interface is pretty simple
> shove-this-block-there affair.

Doing a SCSI driver has been tried before, with ibmvscsi. Not good.
The interesting question about block devices is how to handle concurrency
and interrupt mitigation. An efficient interface should

- have asynchronous notification, not sleep until the transfer is complete
- allow multiple blocks to be in flight simultaneously, so the host can
  reorder the requests if it is smart enough
- give only a single interrupt when multiple transfers have completed

minor optimizations could be
- give an interrupt early when some transfers are complete
- allow I/O barriers to be inserted in the stream
- allow marking blocks as more or less important (readahead vs. read)
- provide passthrough of SG_IO or similar for optical media
  (e.g. DVD writer)

> I'm not sure what similar common code could be extracted for network
> devices.  I haven't looked into it all that closely.

One way to do networking would be to simply provide a shared memory area
that everyone can write to, then use a ring buffer and atomic operations
to synchronize between the guests, and a method to send interrupts to the
others for flow control.

	Arnd <><
