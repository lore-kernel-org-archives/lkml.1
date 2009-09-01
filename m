Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbZIAInR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbZIAInR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbZIAInP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:43:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56175 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbZIAInM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:43:12 -0400
Date: Tue, 1 Sep 2009 10:43:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH V6 1/2] introduce ALS sysfs class
Message-ID: <20090901084306.GD9942@elf.ucw.cz>
References: <1251789947.3483.215.camel@rzhang-dt> <20090901081114.GA9942@elf.ucw.cz> <1251793844.3483.228.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251793844.3483.228.camel@rzhang-dt>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-09-01 16:30:44, Zhang Rui wrote:
> On Tue, 2009-09-01 at 16:11 +0800, Pavel Machek wrote:
> > Hi!
> > 
> > > Introduce ALS sysfs class.
> > > 
> > > ALS sysfs class provides a standard sysfs interface for
> > > Ambient Light Sensor devices.
> > > 
> > > please read Documentation/ABI/testing/sysfs-class-als for
> > > detailed sysfs designs.
> > 
> > Thanks for fixing the interface!
> > 
> > > +static ssize_t
> > > +illuminance_show(struct device *dev, struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct als_device *als = to_als_device(dev);
> > > +	int illuminance;
> > > +	int result;
> > > +
> > > +	result = als->ops->get_illuminance(als, &illuminance);
> > > +	if (result)
> > > +		return result;
> > > +
> > > +	if (!illuminance)
> > > +		return sprintf(buf, "Illuminance below the supported range\n");
> > > +	else if (illuminance == -1)
> > > +		return sprintf(buf, "Illuminance above the supported range\n");
> > > +	else if (illuminance < -1)
> > > +		return -ERANGE;
> > > +	else
> > > +		return sprintf(buf, "%d\n", illuminance);
> > > +}
> > 
> > that's nor particulary clean. One value per file and all that. Could
> > we simply return errnos in _all_ the error cases? (Docs would suggest
> > this contains integer so string is definitely unexpected).
> > 
> IMO, 0 and -1 are not errors. they just suggest that the Ambient Light
> illuminance is beyond the device support range, while the device is
> still working normally.
> what about exporting these values (0 and -1) to user space directly?

Returning 0 for "below" range and 99999999 for "above" range would be
nice, yes. 

> > 
> > > +static ssize_t
> > > +adjustment_show(struct device *dev, struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct als_device *als = to_als_device(dev);
> > > +	int illuminance, adjustment;
> > > +	int result;
> > > +
> > > +	result = als->ops->get_illuminance(als, &illuminance);
> > > +	if (result)
> > > +		return result;
> > > +
> > > +	if (illuminance < 0 && illuminance != -1)
> > > +		return sprintf(buf, "Current illuminance invalid\n");
> > > +
> > > +	result = als_get_adjustment(als, illuminance, &adjustment);
> > > +	if (result)
> > > +		return result;
> > > +
> > > +	return sprintf(buf, "%d%%\n", adjustment);
> > > +}
> > 
> > You should not return strings... and in this case it is not clear how
> > the code works. You fill the buf, but then return...? 
> 
> As the adjustment is a percentage value, I added a '%' postfix so that
> users won't be confused.
> yes, it's okay to just export the integer, e.g. "100" instead of "100%".

The "%" postfix is okay, but returning "Current illuminance invalid"
is ugly. Better return -EINVAL or -EIO or something.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
