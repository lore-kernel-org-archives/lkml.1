Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbYBKKEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbYBKKEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYBKKEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:04:00 -0500
Received: from ns1.suse.de ([195.135.220.2]:41877 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbYBKKD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:03:58 -0500
Date: Mon, 11 Feb 2008 11:04:46 +0100
From: Holger Macht <hmacht@suse.de>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, alan@redhat.com,
       jeff@garzik.org, Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] libata: Forcing PIO0 mode on reset must not freeze
	system
Message-ID: <20080211100446.GA4646@homac.suse.de>
Mail-Followup-To: Tejun Heo <htejun@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	alan@redhat.com, jeff@garzik.org,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>
References: <20080210195556.GA5261@homac> <47AFB4DB.1000204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AFB4DB.1000204@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 11. Feb - 11:37:15, Tejun Heo wrote:
> Hello,
> 
> Holger Macht wrote:
> > Calling ap->ops->set_piomode(ap, dev) on a device/controller which got
> > already removed, locks the system hard. Reproducibly on an X60 attached to
> > a dock station containing a cdrom device with doing
> > 
> >   $ echo 1 > /sys/devices/platform/dock.0/undock && echo 123 > /dev/sr0
> > 
> > This calls ata_eh_reset(...) which in turn tries to force PIO mode 0. But
> > the device is already gone.
> > 
> > Bisecting revealed the following commit as culprit:
> > 
> >   commit cdeab1140799f09c5f728a5ff85e0bdfa5679cd2
> >   Author: Tejun Heo <htejun@gmail.com>
> >   Date:   Mon Oct 29 16:41:09 2007 +0900
> >   
> >       libata: relocate forcing PIO0 on reset
> >       
> >       Forcing PIO0 on reset was done inside ata_bus_softreset(), which is a
> >       bit out of place as it should be applied to all resets - hard, soft
> >       and implementation which don't use ata_bus_softreset().  Relocate it
> >       such that...
> >       
> >       * For new EH, it's done in ata_eh_reset() before calling prereset.
> >       
> >       * For old EH, it's done before calling ap->ops->phy_reset() in
> >         ata_bus_probe().
> >       
> >       This makes PIO0 forced after all resets.  Another difference is that
> >       reset itself is done after PIO0 is forced.
> >       
> >       Signed-off-by: Tejun Heo <htejun@gmail.com>
> >       Acked-by: Alan Cox <alan@redhat.com>
> >       Signed-off-by: Jeff Garzik <jeff@garzik.org>
> > 
> > 
> > ATTENTION! The following patch solves the problem on my system, but please
> > be aware that I don't really know what I'm doing because I don't have the
> > big picture. There's surely a better way to check if the device/controller
> > is still functional than calling ata_link_{online,offline}.
> 
> In the above example, even the reset sequence itself can cause hang if
> the hardware is implemented slightly differently.  The reason why
> set_piomode() locks up but reset sequence doesn't is simple dumb luck.
> I think the proper fix is to tell libata to detach the cdrom before
> undocking.

Wouldn't the proper fix be to call ata_acpi_handle_hotplug _somewhere_?
(which is currently called nowhere AFAICS)

Anyway, kernel hackers keep telling me that the kernel should just do the
right thing. Shouldn't userspace never be able to freeze the system?

It's completely ok for me to handle this from userspace, if that's the
position of the libata developers.

In this case, we should change the dock driver to default to
immediate_undock=false, because otherwise it's far too risky to freeze the
system.

Regards,
	Holger
