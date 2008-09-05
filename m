Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbYIEKgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbYIEKgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYIEKfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:35:53 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:54565 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYIEKfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:35:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SiYRr3shUc6hqqATBqbnXHBMI1m6wcv9JogW8ccojobsq3yU1fdcqEL/ahvp3FGr1B
         VjmEW08Zw+v73Qdw6Phe3NxhcC4IrQM8jDI99//YIIZPOuAN+JWFT9Is+wx2o1ywD9Id
         gu9OZxliSuIC4zriIH8fRLYOQ+hVmxTnpIGXA=
Date: Fri, 5 Sep 2008 14:33:18 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] platform: add new device registration helper
Message-ID: <20080905103318.GB25622@doriath.ww600.siemens.net>
References: <1220563816-8106-1-git-send-email-dbaryshkov@gmail.com> <20080904172050.cbde3013.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904172050.cbde3013.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 05:20:50PM -0700, Andrew Morton wrote:
> On Fri,  5 Sep 2008 01:30:16 +0400
> Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> 
> > Add a helper that registers simple platform_device
> > w/o resources but with parent and device data.
> > 
> > This is usefull to cleanup platform code from code that
> > registers such simple devices as leds-gpio, generic-bl,
> > etc.
> > 
> 
> nits:
> 
> > + *
> > + * This function creates a simple platform device that requires minimal
> > + * resource and memory management. Canned release function freeing memory
> > + * allocated for the device allows drivers using such devices to be
> > + * unloaded without waiting for the last reference to the device to be
> > + * dropped.
> 
> Should document the return value (tested with IS_ERR)

Will the wording "Returns a valid platform device, or a valid IS_ERR
condition containing errno" be appropriate?

> > +{
> > +	struct platform_device *pdev;
> > +	int retval;
> > +
> > +	pdev = platform_device_alloc(name, id);
> > +	if (!pdev) {
> > +		retval = -ENOMEM;
> > +		goto error;
> > +	}
> > +
> > +	pdev->dev.parent = parent;
> > +
> > +	if (size) {
> > +		retval = platform_device_add_data(pdev, data, size);
> > +		if (retval)
> > +			goto error;
> > +	}
> > +
> > +	retval = platform_device_add(pdev);
> > +	if (retval)
> > +		goto error;
> > +
> > +	return pdev;
> > +
> > +error:
> > +	platform_device_put(pdev);
> 
> Are you sure this can't trigger a !kobj->state_initialized warning in
> kobject_put()?

No. The kobject is initialised in platform_device_alloc() ->
device_initialise()

> >
> > ...
> >
> > +extern struct platform_device *platform_device_register_data(struct device *,
> > +		const char *, int, const void *, size_t);
> 
> It's nice (IMO) to include the names of the args, for documentation
> purposes.  Obviously the surrounding code didn't agree.

I just copied the surrounding code style. If you wish, I can put the
names for this function back.

BTW: would you prefer the followup "fix" patch or just the replacement
one?


-- 
With best wishes
Dmitry

