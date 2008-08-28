Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbYH1DwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbYH1DwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 23:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbYH1DwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 23:52:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753884AbYH1DwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 23:52:02 -0400
Date: Wed, 27 Aug 2008 20:51:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 1/1] libata: Blackfin Pata Driver: Add proper PM
 operation into ATAPI driver.
Message-Id: <20080827205118.f13d537f.akpm@linux-foundation.org>
In-Reply-To: <1219809078-15767-1-git-send-email-cooloney@kernel.org>
References: <1219809078-15767-1-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008 11:51:18 +0800 Bryan Wu <cooloney@kernel.org> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/ata/pata_bf54x.c |   29 ++++++++++++++++++++++++-----
>  1 files changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
> index d393290..60f4872 100644
> --- a/drivers/ata/pata_bf54x.c
> +++ b/drivers/ata/pata_bf54x.c
> @@ -1632,6 +1632,8 @@ static int __devinit bfin_atapi_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> +	dev_set_drvdata(&pdev->dev, host);
> +
>  	return 0;
>  }
>  
> @@ -1648,6 +1650,7 @@ static int __devexit bfin_atapi_remove(struct platform_device *pdev)
>  	struct ata_host *host = dev_get_drvdata(dev);
>  
>  	ata_host_detach(host);
> +	dev_set_drvdata(&pdev->dev, NULL);
>  
>  	peripheral_free_list(atapi_io_port);
>  
> @@ -1657,11 +1660,27 @@ static int __devexit bfin_atapi_remove(struct platform_device *pdev)
>  #ifdef CONFIG_PM
>  int bfin_atapi_suspend(struct platform_device *pdev, pm_message_t state)
>  {
> -	return 0;
> +	struct ata_host *host = dev_get_drvdata(&pdev->dev);
> +	if (host)
> +		return ata_host_suspend(host, state);
> +	else
> +		return 0;
>  }
>  
>  int bfin_atapi_resume(struct platform_device *pdev)
>  {
> +	struct ata_host *host = dev_get_drvdata(&pdev->dev);
> +	int ret;
> +
> +	if (host) {
> +		ret = bfin_reset_controller(host);
> +		if (ret) {
> +			printk(KERN_ERR DRV_NAME ": Error during HW init\n");
> +			return ret;
> +		}
> +		ata_host_resume(host);
> +	}
> +
>  	return 0;
>  }
>  #endif
> @@ -1669,13 +1688,13 @@ int bfin_atapi_resume(struct platform_device *pdev)
>  static struct platform_driver bfin_atapi_driver = {
>  	.probe			= bfin_atapi_probe,
>  	.remove			= __devexit_p(bfin_atapi_remove),
> +#ifdef CONFIG_PM
> +	.suspend		= bfin_atapi_suspend,
> +	.resume			= bfin_atapi_resume,
> +#endif
>  	.driver = {
>  		.name		= DRV_NAME,
>  		.owner		= THIS_MODULE,
> -#ifdef CONFIG_PM
> -		.suspend	= bfin_atapi_suspend,
> -		.resume		= bfin_atapi_resume,
> -#endif
>  	},
>  };

I think we can make these fixes while we're there?

From: Andrew Morton <akpm@linux-foundation.org>

- remove the ifdefs using the usual pattern

- make things static

Cc: Bryan Wu <cooloney@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_bf54x.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/ata/pata_bf54x.c~libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver-fix drivers/ata/pata_bf54x.c
--- a/drivers/ata/pata_bf54x.c~libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver-fix
+++ a/drivers/ata/pata_bf54x.c
@@ -1658,7 +1658,7 @@ static int __devexit bfin_atapi_remove(s
 }
 
 #ifdef CONFIG_PM
-int bfin_atapi_suspend(struct platform_device *pdev, pm_message_t state)
+static int bfin_atapi_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	if (host)
@@ -1667,7 +1667,7 @@ int bfin_atapi_suspend(struct platform_d
 		return 0;
 }
 
-int bfin_atapi_resume(struct platform_device *pdev)
+static int bfin_atapi_resume(struct platform_device *pdev)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	int ret;
@@ -1683,15 +1683,16 @@ int bfin_atapi_resume(struct platform_de
 
 	return 0;
 }
+#else
+#define bfin_atapi_suspend NULL
+#define bfin_atapi_resume NULL
 #endif
 
 static struct platform_driver bfin_atapi_driver = {
 	.probe			= bfin_atapi_probe,
 	.remove			= __devexit_p(bfin_atapi_remove),
-#ifdef CONFIG_PM
 	.suspend		= bfin_atapi_suspend,
 	.resume			= bfin_atapi_resume,
-#endif
 	.driver = {
 		.name		= DRV_NAME,
 		.owner		= THIS_MODULE,
_

