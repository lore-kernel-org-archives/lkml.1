Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbZKOWUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbZKOWUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 17:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZKOWUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 17:20:44 -0500
Received: from mga10.intel.com ([192.55.52.92]:6473 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751775AbZKOWUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 17:20:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,747,1249282800"; 
   d="scan'208";a="747219374"
Date: Sun, 15 Nov 2009 23:22:36 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Balaji Rao <balajirrao@openmoko.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: pcf50633 - use threaded interrupts
Message-ID: <20091115222235.GB8367@sortiz.org>
References: <20091109092447.29634.79364.stgit@localhost.localdomain>
 <20091109092521.29634.17236.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109092521.29634.17236.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Mon, Nov 09, 2009 at 01:25:21AM -0800, Dmitry Torokhov wrote:
> Switch to using theraded IRQs instead of implementing custom solution
> with regular inettrup dandler and a custom workqueue.
Same as the first patch, this one contains both a fairly intrusibe change
along with comment and whitespace cleanups. I'd appreciate if you could remove
those cleanup parts from this patch.

Also, Balaji could you please give this patch a try before I apply it ?

Cheers,
Samuel.


> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
>  drivers/mfd/pcf50633-core.c       |   87 +++++++++++--------------------------
>  include/linux/mfd/pcf50633/core.h |    6 +--
>  2 files changed, 29 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
> index a3d0226..4aeefa2 100644
> --- a/drivers/mfd/pcf50633-core.c
> +++ b/drivers/mfd/pcf50633-core.c
> @@ -126,7 +126,6 @@ int pcf50633_reg_set_bit_mask(struct pcf50633 *pcf, u8 reg, u8 mask, u8 val)
>  
>  out:
>  	mutex_unlock(&pcf->lock);
> -
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(pcf50633_reg_set_bit_mask);
> @@ -324,13 +323,13 @@ static void pcf50633_irq_call_handler(struct pcf50633 *pcf, int irq)
>  /* Maximum amount of time ONKEY is held before emergency action is taken */
>  #define PCF50633_ONKEY1S_TIMEOUT 8
>  
> -static void pcf50633_irq_worker(struct work_struct *work)
> +static irqreturn_t pcf50633_irq(int irq, void *data)
>  {
> -	struct pcf50633 *pcf;
> +	struct pcf50633 *pcf = data;
>  	int ret, i, j;
>  	u8 pcf_int[5], chgstat;
>  
> -	pcf = container_of(work, struct pcf50633, irq_work);
> +	dev_dbg(pcf->dev, "pcf50633_irq\n");
>  
>  	/* Read the 5 INT regs in one transaction */
>  	ret = pcf50633_read_block(pcf, PCF50633_REG_INT1,
> @@ -345,8 +344,10 @@ static void pcf50633_irq_worker(struct work_struct *work)
>  		goto out;
>  	}
>  
> -	/* We immediately read the usb and adapter status. We thus make sure
> -	 * only of USBINS/USBREM IRQ handlers are called */
> +	/*
> +	 * We immediately read the usb and adapter status. We thus make sure
> +	 * only of USBINS/USBREM IRQ handlers are called
> +	 */
>  	if (pcf_int[0] & (PCF50633_INT1_USBINS | PCF50633_INT1_USBREM)) {
>  		chgstat = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
>  		if (chgstat & (0x3 << 4))
> @@ -364,15 +365,17 @@ static void pcf50633_irq_worker(struct work_struct *work)
>  			pcf_int[0] &= ~(1 << PCF50633_INT1_ADPINS);
>  	}
>  
> -	dev_dbg(pcf->dev, "INT1=0x%02x INT2=0x%02x INT3=0x%02x "
> -			"INT4=0x%02x INT5=0x%02x\n", pcf_int[0],
> -			pcf_int[1], pcf_int[2], pcf_int[3], pcf_int[4]);
> +	dev_dbg(pcf->dev,
> +		"INT1=0x%02x INT2=0x%02x INT3=0x%02x INT4=0x%02x INT5=0x%02x\n",
> +		pcf_int[0], pcf_int[1], pcf_int[2], pcf_int[3], pcf_int[4]);
>  
> -	/* Some revisions of the chip don't have a 8s standby mode on
> -	 * ONKEY1S press. We try to manually do it in such cases. */
> +	/*
> +	 * Some revisions of the chip don't have a 8s standby mode on
> +	 * ONKEY1S press. We try to manually do it in such cases.
> +	 */
>  	if ((pcf_int[0] & PCF50633_INT1_SECOND) && pcf->onkey1s_held) {
> -		dev_info(pcf->dev, "ONKEY1S held for %d secs\n",
> -							pcf->onkey1s_held);
> +		dev_info(pcf->dev,
> +			 "ONKEY1S held for %d secs\n", pcf->onkey1s_held);
>  		if (pcf->onkey1s_held++ == PCF50633_ONKEY1S_TIMEOUT)
>  			if (pcf->pdata->force_shutdown)
>  				pcf->pdata->force_shutdown(pcf);
> @@ -409,8 +412,8 @@ static void pcf50633_irq_worker(struct work_struct *work)
>  	}
>  
>  	/* Have we just resumed ? */
> -	if (pcf->is_suspended) {
> -		pcf->is_suspended = 0;
> +	if (unlikely(pcf->is_suspended)) {
> +		pcf->is_suspended = false;
>  
>  		/* Set the resume reason filtering out non resumers */
>  		for (i = 0; i < ARRAY_SIZE(pcf_int); i++)
> @@ -432,20 +435,6 @@ static void pcf50633_irq_worker(struct work_struct *work)
>  	}
>  
>  out:
> -	put_device(pcf->dev);
> -	enable_irq(pcf->irq);
> -}
> -
> -static irqreturn_t pcf50633_irq(int irq, void *data)
> -{
> -	struct pcf50633 *pcf = data;
> -
> -	dev_dbg(pcf->dev, "pcf50633_irq\n");
> -
> -	get_device(pcf->dev);
> -	disable_irq_nosync(pcf->irq);
> -	queue_work(pcf->work_queue, &pcf->irq_work);
> -
>  	return IRQ_HANDLED;
>  }
>  
> @@ -538,13 +527,9 @@ static int pcf50633_suspend(struct device *dev, pm_message_t state)
>  
>  	pcf = dev_get_drvdata(dev);
>  
> -	/* Make sure our interrupt handlers are not called
> -	 * henceforth */
> +	/* Make sure our interrupt handlers are not called henceforth. */
>  	disable_irq(pcf->irq);
>  
> -	/* Make sure that any running IRQ worker has quit */
> -	cancel_work_sync(&pcf->irq_work);
> -
>  	/* Save the masks */
>  	ret = pcf50633_read_block(pcf, PCF50633_REG_INT1M,
>  				ARRAY_SIZE(pcf->suspend_irq_masks),
> @@ -565,7 +550,7 @@ static int pcf50633_suspend(struct device *dev, pm_message_t state)
>  		goto out;
>  	}
>  
> -	pcf->is_suspended = 1;
> +	pcf->is_suspended = true;
>  
>  out:
>  	return ret;
> @@ -573,11 +558,9 @@ out:
>  
>  static int pcf50633_resume(struct device *dev)
>  {
> -	struct pcf50633 *pcf;
> +	struct pcf50633 *pcf = dev_get_drvdata(dev);
>  	int ret;
>  
> -	pcf = dev_get_drvdata(dev);
> -
>  	/* Write the saved mask registers */
>  	ret = pcf50633_write_block(pcf, PCF50633_REG_INT1M,
>  				ARRAY_SIZE(pcf->suspend_irq_masks),
> @@ -585,16 +568,11 @@ static int pcf50633_resume(struct device *dev)
>  	if (ret < 0)
>  		dev_err(pcf->dev, "Error restoring saved suspend masks\n");
>  
> -	/* Restore regulators' state */
> -
> -
> -	get_device(pcf->dev);
> -
>  	/*
>  	 * Clear any pending interrupts and set resume reason if any.
> -	 * This will leave with enable_irq()
>  	 */
> -	pcf50633_irq_worker(&pcf->irq_work);
> +	pcf50633_irq(pcf->irq, pcf);
> +	enable_irq(pcf->irq);
>  
>  	return 0;
>  }
> @@ -628,21 +606,12 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
>  	pcf->i2c_client = client;
>  	pcf->irq = client->irq;
>  
> -	pcf->work_queue = create_singlethread_workqueue("pcf50633");
> -	if (!pcf->work_queue) {
> -		dev_err(pcf->dev, "Failed to create workqueue\n");
> -		error = -ENOMEM;
> -		goto err_free_mem;
> -	}
> -
> -	INIT_WORK(&pcf->irq_work, pcf50633_irq_worker);
> -
>  	version = pcf50633_reg_read(pcf, 0);
>  	variant = pcf50633_reg_read(pcf, 1);
>  	if (version < 0 || variant < 0) {
>  		dev_err(pcf->dev, "Unable to probe pcf50633\n");
>  		error = -ENODEV;
> -		goto err_destroy_wq;
> +		goto err_free_mem;
>  	}
>  
>  	dev_info(pcf->dev, "Probed device version %d variant %d\n",
> @@ -682,8 +651,9 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
>  			goto err_free_pdevs;
>  	}
>  
> -	error = request_irq(client->irq, pcf50633_irq,
> -			    IRQF_TRIGGER_LOW, "pcf50633", pcf);
> +	error = request_threaded_irq(client->irq, NULL, pcf50633_irq,
> +				     IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +				     "pcf50633", pcf);
>  	if (error) {
>  		dev_err(pcf->dev, "Failed to request IRQ %d\n", error);
>  		goto err_free_pdevs;
> @@ -709,8 +679,6 @@ err_free_irq:
>  	free_irq(pcf->irq, pcf);
>  err_free_pdevs:
>  	pcf50633_unregister_sub_devices(pcf);
> -err_destroy_wq:
> -	destroy_workqueue(pcf->work_queue);
>  err_free_mem:
>  	kfree(pcf);
>  	return error;
> @@ -722,7 +690,6 @@ static int __devexit pcf50633_remove(struct i2c_client *client)
>  
>  
>  	free_irq(pcf->irq, pcf);
> -	destroy_workqueue(pcf->work_queue);
>  
>  	pcf50633_unregister_sub_devices(pcf);
>  
> diff --git a/include/linux/mfd/pcf50633/core.h b/include/linux/mfd/pcf50633/core.h
> index 0c21222..04990c4 100644
> --- a/include/linux/mfd/pcf50633/core.h
> +++ b/include/linux/mfd/pcf50633/core.h
> @@ -13,8 +13,8 @@
>  #ifndef __LINUX_MFD_PCF50633_CORE_H
>  #define __LINUX_MFD_PCF50633_CORE_H
>  
> +#include <linux/types.h>
>  #include <linux/i2c.h>
> -#include <linux/workqueue.h>
>  #include <linux/regulator/driver.h>
>  #include <linux/regulator/machine.h>
>  #include <linux/power_supply.h>
> @@ -141,15 +141,13 @@ struct pcf50633 {
>  	struct pcf50633_platform_data *pdata;
>  	int irq;
>  	struct pcf50633_irq irq_handler[PCF50633_NUM_IRQ];
> -	struct work_struct irq_work;
> -	struct workqueue_struct *work_queue;
>  	struct mutex lock;
>  
>  	u8 mask_regs[5];
>  
>  	u8 suspend_irq_masks[5];
>  	u8 resume_reason[5];
> -	int is_suspended;
> +	bool is_suspended;
>  
>  	int onkey1s_held;
>  
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
