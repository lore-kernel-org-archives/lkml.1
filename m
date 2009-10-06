Return-Path: <linux-kernel-owner+w=401wt.eu-S1758289AbZJFS6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbZJFS6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757817AbZJFS6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:58:35 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:41245 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475AbZJFS6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:58:34 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86/pci: intel bus root res with IOH reading -v2
Date: Tue, 6 Oct 2009 12:57:52 -0600
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <4AC97C00.7090503@kernel.org> <200910061133.27546.bjorn.helgaas@hp.com> <4ACB839A.2060800@kernel.org>
In-Reply-To: <4ACB839A.2060800@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200910061257.54877.bjorn.helgaas@hp.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 October 2009 11:51:22 am Yinghai Lu wrote:
> Bjorn Helgaas wrote:
> > On Sunday 04 October 2009 10:54:24 pm Yinghai Lu wrote:
> >> for intel system with multi IOH. we could read peer root resource from PCI conf,
> >> and don't trust _CRS again for root bus
> > 
> > Ugh.  Are we going to end up with amd_bus.c, intel_bus.c, nvidia_bus.c,
> > broadcom_bus.c, serverworks_bus.c, etc.?
> only needed when you have muti ...

I think that translates to "yes, we will need all those bits as soon
as those vendors support larger systems with multiple IOHs."  And I
think that's the wrong answer.

> > This is basically a simple PCI host bridge driver, but it's completely
> > separate from the ACPI pci_root.c driver, and it completely ignores
> > useful things like multiple domain (_SEG) support and address translation
> > (_TRA) support.  These are going to be important issues for large x86
> > machines.
> > 
> > I think this is leading toward an architectural mess.  Yes, we have
> > issues with _CRS for root bridges.  But ACPI does give us a generic
> > framework powerful enough to handle everything you're doing here.  In
> > my opinion, we should fix the implementation issues with that framework
> > rather than adding platform-specific setup code every time we trip
> > over something.
> 
> again we should trust HW conf than BIOS.

Certainly there's a tradeoff between a generic driver that relies on
the BIOS, and a platform-specific driver that uses only the hardware.
The first leaves us vulnerable to BIOS bugs, but the second leads to
a plethora of drivers that require updates as hardware changes.

For example, pci_root.c already supports multiple PCI domains and
address translation.  Where is that support in intel_bus.c and
amd_bus.c?

> > I expect that will mean some quirks in pci_root.c, and maybe even some
> > code similar to pci_root_bus_res() to validate or override what we learn
> > from _CRS.  But we ought to try for some conceptual integrity in the
> > design by putting all the putting all the host bridge driver code together.
> > 
> > What is the specific problem solved by this patch?  Does "pci=use_crs"
> > address any of that problem?  (I know "pci=use_crs" breaks some machines,
> > and I know it's unacceptable to require users to use it.  But I want to
> > understand whether the concept is related, and whether you've tripped
> > over a BIOS defect or a Linux pci_root.c defect.)
> 
> BIOS doesn't allocate resource to some pci devices when too many devices. and need kernel to allocate resource ( 32bit mmio, 64 mmio)
> to those devices.
> current only known fw that can allocate mmio 64 ( with correct setting) is LinuxBIOS.
> 
> also could help os to fend off some range that is wrongly allocated by BIOS that is cross the boundary between different peer root bus.
> 
> _CRS doesn't report any MMIO 64 range, even HW does have that set. 

This sounds like a plain-vanilla BIOS defect.  What prevents us from
fixing the BIOS (if the platform hasn't shipped) or adding some sort of
kernel quirk to make the generic driver work?  We don't need to throw
it away completely.

But to be fair, I guess I'm criticizing this patch based on my vision
of where pci_root.c *should* be, not where it is today.  Today, it
ignores _CRS on x86, so even with a correct BIOS, you'd have to use
"pci=use_crs".  That needs to get fixed somehow.

I want to work on getting it fixed rather than adding platform-specific
workarounds like this patch.  I think this patch sweeps the issue under
the rug and adds code that will be difficult to remove later.

Bjorn
