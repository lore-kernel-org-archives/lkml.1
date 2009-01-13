Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZAMWkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZAMWkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbZAMWkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:40:23 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56545 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbZAMWkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:40:22 -0500
Date: Tue, 13 Jan 2009 23:40:13 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, eric.piel@tremplin-utc.net
Subject: Re: hp_accel: do not call ACPI from invalid context
Message-ID: <20090113224013.GC7770@elf.ucw.cz>
References: <20090112103155.GA6652@elf.ucw.cz> <20090113141721.ccd90351.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113141721.ccd90351.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-01-13 14:17:21, Andrew Morton wrote:
> On Mon, 12 Jan 2009 11:31:55 +0100
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > 
> > LED on HP notebooks is connected through ACPI. That unfortunately
> > means that it needs to be delayed by using schedule_work() to avoid
> > calling ACPI interpretter in invalid context. This patch fixes that.
> > 
> > ...
> >  
> > +/* Delayed LEDs infrastructure ------------------------------------ */ 
> > +
> > +/* Special LED class that can defer work */
> > +struct delayed_led_classdev {
> > +	struct led_classdev led_classdev;
> > +	struct work_struct work;
> > +	enum led_brightness new_brightness;
> > +
> > +	unsigned int led;		/* For driver */
> > +	void (*set_brightness)(struct delayed_led_classdev *data, enum led_brightness value);
> > +};
> > +
> > +static inline void delayed_set_status_worker(struct work_struct *work)
> > +{
> > +	struct delayed_led_classdev *data =
> > +			container_of(work, struct delayed_led_classdev, work);
> > +
> > +	data->set_brightness(data, data->new_brightness);
> > +}
> > +
> > +static inline void delayed_sysfs_set(struct led_classdev *led_cdev,
> > +			      enum led_brightness brightness)
> > +{
> > +	struct delayed_led_classdev *data = container_of(led_cdev,
> > +			     struct delayed_led_classdev, led_classdev);
> > +	data->new_brightness = brightness;
> > +	schedule_work(&data->work);
> > +}
> 
> Is this the only LED driver int he current and future history of the
> world which uses ACPI?
> 
> coz otherwise, this code might better live in LEDs core somewhere, so
> those other drivers can use it?

There are 2 other drivers (thinkpad_acpi and asus-something IIRC) that
want the same infrastructure. So I put that code in
include/linux/delayed-leds.h in my tree, but then I realized I'd need
to coordinate too many maintainers and just inlined it for the
merge. (We do not want to schedule from atomic, right?)

I already have a patch for thinkpad_acpi, but it needs a bit more
testing and perhaps some tweaks by maintainer. So yes, eventually
putting that into shared place is a plan.

> >  	if (ret) {
> > -		led_classdev_unregister(&hpled_led);
> > +		while (work_pending(&hpled_led.work))
> > +			schedule();
> 
> We have flush_work() for this?

I did not realize flush_work() exists/does what I need... sorry.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
