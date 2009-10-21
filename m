Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZJUXLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZJUXLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 19:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZJUXLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 19:11:50 -0400
Received: from mga05.intel.com ([192.55.52.89]:46771 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755078AbZJUXLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 19:11:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,600,1249282800"; 
   d="scan'208";a="505980837"
Date: Thu, 22 Oct 2009 01:13:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, tony@atomide.com,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/4] MFD: twl4030: add twl4030_codec MFD as a new child
 to the core
Message-ID: <20091021231311.GF17796@sortiz.org>
References: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com>
 <1255956140-4829-2-git-send-email-peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255956140-4829-2-git-send-email-peter.ujfalusi@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Oct 19, 2009 at 03:42:17PM +0300, Peter Ujfalusi wrote:
> New MFD child to twl4030 MFD device.
> This MFD device will be used by the drivers, which needs resources
> from the twl4030 codec like audio and vibra.
> 
> The platform specific configuration data is passed along to the
> child drivers (audio, vibra).
Some comments on your code:

> +config TWL4030_CODEC
> +	bool "Support codec part of the TWL4030 family chips"
> +	depends on TWL4030_CORE
> +	help
> +	  Say yes here if you want to use the codec resources on the
> +	  TWL4030 family chips. The codec in TWL4030 provides the audio
> +	  functionality and also has the vibrator controls.
> +
> +	  This driver provides MFD device to be used for drivers, which needs
> +	  access to the codec part, the board-specific data is passed from this
> +	  driver to the childs as platform data with the board specific
> +	  configuration.
> +
As Mark noticed already, you dont really want users to explicitely select this
obscure mfd driver to get their audio and vibre driver selectable. It should
be the other way around, and I think you already agreed with that.


> +static struct device *
> +twl4030_codec_new_child(const char *name, void *pdata, unsigned pdata_len)
> +{
> +	struct platform_device	*pdev;
> +	int			status = 0;
> +
> +	pdev = platform_device_alloc(name, -1);
> +	if (!pdev) {
> +		dev_dbg(&twl4030_codec_dev->dev, "can't alloc dev (%s)\n",
> +									name);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +	pdev->dev.parent = &twl4030_codec_dev->dev;
> +
> +	if (pdata) {
> +		status = platform_device_add_data(pdev, pdata, pdata_len);
> +		if (status < 0) {
> +			dev_dbg(&pdev->dev, "can't add platform_data\n");
> +			goto err;
> +		}
> +	}
> +	status = platform_device_add(pdev);
> +	if (status < 0) {
> +		dev_dbg(&pdev->dev, "Adding platform device failed\n");
> +		goto err;
> +	}
> +
> +	return &pdev->dev;
> +err:
> +	platform_device_put(pdev);
> +	dev_err(&twl4030_codec_dev->dev, "can't add %s dev\n", name);
> +	return ERR_PTR(status);
> +}
This could really use the mfd-core API, and avoid duplicating code.
You just would have to define a couple cells, and call mfd_add_devices on
them.


> +static int __devexit twl4030_codec_remove(struct platform_device *pdev)
> +{
> +	struct twl4030_codec *codec = platform_get_drvdata(pdev);
> +
> +	platform_set_drvdata(pdev, NULL);
> +	kfree(codec);
> +	twl4030_codec_dev = NULL;
> +
> +	return 0;
> +}
I think you're missing a platform_device_unregister() here (or an
mfd_remove_devices() if you're going to switch to the mfd-core API)

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
