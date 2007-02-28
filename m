Return-Path: <linux-kernel-owner+w=401wt.eu-S1751081AbXB1AnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751081AbXB1AnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 19:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXB1AnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 19:43:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:49167 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbXB1AnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 19:43:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] killing the NR_IRQS arrays.
Date: Wed, 28 Feb 2007 01:41:50 +0100
User-Agent: KMail/1.9.6
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com> <1171844753.5644.174.camel@localhost.localdomain> <m1abyzl4yw.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1abyzl4yw.fsf@ebiederm.dsl.xmission.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702280141.51420.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX19ToAj+c28B20QBQsSmAnJrm8Pb1qnhtVMWjh6
 doVWEAqK2fTy7lGtu8Y50V6Q+sVRKahHShQY/KACtXU5j0+p9r
 ZkzG+QEReyWFeWBNQbNGg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 February 2007, Eric W. Biederman wrote:
> * Add a variation of the API in interrupt.h that uses
>   "struct irq *irq" instead of "unsigned int irq"
>   
>   Probably replacing request_irq with irq_request or something
>   trivial like that.
> 
>   This will need to touch all of different irq implementation back
>   ends, but only very lightly.
> 
> * Convert the generic irq code to use struct irq * everywhere it
>   current uses "unsigned int irq".
> 
> * Start on the conversions of drivers and subsystems picking on
>   the easy ones first :)

Introducing the irq_request() etc. functions that take a struct irq*
instead of an int sounds good, but I'd hope we can avoid using those
in device drivers and do a separate abstraction for each bus_type
that deals with interrupts. I'm not sure if that's possible for
each bus_type, but the ones I have worked with in the past should
allow that:

pci: each device/function has a unique irq, drivers need not know
     about it afaics.
isa/pnp: numbers from 1 to 15 are the right abstraction here, that
     how isa has worked for ages.
s390: got rid of irq numbers already
ofw: an open firmware device can have a number of interrupts, but
     like PCI, the driver only needs to know things like 'first
     irq of this device', not how it's connected
ps3: irqs are requested from the firmware for each device, this
     can happen under the covers.
mmc, usb, phy, ieee1394: these already have a higl-level abstraction
     for interrupt events
platform: dunno, probably these really should use the struct irq
     directly
eisa, mca, pcmcia, zorro, ...: no idea, but possibly similar to PCI.

Note that we can even start converting device drivers first, before
moving away from irq numbers. A typical PCI driver should get
somewhat simpler by the conversion, and when they are all converted,
we can replace pci_dev->irq with a struct irq* under the covers.

	Arnd <><
