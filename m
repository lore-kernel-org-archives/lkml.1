Return-Path: <linux-kernel-owner+w=401wt.eu-S1761640AbYBZKOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761640AbYBZKOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 05:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757476AbYBZKOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 05:14:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:57443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634AbYBZKOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 05:14:42 -0500
Date: Tue, 26 Feb 2008 11:15:51 +0100
From: Holger Macht <hmacht@suse.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] libata: Register for dock events when the drive is
	inside a dock station
Message-ID: <20080226101551.GB10721@homac.suse.de>
Mail-Followup-To: Tejun Heo <htejun@gmail.com>,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>
References: <20080214124048.GB9708@homac.suse.de> <20080214125615.GD9708@homac.suse.de> <47BC5F44.605@garzik.org> <20080221115305.GB5032@homac.suse.de> <47BE26A0.2040708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BE26A0.2040708@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 22. Feb - 10:34:24, Tejun Heo wrote:
> > If a device/bay is inside a docking station, we need to register for dock
> > events additionally to bay events. If a dock event occurs, the dock driver
> > will call the appropriate handler (ata_acpi_ap_notify() or
> > ata_acpi_dev_notify()) for us.
> > 
> > Signed-off-by: Holger Macht <hmacht@suse.de>
> > ---
> > 
> > diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> > index 9e8ec19..563ad72 100644
> > --- a/drivers/ata/libata-acpi.c
> > +++ b/drivers/ata/libata-acpi.c
> > @@ -191,20 +191,33 @@ void ata_acpi_associate(struct ata_host *host)
> >  		else
> >  			ata_acpi_associate_ide_port(ap);
> >  
> > -		if (ap->acpi_handle)
> > +		if (ap->acpi_handle) {
> >  			acpi_install_notify_handler (ap->acpi_handle,
> >  						     ACPI_SYSTEM_NOTIFY,
> >  						     ata_acpi_ap_notify,
> >  						     ap);
> > +#ifdef CONFIG_ACPI_DOCK_MODULE
> 
> Heh, you need
> 
>   #if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
> 
> Also, another question.  Is there a way to tell whether the device or
> port is connected behind a dock or not?  Just notifying hotplug signal
> is fine for hotplugging but to make hot unplug safe for PATA, libata
> should be able to tell whether the device is actually gonna go away and
> kill it explicitly.

The hotplug handler is only called if the device is actually inside the
dock station. If it is not, nothing will happen. I hope that I got your
question right?

However, if this would be helpful, it would be easy to add something like
a am_I_on_dock_station?(...) function to the dock driver.

Regards,
	Holger
