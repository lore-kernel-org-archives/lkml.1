Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbZIAIc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbZIAIc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbZIAIc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:32:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:43192 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZIAIc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:32:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,311,1249282800"; 
   d="scan'208";a="489321514"
Subject: Re: [PATCH V6 1/2] introduce ALS sysfs class
From: Zhang Rui <rui.zhang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Greg KH <greg@kroah.com>
In-Reply-To: <20090901081114.GA9942@elf.ucw.cz>
References: <1251789947.3483.215.camel@rzhang-dt>
	 <20090901081114.GA9942@elf.ucw.cz>
Content-Type: text/plain
Date: Tue, 01 Sep 2009 16:30:44 +0800
Message-Id: <1251793844.3483.228.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-01 at 16:11 +0800, Pavel Machek wrote:
> Hi!
> 
> > Introduce ALS sysfs class.
> > 
> > ALS sysfs class provides a standard sysfs interface for
> > Ambient Light Sensor devices.
> > 
> > please read Documentation/ABI/testing/sysfs-class-als for
> > detailed sysfs designs.
> 
> Thanks for fixing the interface!
> 
> > +static ssize_t
> > +illuminance_show(struct device *dev, struct device_attribute *attr, char *buf)
> > +{
> > +	struct als_device *als = to_als_device(dev);
> > +	int illuminance;
> > +	int result;
> > +
> > +	result = als->ops->get_illuminance(als, &illuminance);
> > +	if (result)
> > +		return result;
> > +
> > +	if (!illuminance)
> > +		return sprintf(buf, "Illuminance below the supported range\n");
> > +	else if (illuminance == -1)
> > +		return sprintf(buf, "Illuminance above the supported range\n");
> > +	else if (illuminance < -1)
> > +		return -ERANGE;
> > +	else
> > +		return sprintf(buf, "%d\n", illuminance);
> > +}
> 
> that's nor particulary clean. One value per file and all that. Could
> we simply return errnos in _all_ the error cases? (Docs would suggest
> this contains integer so string is definitely unexpected).
> 
IMO, 0 and -1 are not errors. they just suggest that the Ambient Light
illuminance is beyond the device support range, while the device is
still working normally.
what about exporting these values (0 and -1) to user space directly?

> 
> > +static ssize_t
> > +adjustment_show(struct device *dev, struct device_attribute *attr, char *buf)
> > +{
> > +	struct als_device *als = to_als_device(dev);
> > +	int illuminance, adjustment;
> > +	int result;
> > +
> > +	result = als->ops->get_illuminance(als, &illuminance);
> > +	if (result)
> > +		return result;
> > +
> > +	if (illuminance < 0 && illuminance != -1)
> > +		return sprintf(buf, "Current illuminance invalid\n");
> > +
> > +	result = als_get_adjustment(als, illuminance, &adjustment);
> > +	if (result)
> > +		return result;
> > +
> > +	return sprintf(buf, "%d%%\n", adjustment);
> > +}
> 
> You should not return strings... and in this case it is not clear how
> the code works. You fill the buf, but then return...? 

As the adjustment is a percentage value, I added a '%' postfix so that
users won't be confused.
yes, it's okay to just export the integer, e.g. "100" instead of "100%".

thanks,
rui

