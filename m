Return-Path: <linux-kernel-owner+w=401wt.eu-S1030237AbXDCOFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237AbXDCOFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030274AbXDCOFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:05:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:51862 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030258AbXDCOFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:05:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: A set of "standard" virtual devices?
Date: Tue, 3 Apr 2007 16:03:14 +0200
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       virtualization@lists.linux-foundation.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
References: <4611652F.700@zytor.com> <200704031415.38381.arnd@arndb.de> <20070403153921.491b1e9f@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070403153921.491b1e9f@gondolin.boeblingen.de.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?iso-8859-1?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?iso-8859-1?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ?=
 =?iso-8859-1?q?=0A=098MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?iso-8859-1?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?iso-8859-1?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704031603.14836.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+yEAwcDrW5oDveOQNEzw90f44kTtu0fO8mWsx
 q9wRu6REQPmO3CCywX8r7qsKOS4ojav9cmMt3UXujHe3lwlqix
 DOqFKQQLM7b6oYgjOxo8Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 April 2007, Cornelia Huck wrote:
> On Tue, 3 Apr 2007 14:15:37 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> That's OK for a virtualized architecture where the base architecture
> already supports PCI. But a traditional s390 OS would be as unhappy
> with a PCI device as with a device of a completely new type :)

Sure, that was my point from the start.

> There are several options for virtualized devices (and I don't know why
> they shouldn't coexist):
> 
> 1. Emulate a well-known device (like a e1000 network card on PCI or a
> model 3390 dasd on CCW). Existing operating systems can just use them,
> but it's a lot of work in the hypervisor.

Most hypervisors already do this, and it's an unrelated topic. 
What we're trying to achieve is to make sure not every hypervisor
and simulator has to introduce its own set of drivers.


> > struct virt_bus {
> > 	/* platform dependent */
> > 	long (*transfer)(struct virt_dev *dev, void *buffer,
> > 		unsigned long size, int type);
> > };
> 
> Should this embed a struct bus_type? Or reference a generic_virt_bus?

yes, that should embed the bus_type.

> > struct virt_dev {
> > 	struct device dev;
> > 	struct virt_driver *driver;
> > 	struct virt_bus *bus;
> > 	struct pci_device_id id;
> > 	int irq;
> > };
> 
> And that's where I have problems :) The notion of "irq" is far too
> platform specific. I can bend my mind round using PCI-like ids for
> non-PCI virtualized devices, but an integer is far too small and to
> specific for a way to access the device.

Sorry, I've been working too long on the lesser architectures.
IRQ number are evil indeed.
However, I'm pretty sure that we need _some_ abstraction of an
interrupt mechanism here. The easiest way is probably to have a
callback function like
	int (*irq_handler)(struct virt_dev*, unsigned long message);
in the virt_dev.

	Arnd <><
