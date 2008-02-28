Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbYB1P6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbYB1P6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759276AbYB1P6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:58:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:50018 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758882AbYB1P6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:58:19 -0500
Date: Thu, 28 Feb 2008 16:58:17 +0100
From: Holger Macht <hmacht@suse.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] libata: Register for dock events when the drive is
	inside a dock station
Message-ID: <20080228155817.GB5593@homac.suse.de>
Mail-Followup-To: Tejun Heo <htejun@gmail.com>,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>
References: <20080214124048.GB9708@homac.suse.de> <20080214125615.GD9708@homac.suse.de> <47BC5F44.605@garzik.org> <20080221115305.GB5032@homac.suse.de> <47BE26A0.2040708@gmail.com> <20080226101551.GB10721@homac.suse.de> <47C6804A.50705@gmail.com> <20080228110927.GA5745@homac.suse.de> <47C6B1B1.2040602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C6B1B1.2040602@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 28. Feb - 22:05:53, Tejun Heo wrote:
> Holger Macht wrote:
> > On Thu 28. Feb - 18:35:06, Tejun Heo wrote:
> >> Holger Macht wrote:
> >>> The hotplug handler is only called if the device is actually inside the
> >>> dock station. If it is not, nothing will happen. I hope that I got your
> >>> question right?
> >> Yes, right.
> >>
> >>> However, if this would be helpful, it would be easy to add something like
> >>> a am_I_on_dock_station?(...) function to the dock driver.
> >> Hmm.. as long as the event is only delivered when the device is actually
> >> connected behind dock, I think it's okay.
> > 
> > The dock driver also export a is_dock_device(acpi_handle) function, which
> > could be used to make more fine-grained decisions, but it shouldn't be
> > needed here.
> > 
> >> Does the attached patch fix the previous undock problem?  It now
> >> explicitly tells libata EH to detach the notified devices on
> >> EJECT_REQUEST and wait for EH to complete such that control is returned
> >> to ACPI after all notified devices are actually detached.
> > 
> > No it does not. Apparently, it freezes faster (from 1 second down to
> > immediately). Before, it just froze when someone (in this case HAL) tried
> > to access the device. The "echo 1 > undock" call does not even return, so
> > it might have introduced another problem.
> 
> The code should be in generally right direction.  Can you be persuaded
> into tracking down what's going on?

I had a quick glance with adding some printk's. Now I got a different
behaviour once. System did not freeze, but were certainly confused. The
last thing which got printed to messages was exactly before
spin_lock_irqsave(ap->lock, flags); at the beginning of ata_acpi_handle_hotplug(...)

The printk immediately after this call didn't come through anymore (with
being able to use the system for a short time afterwards).

Maybe this helps.

For further debugging, I would have to setup remote debugger, but I doubt
I get around to do this for the next couple of days or even 1-2 weeks.

I could test new patches, of course.

Regards,
	Holger

P.S.: You'll need [1] patch for testing, otherwise the hotplug handler is
never called.

[1] http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=commit;h=3b5fee5952ff7eb6ff7a64247a01040b8b331b74
