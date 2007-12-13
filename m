Return-Path: <linux-kernel-owner+w=401wt.eu-S932145AbXLMVcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbXLMVcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764111AbXLMVcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:32:23 -0500
Received: from smtp107.plus.mail.re1.yahoo.com ([69.147.102.70]:29029 "HELO
	smtp107.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764546AbXLMVcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:32:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=xxG50TGksACmbpLgQ6gFBH38B5o+JUCx4qa5yXMSG6OhX0Pix6KbJmYMh61x9WD3nJFf0BVHnnDqVvCE6qVGWw57pmkhU1S8ThjA/KBz9ZwFIsptVWi11MMvMw47Y9sMjfA9SDouwpj4Bhw9WwXzTkMdb7HUqyFI+VXJHJs1Sko=  ;
X-YMail-OSG: ntJsKLwVM1mdJyGSeBnydrZO0OkdiWHLWNibNi2ZuTjD_krjYz_Dqf1eTswFb9BPCF8x7jhrDw--
Date: Thu, 13 Dec 2007 22:29:59 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, len.brown@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, trenn@suse.de
Subject: Re: 2.6.24-rc4-mm1: acpi reboots machine... solved
Message-ID: <20071213212959.GA4522@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de, Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Andrew Morton <akpm@linux-foundation.org>, len.brown@intel.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	trenn@suse.de
References: <20071209075001.GA4686@gollum.tnic> <200712120921.42430.bjorn.helgaas@hp.com> <20071213070923.GA3951@gollum.tnic> <200712130917.18723.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200712130917.18723.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Dec 13, 2007 at 09:17:18AM -0700, Bjorn Helgaas wrote:
> On Thursday 13 December 2007 12:09:23 am Borislav Petkov wrote:
> > On Wed, Dec 12, 2007 at 09:21:41AM -0700, Bjorn Helgaas wrote:
> > > On Wednesday 12 December 2007 03:11:23 am Borislav Petkov wrote:
> > > > On Tue, Dec 11, 2007 at 05:08:59PM -0700, Bjorn Helgaas wrote:
> > > > > On Tuesday 11 December 2007 01:52:55 pm Borislav Petkov wrote:
> > > > > > From what i can roughly tell so far it seems like an resource conflict between acpi and
> > > > > > the pnp requested regions in your patch which result in the acpi_thermal code
> > > > > > to read the wrong (0xff) temperature value and halt the machine, but i might be
> > > > > > wrong on the details since acpi is such a big code chunk to swallow.
> > > > > 
> > > I think Alexey is on the right track with the PCI resource allocation
> > > failure.
> > 
> > Then it should be the SMBus controller, PCI id 00:1f:3, which is having problems
> > registering its io ports region 4, AFAICT.
> 
> Yes, it looks like the ioport region 0x540-0x55f is described both in
> PNP and ACPI:
> 
>   /sys/devices/pnp0/00:0d/resources:state = active
>   /sys/devices/pnp0/00:0d/resources:io 0x540-0x55f
>   /sys/devices/pnp0/00:0d/resources:io 0x400-0x47f
> 
>   00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 03)
>         Subsystem: ASUSTeK Computer Inc. Unknown device 1869
>         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Interrupt: pin B routed to IRQ 0
>         Region 4: I/O ports at 0540 [size=32]
> 
> The PCI SMBus device was enabled by a quirk, asus_hides_smbus_lpc().
> 
> This quirk seems dangerous to me, and the comments above asus_hides_smbus
> allude to problems similar to what you're seeing.  It's obvious that a
> lot of blood, sweat, and tears have gone into this quirk, so I'm not
> suggesting that it's time to revert it, but I would be interested in
> knowing whether the critical temperature problem goes away if we leave
> the PCI device hidden, e.g., with the following patch:
> 
> Index: linux-mm/drivers/pci/quirks.c
> ===================================================================
> --- linux-mm.orig/drivers/pci/quirks.c	2007-12-13 09:11:31.000000000 -0700
> +++ linux-mm/drivers/pci/quirks.c	2007-12-13 09:12:27.000000000 -0700
> @@ -1073,12 +1073,7 @@
>  
>  	pci_read_config_word(dev, 0xF2, &val);
>  	if (val & 0x8) {
> -		pci_write_config_word(dev, 0xF2, val & (~0x8));
> -		pci_read_config_word(dev, 0xF2, &val);
> -		if (val & 0x8)
> -			printk(KERN_INFO "PCI: i801 SMBus device continues to play 'hide and seek'! 0x%x\n", val);
> -		else
> -			printk(KERN_INFO "PCI: Enabled i801 SMBus device\n");
> +		printk(KERN_INFO "PCI: Leaving i801 SMBus device hidden\n");
>  	}
>  }
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801AA_0,	asus_hides_smbus_lpc);

yep, this fixes it. Bootlog attached.

-- 
Regards/Gruﬂ,
    Boris.

--9amGYk9869ThD9tj
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bootlog-smbus-hidden.bz2"
Content-Transfer-Encoding: base64

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

--9amGYk9869ThD9tj--
