Return-Path: <linux-kernel-owner+w=401wt.eu-S1161035AbXDCRxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161035AbXDCRxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161042AbXDCRxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:53:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:49200 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161035AbXDCRxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:53:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: A set of "standard" virtual devices?
Date: Tue, 3 Apr 2007 19:50:59 +0200
User-Agent: KMail/1.9.6
Cc: Andi Kleen <ak@suse.de>, Christian Borntraeger <borntrae@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
References: <4611652F.700@zytor.com> <200704031030.36473.ak@suse.de> <20070403111731.52f2102a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070403111731.52f2102a@gondolin.boeblingen.de.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704031951.00544.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX199dMxZdAP9zy4XLc761nzDFXE+MHAIsikeLyJ
 hu4yi9VIwq5PnujNkKX90QF2W2lFg+FukfR6qCvXAyiGSE7i1R
 9mrBzdG0Iguo/Emv8L88g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 April 2007, Cornelia Huck wrote:
> On s390, it would be more than strangeness. There's no implementation
> of PCI at all, someone would have to cook it up - and it wouldn't have
> any use beyond those special devices. Since there isn't any bus type
> that is available on *all* architectures, a generic "virtual" bus with
> very simple probing seems much saner...

I think we need to separate two problems here:

1. Probing:
That's really what triggered the discussion, PCI probing is well-understood
and implemented on _most_ platforms, so there is some value in reusing it.
When you talk about 'very simple probing', I'm not sure what the most simple
approach could be. Ideas that have been implemented before include:
a) have a limited set of device IDs (e.g. 65535 devices, or a hierarchic tree),
   and try to access each one of them in order to find out if it's there. We
   do that for PCI or CCW, for instance.
b) Have an iterator in the hypervisor (or firmware), to return a handle to
   the first, next or child of a device. We do that for open firmware.
c) ask the hypervisor for an unused device of a given class, which needs to
   be returned to the hypervisor when no longer used. This is how the PS3
   hypervisor works, but it does not play well with the Linux driver model.

2. Device access:
When talking to a virtual device, you want to have at least a way to give
commands to it and a way to get interrupts back. Again, multiple ideas
have been used in the past, and we should choose a subset:
a) PCI-like: mmio using memory and/or I/O space BAR setup, interrupt
   numbers and DMA to guest physical addresses.
b) Channel-like: use an hcall to give commands to the hypervisor, passing
   down a device handle command code and data areas in guest physical space.
   Interrupts return the device handle or a OS-defined per-device value.
c) Minimalistic: Every device is mapped into the guest address space and
   can potentially be remapped into user space. The device memory can be
   shared between guests and/or with the host if that uses the same driver.
   The guest is able to signal the receiving end using an hcall and gets
   interrupts like in b)
d) UNIX-like: devices appear like file descriptors, the guest can do
   operations like read/write/sync/mmap, potentially ioctl on them to talk
   to the host.

	Arnd <><
