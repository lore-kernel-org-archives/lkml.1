Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbZAUOYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbZAUOYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 09:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbZAUOYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 09:24:39 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:45578 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZAUOYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 09:24:38 -0500
X-Greylist: delayed 1194 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2009 09:24:37 EST
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4977302C.1090004@cam.ac.uk>
Date: Wed, 21 Jan 2009 14:24:44 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Hoist struct regulator_dev out of core to
 fix notifiers
References: <1232546920-14915-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1232546920-14915-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> Commit 872ed3fe176833f7d43748eb88010da4bbd2f983 caused regulator drivers
> to take the struct regulator_dev lock themselves which requires that the
> struct be visible to them. Band aid this by making the struct visible.
Sorry all for introducing the problem in the first place.

Other option for a fix would be to move the lock into the 
regulator_notifier_call_chain function.  Probably not ideal as would lead
to possibility of releasing then immediately retaking the lock that we
were trying to avoid by pushing the locks out in the first place.

Guess it's a case of how much we want to put people off directly accessing
elements of regulator_dev.

Thanks for posting the fix Mark (just beat me to it ;)

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c         |   27 ---------------------------
>  include/linux/regulator/driver.h |   32 ++++++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index f17362a..0ed13c2 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -30,33 +30,6 @@ static LIST_HEAD(regulator_list);
>  static LIST_HEAD(regulator_map_list);
>  
>  /*
> - * struct regulator_dev
> - *
> - * Voltage / Current regulator class device. One for each regulator.
> - */
> -struct regulator_dev {
> -	struct regulator_desc *desc;
> -	int use_count;
> -
> -	/* lists we belong to */
> -	struct list_head list; /* list of all regulators */
> -	struct list_head slist; /* list of supplied regulators */
> -
> -	/* lists we own */
> -	struct list_head consumer_list; /* consumers we supply */
> -	struct list_head supply_list; /* regulators we supply */
> -
> -	struct blocking_notifier_head notifier;
> -	struct mutex mutex; /* consumer lock */
> -	struct module *owner;
> -	struct device dev;
> -	struct regulation_constraints *constraints;
> -	struct regulator_dev *supply;	/* for tree */
> -
> -	void *reg_data;		/* regulator_dev data */
> -};
> -
> -/*
>   * struct regulator_map
>   *
>   * Used to provide symbolic supply names to devices.
> diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
> index 2254ad9..c263e36 100644
> --- a/include/linux/regulator/driver.h
> +++ b/include/linux/regulator/driver.h
> @@ -137,6 +137,38 @@ struct regulator_desc {
>  	struct module *owner;
>  };
>  
> +/*
> + * struct regulator_dev
> + *
> + * Voltage / Current regulator class device. One for each
> + * regulator.
> + *
> + * This should *not* be used directly by anything except the regulator
> + * core and notification injection (which should take the mutex and do
> + * no other direct access).
> + */
> +struct regulator_dev {
> +	struct regulator_desc *desc;
> +	int use_count;
> +
> +	/* lists we belong to */
> +	struct list_head list; /* list of all regulators */
> +	struct list_head slist; /* list of supplied regulators */
> +
> +	/* lists we own */
> +	struct list_head consumer_list; /* consumers we supply */
> +	struct list_head supply_list; /* regulators we supply */
> +
> +	struct blocking_notifier_head notifier;
> +	struct mutex mutex; /* consumer lock */
> +	struct module *owner;
> +	struct device dev;
> +	struct regulation_constraints *constraints;
> +	struct regulator_dev *supply;	/* for tree */
> +
> +	void *reg_data;		/* regulator_dev data */
> +};
> +
>  struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
>  	struct device *dev, struct regulator_init_data *init_data,
>  	void *driver_data);

