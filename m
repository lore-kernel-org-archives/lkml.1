Return-Path: <linux-kernel-owner+w=401wt.eu-S2992905AbXDDNN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992905AbXDDNN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 09:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992906AbXDDNN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 09:13:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61177 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992905AbXDDNN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 09:13:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: A set of "standard" virtual devices?
Date: Wed, 4 Apr 2007 15:11:41 +0200
User-Agent: KMail/1.9.6
Cc: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com, virtualization@lists.linux-foundation.org
References: <4611652F.700@zytor.com> <200704040049.13118.arnd@arndb.de> <4612F6E9.7040003@zytor.com>
In-Reply-To: <4612F6E9.7040003@zytor.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?iso-8859-1?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?iso-8859-1?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ?=
 =?iso-8859-1?q?=0A=098MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?iso-8859-1?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?iso-8859-1?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200704041511.42543.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/FrPk+zFDkTPUQaAx2g5ICv/HiBPWD/WyeM+R
 oBHOsqohnTVFfYHU+98hhemVsMPzvdtx5ZFmTnYokor2JF4Gr5
 rAGHyHEalsglhDdnaaJJA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007, H. Peter Anvin wrote:
> Configuration space access is platform-dependent.  It's only defined to 
> work in a specific way on x86 platforms.
> 
> "Interrupt swizzling" is really totally independent of PCI.  ALL PCI 
> really provides is up to four interrupts per device (not counting 
> MSI/MSI-X) and an 8-bit writable field which the platform can choose to 
> use to hold interrupt information.  That's all.  The rest is all 
> platform information.
> 
> PCI enumeration is hardly complex.  Most of the stuff that doesn't apply 
> to you you can generally ignore, as is done by other busses like 
> HyperTransport when they emulate PCI.

You still don't get my point: On a platform that doesn't have interrupt
numbers, and where most of the fields in the config space don't correspond
do anything that is already there, you really don't want to invent
a set of new hcalls that implement emulation, to get something as
simple as a pipe.

wc drivers/pci/*.[ch] include/asm-i386/{pci,io}.h lib/iomap*.c \
	arch/i386/pci/*.c kernel/irq/*.c
17015  59037 463967 total

Even if you only need half of that code in reality, reimplementing
all that in both the kernel and in the hypervisor is an enourmous
effort. We've seen that before on the ps3, which initially faked
a virtual PCI bus just for the USB controller, but doing something
like that requires adding abstraction layers, to decide whether to
implement e.g. an inb as a hypercall or as a memory read.

> That being said, on platforms which are PCI-centric, such as x86, this 
> of course makes it a lot easier to produce virtual devices which work 
> across hypervisors, since the device model, of *any* operating system is 
> set up to handle them.

Yes, as I said there are two separate problems. I really think that
a standardized virtual driver interface should be modeled after
kernel <-> user interfaces, not hardware <-> kernel interfaces.

Once we know what operations we want (e.g. read, write and SIGIO,
or some other set of primitives), it will be good to provide a
virtual PCI device that can be used as one transport mechanism
below it. Using PCI device IDs to tell what functionality is
provided by the device would provide a reasonable method for
autoprobing.

	Arnd <><
