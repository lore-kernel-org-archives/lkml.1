Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbYBKL10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbYBKL10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 06:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYBKL1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 06:27:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:60789 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbYBKL1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 06:27:15 -0500
Date: Mon, 11 Feb 2008 12:28:02 +0100
From: Holger Macht <hmacht@suse.de>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, alan@redhat.com,
       jeff@garzik.org, Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] libata: Forcing PIO0 mode on reset must not freeze
	system
Message-ID: <20080211112802.GA4528@homac.suse.de>
Mail-Followup-To: Tejun Heo <htejun@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	alan@redhat.com, jeff@garzik.org,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>
References: <20080210195556.GA5261@homac> <47AFB4DB.1000204@gmail.com> <20080211100446.GA4646@homac.suse.de> <47B02E96.4050900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B02E96.4050900@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 11. Feb - 20:16:38, Tejun Heo wrote:
> Hello,
> 
> Holger Macht wrote:
> >> In the above example, even the reset sequence itself can cause hang if
> >> the hardware is implemented slightly differently.  The reason why
> >> set_piomode() locks up but reset sequence doesn't is simple dumb luck.
> >> I think the proper fix is to tell libata to detach the cdrom before
> >> undocking.
> > 
> > Wouldn't the proper fix be to call ata_acpi_handle_hotplug _somewhere_?
> > (which is currently called nowhere AFAICS)
> 
> It should be called via ata_acpi_{ap|dev}_notify() callbacks installed
> via acpi_install_notify_handler().  Can you add dump_stack() in the
> function and verify that it actually is being called?  It could be that
> the method is called too late or libata takes too long to actually
> unplug the device.  Hmmm... It seems what ata_acpi_handle_hotplug() does
> isn't enough for undock.  It probably should request detaching the
> device instead of just notifying hotplug event.  Anyways, please lemme
> know whether and when the function is called.

I already checked, it's never called AFAICS. And I couldn't find a place
where it should be installed, otherwise, I would have sent a patch. The
dock driver already calls the notify methods on devices in the dock
station before doing the real undock.

> > Anyway, kernel hackers keep telling me that the kernel should just do the
> > right thing. Shouldn't userspace never be able to freeze the system?
> 
> Yeah, I think most things should be done automatically but it's true
> that somethings are a bit awkward to handle in kernel.  Also, if you're
> root, you can almost always crash the machine from userland.
> 
> > It's completely ok for me to handle this from userspace, if that's the
> > position of the libata developers.
> 
> Let's see whether we can fix the ACPI handler first.

Yes,

> > In this case, we should change the dock driver to default to
> > immediate_undock=false, because otherwise it's far too risky to freeze the
> > system.
> 
> I'm not too familiar with how docks work.  Can you please explain
> briefly what immediate_undock is?

immediate_undock=1:
 User presses undock button on the dock station, dock driver calls ACPI
 undock method immediately.

immediate_undock=0:
 User presses undock button on the dock station, dock driver throws uevent
 and waits for userland to undock the system via sysfs.

immediate_undock is currently set to 1 by default.

Regards,
	Holger
