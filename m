Return-Path: <linux-kernel-owner+w=401wt.eu-S1759951AbXGaXS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951AbXGaXS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbXGaXSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:18:21 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:44443 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbXGaXSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:18:20 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.23-rc1-mm1 - seems OK on Dell Latitude D820, except for tpm_tis
Date: Tue, 31 Jul 2007 17:05:01 -0600
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Kylene Hall <kjhall@us.ibm.com>,
       tpm@selhorst.net, linux-kernel@vger.kernel.org
References: <20070725040304.111550f4.akpm@linux-foundation.org> <200707311401.22158.bjorn.helgaas@hp.com> <29677.1185917503@turing-police.cc.vt.edu>
In-Reply-To: <29677.1185917503@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311705.01679.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 July 2007 03:31:43 pm Valdis.Kletnieks@vt.edu wrote:
> On Tue, 31 Jul 2007 14:01:21 MDT, Bjorn Helgaas said:
> > So, the BIOS is telling us that at least as currently configured, the
> > TPM can't use interrupts.  /sys/devices/pnp0/00:0f/options should have
> > all the *possible* TPM configurations.  I would guess that none of them
> > shows an IRQ either.
> 
> Hmm.. Oddness. Looks empty:
> 
> # cat /sys/devices/pnp0/00\:0f/options | wc
>       0       0       0
> 
> Or is that expected if the chipset has one cast-in-stone/ROM config?

"options" is populated using the ACPI _PRS method.  The spec says that
method is optional and non-configurable devices will not provide it.
So I guess that's what you have -- a device with a fixed configuration.

> Patch tested, and seems to decide to initialize in polled mode on my
> machine, without having to do any /etc/modprobe.conf 'interrupts=0'.
> I'm able to run the tpm_demo program from libtpm-2.0, so /dev/tpm0 does
> seem to be operational.
> 
> You can stick this on the patch and pass it along:
> 
> Tested-By: <valdis.kletnieks@vt.edu>
> 
> but I'd suggest running a regression test against a chipset that *does*
> do IRQs before sending it upstream (if you haven't already)...

Yes.  I don't think I have a box with a TIS TPM on it, but I hope
Kylene does and will comment on this approach.

I notice Andrew put it in -mm already.  I'll be on vacation for the
next couple weeks, so I won't be able to poke at this for a while.
Here's the changelog I would insert (for tpm_tis-fix-interrupt-probing.patch):


[patch] tpm: pay attention to IRQ info from PNP

If we discover the TIS TPM device via PNP, use the PNP IRQ information
rather than probing for an IRQ.  If PNP shows no IRQ, run the TPM in
polling mode.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
