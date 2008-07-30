Return-Path: <linux-kernel-owner+w=401wt.eu-S1762482AbYG3OYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762482AbYG3OYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYG3OYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:24:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58291 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752754AbYG3OYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:24:37 -0400
Date: Wed, 30 Jul 2008 10:24:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Roberto Oppedisano <roppedisano@infracomspa.it>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: 2.6.26-00000-g8be1a6d - WARNING: at drivers/base/power/main.c:82
In-Reply-To: <20080730011616.b68393bc.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0807301017330.2584-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, Andrew Morton wrote:

> On Mon, 28 Jul 2008 13:33:21 +0200 Roberto Oppedisano <roppedisano@infracomspa.it> wrote:
> 
> > More info on request.
> > 
> 
> Let's cc linux-usb, as that appears to be the subsystem which triggered
> this:
> 
> int device_pm_add(struct device *dev)
> {
> 	int error;
> 
> 	pr_debug("PM: Adding info for %s:%s\n",
> 		 dev->bus ? dev->bus->name : "No Bus",
> 		 kobject_name(&dev->kobj));
> 	mutex_lock(&dpm_list_mtx);
> 	if (dev->parent) {
> 		if (dev->parent->power.status >= DPM_SUSPENDING) {
> 			dev_warn(dev, "parent %s is sleeping, will not add\n",
> 				dev->parent->bus_id);
> 			WARN_ON(true);
> 		}
> 
> WARN_ON.
> 
> Also, I assume that your kernel did print that "parent %s is sleeping"
> message, but you trimmed it off.  That would probably be useful
> information.

Hmmm...  I don't suppose anyone ever thought to indicate which kernel 
version produced this warning?

If you look at the offending source code in 2.6.27-rc1, you'll find a
comment that explains the whole thing.  From do_unbind_rebind() --
admittedly not easy to single out from the rather lengthy stack trace
-- in drivers/usb/core/driver.c:

	/* FIXME: The next line is needed because we are going to probe
	 * the interface, but as far as the PM core is concerned the
	 * interface is still suspended.  The problem wouldn't exist
	 * if we could rebind the interface during the interface's own
	 * resume() call, but at the time the usb_device isn't locked!
	 *
	 * The real solution will be to carry this out during the device's
	 * complete() callback.  Until that is implemented, we have to
	 * use this hack.
	 */
//					intf->dev.power.sleeping = 0;

The last line had to be commented out because the power.sleeping field 
was removed during the transition from 2.6.26 to 2.6.27-rc1.  The code 
that will make this work properly, with no warnings, hasn't been 
written yet; I was waiting for 2.6.27-rc1 to appear so there'd be a 
more-or-less stable base to work from.

For the time being you can simply ignore the WARNING; it is harmless.

Alan Stern

