Return-Path: <linux-kernel-owner+w=401wt.eu-S1762707AbXEXDLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707AbXEXDLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 23:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762011AbXEXDK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 23:10:59 -0400
Received: from outbound-mail-34.bluehost.com ([69.89.18.154]:39080 "HELO
	outbound-mail-34.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761850AbXEXDK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 23:10:57 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Wayne Sherman <wsherman@gmail.com>
Subject: Re: PCI device problem - MMCONFIG, cannot allocate resource region, resource collisions
Date: Wed, 23 May 2007 20:10:54 -0700
User-Agent: KMail/1.9.6
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-kernel@vger.kernel.org
References: <46524A6D.5050601@gmail.com> <4654DA5E.2050003@gmail.com> <200705232008.23540.jbarnes@virtuousgeek.org>
In-Reply-To: <200705232008.23540.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705232010.54184.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 23, 2007 8:08:23 Jesse Barnes wrote:
> On Wednesday, May 23, 2007 5:20:46 Wayne Sherman wrote:
> > Ivan Kokshaysky wrote:
> > > No, it won't help. The 1M range (ff500000-ff5fffff) is more than
> > > enough.
> >
> > Good catch, I didn't look close enough at the allocations of the devices
> > under the bridge.
> >
> > > The reason why the D-Link resource is not getting assigned is rather
> > > interesting: as Wayne wrote
> > >
> > >> Here is the D-LINK NIC:
> > >> # od -t x4 /sys/devices/pci0000:00/0000:00:14.4/0000:02:02.0/config
> > >>
> > >> 0000000 49011186 80b00117 00000011 00004010
> > >
> > > 			    ^^^^^^
> > > which means that the device class is 0 (not defined).
> > > And in drivers/pci/setup-bus.c we have
> > >
> > > 		/* Don't touch classless devices or host bridges or ioapics.  */
> > > 		if (class == PCI_CLASS_NOT_DEFINED ||
> > > 		    class == PCI_CLASS_BRIDGE_HOST)
> > > 			continue;
> > >
> > > The short term fix would be to assign proper device class to D-Link NIC
> > > using pci quirk...
> >
> > I would like to try this, where do I find "pci quirk"?
>
> You'll need a patch roughly like this.  I'm not sure if it should be a
> header fixup or early fixup though...
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 65d6f23..801712f 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -1690,6 +1690,14 @@ static void __devinit quirk_p64h2_1k_io(struct
> pci_dev *dev)
>  }
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	0x1460,		quirk_p64h2_1k_io);
>
> +/* Give unknown D-Link network adapters a proper class */
> +static void __devinit quirk_dlink_unknown(struct pci_dev *dev)
> +{
> +	if (dev->class = PCI_CLASS_UNKNOWN)

Err, == of course.  Obviously I didn't test this. :)

Jesse
