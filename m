Return-Path: <linux-kernel-owner+w=401wt.eu-S1762792AbXJSMiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762792AbXJSMiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbXJSMh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:37:57 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:3166 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751320AbXJSMh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:37:56 -0400
Date: Fri, 19 Oct 2007 14:37:54 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Riku Voipio <riku.voipio@iki.fi>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] hwmon/f75375s.c: buggy if()
Message-ID: <20071019143754.0aa4483b@hyperion.delvare>
In-Reply-To: <20071018133744.GC3526@jupiter.solarsys.private>
References: <20071017195439.GD3778@stusta.de>
	<20071017204508.GA32110@kos.to>
	<20071018133744.GC3526@jupiter.solarsys.private>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark, hi Riku,

On Thu, 18 Oct 2007 09:37:44 -0400, Mark M. Hoffman wrote:
> That patch doesn't apply here, so I applied this:
> 
> commit 805763cd743f2aed41dc61a55569fa43cf1f240c
> Author: Riku Voipio <riku.voipio@iki.fi>
> Date:   Thu Oct 18 09:29:53 2007 -0400
> 
>     hwmon: (f75375s) fix pwm mode setting
>     
>     Spotted by the Coverity checker. (Thanks Adrian Bunk)
>     
>     Signed-off-by: Riku Voipio <riku.voipio@iki.fi>
>     Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>
> 
> diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
> index 13a0413..59a3470 100644
> --- a/drivers/hwmon/f75375s.c
> +++ b/drivers/hwmon/f75375s.c
> @@ -323,7 +323,7 @@ static ssize_t set_pwm_mode(struct device *dev, struct device_attribute *attr,
>  	int val = simple_strtoul(buf, NULL, 10);
>  	u8 conf = 0;
>  
> -	if (val != 0 || val != 1 || data->kind == f75373)
> +	if (!(val == 0 || val == 1) || data->kind == f75373)
>  		return -EINVAL;
>  
>  	mutex_lock(&data->update_lock);

BTW, that's the wrong way to do it. If the F75373S doesn't support
changing the PWM mode, then the sysfs attribute in question should be
read-only for this chip type. Making it writable and returning an error
on write is confusing.

Riku, can you please submit a patch fixing this? The attribute should
be declared read-only, and then you can use sysfs_chmod_file() to
change it to read-write where supported. Take a look at the w83781d
driver for an example.

Thanks,
-- 
Jean Delvare
