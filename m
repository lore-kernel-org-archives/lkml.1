Return-Path: <linux-kernel-owner+w=401wt.eu-S1763554AbXJRNl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763554AbXJRNl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 09:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbXJRNlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 09:41:17 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:5079 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbXJRNlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 09:41:16 -0400
Date: Thu, 18 Oct 2007 09:37:44 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Riku Voipio <riku.voipio@iki.fi>
Cc: Adrian Bunk <bunk@kernel.org>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: hwmon/f75375s.c: buggy if()
Message-ID: <20071018133744.GC3526@jupiter.solarsys.private>
References: <20071017195439.GD3778@stusta.de> <20071017204508.GA32110@kos.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017204508.GA32110@kos.to>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

* Riku Voipio <riku.voipio@iki.fi> [2007-10-17 23:45:08 +0300]:
> > <--  snip  -->
> > 
> > ...
> > static ssize_t set_pwm_mode(struct device *dev, struct device_attribute *attr,
> >                 const char *buf, size_t count)
> > {
> > ...
> >         if (val != 0 || val != 1 || data->kind == f75373)
> >                 return -EINVAL;
> > ...
> > 
> > <--  snip  -->
> 
> > I'm not sure what exactly was intended, but it was for sure not intended 
> > to always return -EINVAL...
> 
> Aiee. val should be 1 or 0, and kind must not be f75373.
> 
> Signed-off-by: Riku Voipio <riku.voipio@iki.fi>
> ---
>  drivers/hwmon/f75375s.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
> index f1df57a..885bfe9 100644
> --- a/drivers/hwmon/f75375s.c
> +++ b/drivers/hwmon/f75375s.c
> @@ -344,7 +344,7 @@ static ssize_t set_pwm_mode(struct device *dev, struct device_attribute *attr,
>     int val = simple_strtoul(buf, NULL, 10);
>     u8 conf = 0;
> 
> -   if (val != 0 || val != 1 || data->kind == f75373)
> +   if (!(val == 0 || val == 1 ) || data->kind == f75373)
>         return -EINVAL;
> 
>     mutex_lock(&data->update_lock);
> --
> 1.5.3.1

That patch doesn't apply here, so I applied this:

commit 805763cd743f2aed41dc61a55569fa43cf1f240c
Author: Riku Voipio <riku.voipio@iki.fi>
Date:   Thu Oct 18 09:29:53 2007 -0400

    hwmon: (f75375s) fix pwm mode setting
    
    Spotted by the Coverity checker. (Thanks Adrian Bunk)
    
    Signed-off-by: Riku Voipio <riku.voipio@iki.fi>
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index 13a0413..59a3470 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -323,7 +323,7 @@ static ssize_t set_pwm_mode(struct device *dev, struct device_attribute *attr,
 	int val = simple_strtoul(buf, NULL, 10);
 	u8 conf = 0;
 
-	if (val != 0 || val != 1 || data->kind == f75373)
+	if (!(val == 0 || val == 1) || data->kind == f75373)
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);

Thanks & regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com

