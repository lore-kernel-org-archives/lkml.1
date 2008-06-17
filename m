Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbYFQSGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbYFQSGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 14:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbYFQSFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 14:05:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2326 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755583AbYFQSFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 14:05:44 -0400
Date: Tue, 17 Jun 2008 17:54:48 +0200
From: Pavel Machek <pavel@suse.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: rui.zhang@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Clean up thermal API
Message-ID: <20080617155448.GA4891@ucw.cz>
References: <20080611100647.GA20013@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611100647.GA20013@srcf.ucam.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The thermal layer passes temperatures around as strings. This is fine 
> for sysfs, but makes it hard to use them for other purposes in-kernel. 
> Change them to longs and do the string conversion in the sysfs-specific 
> code.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Looks mostly ok to me.


> -static int thermal_get_temp(struct thermal_zone_device *thermal, char *buf)
> +static int thermal_get_temp(struct thermal_zone_device *thermal, 
> +			    unsigned long *temp)

Hmm, it would be cool to create typedef unsigned long milicelsius, so
that this is self-documenting and possibly sparse-checkable.



> @@ -898,7 +899,8 @@ static int thermal_get_temp(struct thermal_zone_device *thermal, char *buf)
>  	if (result)
>  		return result;
>  
> -	return sprintf(buf, "%ld\n", KELVIN_TO_MILLICELSIUS(tz->temperature));
> +	*temp = KELVIN_TO_MILLICELSIUS(tz->temperature);
> +	return 0;
>  }

Hmmm, if we did interface in miliKelvins, we would be able to do
-errno trick :-).


>  	if (!tz->ops->get_temp)
>  		return -EPERM;
>  
> -	return tz->ops->get_temp(tz, buf);
> +	ret = tz->ops->get_temp(tz,&temperature);

missing space after , .

> +	if (ret)
> +		return ret;
> +
> +	return sprintf(buf,"%ld\n",temperature);
>  }

More mising spaces.

> +	if (ret)
> +		return ret;
> +
> +	return sprintf (buf, "%ld\n", temperature);
>  }

And some extra spaces here: 'sprintf('.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
