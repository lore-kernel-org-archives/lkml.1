Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbZKWMYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbZKWMYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 07:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757124AbZKWMYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 07:24:22 -0500
Received: from mga10.intel.com ([192.55.52.92]:44474 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756945AbZKWMYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 07:24:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,271,1257148800"; 
   d="scan'208";a="516497472"
Date: Mon, 23 Nov 2009 13:26:07 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Fertser <fercerpav@gmail.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: linux-next: mfd tree build failure
Message-ID: <20091123122606.GA3616@sortiz.org>
References: <20091123143503.3cdf8dee.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123143503.3cdf8dee.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Mon, Nov 23, 2009 at 02:35:03PM +1100, Stephen Rothwell wrote:
> Hi Samuel,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/power/pcf50633-charger.c: In function 'pcf50633_mbc_get_usb_online_status':
> drivers/power/pcf50633-charger.c:147: error: 'struct pcf50633' has no member named 'mbc_pdev'
> 
> Caused by commit 4c2e3bacc050f0ebf884954bb007616c162564cd ("mfd: pcf50633
> - fix error handling during probe") from the mfd tree interacting with
> commit c329795052aa339850a45fab649ab97a36905136 ("pcf50633: Query charger
> status directly") from the battery tree.
Could we split the above fix so that we get back to the:

	struct platform_device *rtc_pdev;
	struct platform_device *mbc_pdev;
	struct platform_device *adc_pdev;
	struct platform_device *input_pdev;
	struct platform_device *regulator_pdev[PCF50633_NUM_REGULATORS];

structure ? We can move to the index based structure after the next merge
window. That would make my life easier in terms of tree dependencies.
If you dont have time to do this change, I'll do it some time this week.

Thanks in advance.

Cheers,
Samuel.


> I have applied the following merge fixup patch and can carry it as
> necessary.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 23 Nov 2009 14:31:43 +1100
> Subject: [PATCH] mfd: fix pcf50633-charger.c for fallout from merge
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/power/pcf50633-charger.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
> index d4a3e77..4e535bb 100644
> --- a/drivers/power/pcf50633-charger.c
> +++ b/drivers/power/pcf50633-charger.c
> @@ -144,7 +144,8 @@ EXPORT_SYMBOL_GPL(pcf50633_mbc_get_status);
>  
>  int pcf50633_mbc_get_usb_online_status(struct pcf50633 *pcf)
>  {
> -	struct pcf50633_mbc *mbc  = platform_get_drvdata(pcf->mbc_pdev);
> +	struct pcf50633_mbc *mbc =
> +		platform_get_drvdata(pcf->pdevs[PCF50633_PDEV_ADC_IDX]);
>  
>  	if (!mbc)
>  		return 0;
> -- 
> 1.6.5.3
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
