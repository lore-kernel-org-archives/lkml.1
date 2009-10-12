Return-Path: <linux-kernel-owner+w=401wt.eu-S932568AbZJLPjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbZJLPjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932420AbZJLPjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:39:16 -0400
Received: from poutre.nerim.net ([62.4.16.124]:53223 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932357AbZJLPjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:39:13 -0400
Date: Mon, 12 Oct 2009 17:38:24 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       "Michele De Candia (VT)" <michele.decandia@valueteam.com>,
       Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] ALS: TSL2550 driver move from i2c/chips
Message-ID: <20091012173824.0f3ef021@hyperion.delvare>
In-Reply-To: <4AD3477D.4020904@cam.ac.uk>
References: <4ACF4AC6.7070802@cam.ac.uk>
	<20091010183347.52b043ed@hyperion.delvare>
	<4AD3477D.4020904@cam.ac.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 16:13:01 +0100, Jonathan Cameron wrote:
> Hi Jean,
> > 
> > On Fri, 09 Oct 2009 15:37:58 +0100, Jonathan Cameron wrote:
> >> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> >>
> >> ---
> >> Minimal changes made. Untested due to lack of hardware.
> >> All comments welcome.
> > 
> > Thanks for working on this. I can do any amount of testing you want, as
> > I have received a TSL2550 evaluation module from TAOS.
> > 
> >> illuminance is already documented as part of the class.
> >> operating mode and power state are both as per the original
> >> driver. I can't find any documentation for them, but if people
> >> want it I can probably figure out what they are from
> >> the data sheet.
> > 
> > The operating mode selects the measurable range. Standard range is from
> > 0 to 1846 lux, extended range is from 0 to 9230 lux, with a resolution
> > divided by 5. Extended mode is also 5 times faster.
> > 
> > What do we want to do with this? I am open to suggestions. There are
> > several possibilities. The operating mode could be provided as platform
> > data and stay internal to the driver. Or we can leave is visible to
> > user-space, in which case I'd recommend that we do so in terms of
> > "range" rather than "mode", so that other drivers can use the same
> > convention, whatever it becomes. For example, one would write the range
> > of values he/she wants to be able to measure and the driver would put
> > the device in the most appropriate mode.
>
> That sounds like a sensible approach.  For now I guess a sysfs parameter
> like illuminance_range_max would do the job and we can add a min for any
> device that features an offset?

Yes, this sounds sensible.

> > Alternatively (or additionally), we could implement an automatic mode
> > which would change the mode dynamically based on the previous
> > measurement. I've done that for one hwmon driver (for fan speed
> > measurement) and it works very well, if implemented properly.
>
> Could do.  Maybe put it in as manual for now and leave the automatic
> mode for a later date?

Yes. Note that the automatic mode may have to be optional, too. I can
imagine use cases where one prefers to stick to a given range and spare
I2C bus cycles.

> >> Might be worth dropping the power state control and moving
> >> over to runtime pm but that is definitely the topic for another
> >> patch.
> > 
> > Power state control is already integrated into the PM framework
> > (suspend and resume, is there more?) The sysfs entry is to allow a
> > manual control on top of it. I don't much like having a custom sysfs
> > entry for this, but I don't know if there is a standard way to achieve
> > the same?
>
> Not directly as far as I know. The runtime pm is more about buses figuring
> out if they can suspend (and take their children into suspend as well).
> Personally I haven't looked at the code for those buses that implement it
> yet to see exactly how it relates to fine grained control as here.
> For now lets leave this as it is with a plan to fix it later.
> 
> I do notice that usb supports this sort of control by adding sysfs entries to
> the existing power sysfs attribute group.
> (curiously I think the relevant one is called level, so we would have
> /sys/bus/i2c/devices/*/power/level
> 
> We could do the same...

Are these levels part of the USB specification? In the case of the
TSL2550, it has very little to do with the I2C specification. It's just
about enabling/disabling light sensing, much like you'd disable a
temperature sensor when you don't need it, to save power. That kind of
power level switching is not bus-specific. You can see it as either
device-specific, if you go into the details, or general, if you don't.

-- 
Jean Delvare
