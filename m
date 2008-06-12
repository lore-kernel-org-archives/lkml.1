Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYFLVXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYFLVXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYFLVXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:23:09 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:37909 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbYFLVXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:23:08 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: pnp changes -> suspend oops [Was: 2.6.26-rc5-mm2]
Date: Thu, 12 Jun 2008 15:22:43 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <20080609223145.5c9a2878.akpm@linux-foundation.org> <200806111303.39267.bjorn.helgaas@hp.com> <485190AC.3060107@gmail.com>
In-Reply-To: <485190AC.3060107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121522.44199.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008 03:10:04 pm Jiri Slaby wrote:
> On 06/11/2008 09:03 PM, Bjorn Helgaas wrote:
> > On Wednesday 11 June 2008 12:08:53 pm Jiri Slaby wrote:
> >> On 06/10/2008 07:31 AM, Andrew Morton wrote:
> >>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc5/2.6.26-rc5-mm2/
> >> I face problems after some of the pnp changes. If this is not known, I may 
> >> bisect it, it's 100% reproducible. I have no real logs, It panics prior to 
> >> network is woken up to see something on netconsole, I just captured a function 
> >> name and an offset of place where it oopses.
> >>
> >> pnpacpi_encode_resources, ACPI_RESOURCE_TYPE_DMA case, pnp_get_resource(dev, 
> >> IORESOURCE_DMA, dma) returns NULL, which is dereferenced at pnpacpi_encode_dma 
> >> at p->flags.
> >>
> >> It happens on resume after mem > /sys/power/state.
> > 
> > Thanks for the report, I hadn't heard about this.
> > 
> > We used to always have a resource from the static table to encode
> > (assuming the table was big enough), even if that resource was
> > disabled or unassigned.  But now we don't keep those around, so
> > we can end up with null pointers like you're seeing.
> > 
> > Before you go to all the trouble of bisecting it, can you turn on
> > CONFIG_PNP_DEBUG and try the following debug patch?  I think this
> > will prevent the oops, but it's just papering over the real problem,
> > so please capture the complete dmesg log.
> 
> ACPI: PCI interrupt for device 0000:00:02.0 disabled
> serial 00:07: disabled
> serial 00:06: disabled
> ACPI handle has no context!
> ACPI: PCI interrupt for device 0000:00:1d.7 disabled
> ...
> serial 00:06:   no dma resource to encode!
> serial 00:06: activated
> serial 00:07:   no dma resource to encode!
> serial 00:07: activated
> ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16

Interesting.  I wonder why a serial device would have a DMA resource.
We encode resources by following a template from _CRS, so evidently
that template had a DMA resource.  Or something deeper is wrong.

Can you send me the rest of that dmesg log?

I take it that with the debug patch, your system is functional
after resume?

Bjorn
