Return-Path: <linux-kernel-owner+w=401wt.eu-S932674AbZJFRwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbZJFRwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbZJFRwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:52:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:52529 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756939AbZJFRwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:52:34 -0400
Message-ID: <4ACB839A.2060800@kernel.org>
Date: Tue, 06 Oct 2009 10:51:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/pci: intel bus root res with IOH reading -v2
References: <4AC97C00.7090503@kernel.org> <200910061133.27546.bjorn.helgaas@hp.com>
In-Reply-To: <200910061133.27546.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Sunday 04 October 2009 10:54:24 pm Yinghai Lu wrote:
>> for intel system with multi IOH. we could read peer root resource from PCI conf,
>> and don't trust _CRS again for root bus
> 
> Ugh.  Are we going to end up with amd_bus.c, intel_bus.c, nvidia_bus.c,
> broadcom_bus.c, serverworks_bus.c, etc.?
only needed when you have muti ...
> 
> This is basically a simple PCI host bridge driver, but it's completely
> separate from the ACPI pci_root.c driver, and it completely ignores
> useful things like multiple domain (_SEG) support and address translation
> (_TRA) support.  These are going to be important issues for large x86
> machines.
> 
> I think this is leading toward an architectural mess.  Yes, we have
> issues with _CRS for root bridges.  But ACPI does give us a generic
> framework powerful enough to handle everything you're doing here.  In
> my opinion, we should fix the implementation issues with that framework
> rather than adding platform-specific setup code every time we trip
> over something.

again we should trust HW conf than BIOS.

> 
> I expect that will mean some quirks in pci_root.c, and maybe even some
> code similar to pci_root_bus_res() to validate or override what we learn
> from _CRS.  But we ought to try for some conceptual integrity in the
> design by putting all the putting all the host bridge driver code together.
> 
> What is the specific problem solved by this patch?  Does "pci=use_crs"
> address any of that problem?  (I know "pci=use_crs" breaks some machines,
> and I know it's unacceptable to require users to use it.  But I want to
> understand whether the concept is related, and whether you've tripped
> over a BIOS defect or a Linux pci_root.c defect.)

BIOS doesn't allocate resource to some pci devices when too many devices. and need kernel to allocate resource ( 32bit mmio, 64 mmio)
to those devices.
current only known fw that can allocate mmio 64 ( with correct setting) is LinuxBIOS.

also could help os to fend off some range that is wrongly allocated by BIOS that is cross the boundary between different peer root bus.

_CRS doesn't report any MMIO 64 range, even HW does have that set. 

YH
