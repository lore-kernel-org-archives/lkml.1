Return-Path: <linux-kernel-owner+w=401wt.eu-S1751584Ab0AKV1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab0AKV1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477Ab0AKV1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:27:08 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:13688 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab0AKV1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:07 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alex Brooks <a.brooks@marathon-robotics.com>
Subject: Re: BAR 0: can't allocate resource
Date: Mon, 11 Jan 2010 14:27:03 -0700
User-Agent: KMail/1.9.10
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201001061305.31635.a.brooks@marathon-robotics.com> <1262843176.27608.2.camel@dc7800.home> <201001101407.26930.a.brooks@marathon-robotics.com>
In-Reply-To: <201001101407.26930.a.brooks@marathon-robotics.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001111427.03777.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 January 2010 08:07:26 pm Alex Brooks wrote:
> > I was hoping for a kernel directly from Linus' git repo, e.g.,
> > 2.6.33-rc3; I don't think the debug output I'm thinking about went in
> > until after 2.6.32 was released.
> 
> I'm not sure how to modify the 2.6.33-rc3 kernel source exactly re MCFG -- the 
> dmesg output for 2.6.33-rc3 is quite different (attached),

It's interesting that we now use MMCONFIG by default; no tweaking
necessary.  I guess Linux just got a little smarter between 2.6.26
and 2.6.33 -- in this case, it looks like we reduce the size of the
MMCONFIG region from what the BIOS reported.

But I don't think MMCONFIG is relevant to this problem anyway.

> including some new  
> information about an address collision for the recalcitrant device:
> 
> pci 0000:01:04.0: address space collision: [mem 0x00800000-0x00800fff] already 
> in use
> pci 0000:01:04.0: can't reserve [mem 0x00800000-0x00800fff]
> 
> Does this shed any more light on things (or can you tell me what I could 
> modify to get better debug info)?

It shows that we think the octal UART is at 0x00800000, which
doesn't seem valid (I think it's in the middle of your system RAM).

This is before Linux moves anything around, so normally this would
be what BIOS left in the BAR.  But BIOS puts it at 0xfebff000 in the
working case (without the Mini PCI adapter), and the adapter shouldn't
even be visible to the BIOS, so I would expect the octal UART to still
be at the same address.

I'm afraid I still don't see a software problem here.  To me (and I'm
certainly not a hardware person), it feels like an electrical problem
on the PCI bus: we read a BAR and it has a nonsensical value, we write
the BAR and can't read that value back, we read the vendor/device/class
codes and get nonsense.  It's also interesting that most of these
nonsense values we read seem to have only one bit set.

Bjorn
