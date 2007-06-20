Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbXFTRrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbXFTRrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbXFTRrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:47:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbXFTRri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:47:38 -0400
Subject: Re: [PATCH 3/3] ACPI autoloading - Create __mod_acpi_device_table
	symbol for all acpi drivers.
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Mattia Dongili <malattia@linux.it>
Cc: Len Brown <lenb@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       acpi4asus-user <acpi4asus-user@lists.sourceforge.net>
In-Reply-To: <20070620170617.GA3226@inferi.kami.home>
References: <1182112047.4204.12.camel@noname>
	 <1182111863.4204.6.camel@noname>  <20070620170617.GA3226@inferi.kami.home>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Wed, 20 Jun 2007 19:47:23 +0200
Message-Id: <1182361643.28514.708.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 02:06 +0900, Mattia Dongili wrote:
> On Sun, Jun 17, 2007 at 10:24:23PM +0200, Thomas Renninger wrote:
> > Create __mod_acpi_device_table symbol for all acpi drivers.
> > 
> > modpost is going to use this one to create modules.alias
> > 
> > Hopefully thinkpad module still works.
> > IMO this one should get restructured and make use of acpi_bus_register_driver
> > and try to avoid to test for HIDs/CIDs for its own.
> > 
> > Signed-off-by: Thomas Renninger <trenn@suse.de>
> 
> Tested, except for the compile error already reported it does its job on
> my vaios.

Thanks.

> A question though:
> 
> > Index: linux-2.6.22-rc4/drivers/misc/sony-laptop.c
> > ===================================================================
> > --- linux-2.6.22-rc4.orig/drivers/misc/sony-laptop.c
> > +++ linux-2.6.22-rc4/drivers/misc/sony-laptop.c
> > @@ -890,10 +890,22 @@ static int sony_nc_remove(struct acpi_de
> >  	return 0;
> >  }
> >  
> > +static const struct acpi_device_id sony_device_ids[] = {
> > +	{SONY_NC_HID, 0},
> > +	{SONY_PIC_HID, 0},
> > +	{"", 0},
> > +};
> > +MODULE_DEVICE_TABLE(acpi, sony_device_ids);
> > +
> > +static const struct acpi_device_id sony_nc_device_ids[] = {
> > +	{SONY_NC_HID, 0},
> > +	{"", 0},
> > +};
> > +
> ...
> > +static const struct acpi_device_id sony_pic_device_ids[] = {
> > +	{SONY_PIC_HID, 0},
> > +	{"", 0},
> > +};
> > +
> 
> is it really necessary to have those duplicate entries?
In this case, yes.

It's because two independent ACPI drivers are set up here.
If you could put these together, only set up
acpi_bus_register_driver(..) once in .init and get the pic and nc driver
handled together it would work.

I don't know whether this could be done.
If not, IMO this driver should get split up in two separate drivers, one
serving SONY_PIC_HID and one serving SONY_NC_HID.
> 
> Also, I guess that when this patch set is applied we also should declare
> sonypi obsolete as sony-laptop will grab the same device that sonypi
> wants (the SPIC one). sony-laptop has options to avoid doing that would
> make things clear to users.
> I still haven't received reports of mafunctioning vaios using the new
> sony-laptop instead of sonypi but 2.6.22 isn't final yet.

Sounds sane.
Another problem that could come up in future is that new laptops could
make use of the ACPI video spec (Appendix B) and of these vendor
specific devices (I already saw this on an ASUS).
While autoloading should still be ok (both are tried, maybe even both
are needed), we need to find out which one need to be used in which
condition.
I could imagine if we pass some kind of "Vista" OSI string, the ACPI
video spec stuff is used otherwise e.g. the ATK Asus specific things...

It might even be mixed up, that some functions of the video device
driver are provided, but hotkeys are still working with the other
driver...

I fear getting this right for all kind of laptops won't be that easy.

   Thomas

BTW: I also saw a laptop (IIRC it was a sony) with asus and sony ACPI
device.
When both drivers got loaded things broke.
A solution was to only let the asus driver get active if the device is
known. Currently, not sure whether still (I sent a patch a while ago),
the Asus driver falls back to a default ("M6N"?) configuration. IMO this
is a bit too dangerous and instead a message like "unsupported ASUS
model found, please send acpidump to linux-acpi@vger.kernel.org".

