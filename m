Return-Path: <linux-kernel-owner+w=401wt.eu-S1761869AbYETNy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761869AbYETNy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932152AbYETNy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:54:27 -0400
Received: from mail.atmel.fr ([81.80.104.162]:36664 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758437AbYETNyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:54:25 -0400
Message-ID: <4832D807.7000703@atmel.com>
Date: Tue, 20 May 2008 15:54:15 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net
CC: adaplas@gmail.com, hskinnemoen@atmel.com, linux@maxim.org.za,
       linux-kernel@vger.kernel.org
Subject: [PATCH] atmel_lcdfb: FIFO underflow management rework
References: <482D7F44.7040404@atmel.com> <20080519160006.12a30e71.akpm@linux-foundation.org>
In-Reply-To: <20080519160006.12a30e71.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manage atmel_lcdfb FIFO underflow rework

Resetting the LCD and DMA allows to fix screen shifting after 
a FIFO underflow. It follows reset sequence from errata
"LCD Screen Shifting After a Reset".

Reworked following Andrew Morton comments.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---

Andrew Morton :
> On Fri, 16 May 2008 14:34:12 +0200
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
>> Manage atmel_lcdfb FIFO underflow
>>
>> Resetting the LCD and DMA allows to fix screen shifting after a 
>> FIFO underflow. It follows reset sequence from errata 
>> "LCD Screen Shifting After a Reset".
>>
> 
> This looks like 2.6.26-worthy bugfix to me?  But as commonly happens,
> that isn't terribly clear.

This error may append in latency sensitive cases : slow clock, 
matrix slot cycle bad configuration, too high pixel clock...

>> +	if (status & ATMEL_LCDC_UFLWI) {
>> +		dev_warn(info->device, "FIFO underflow %#x\n", status);
>> +		/* reset DMA and FIFO to avoid screen shifting */
>> +		schedule_work(&sinfo->task);
>> +	}
>> +	lcdc_writel(sinfo, ATMEL_LCDC_ICR, status);
>>  	return IRQ_HANDLED;
>>  }
> 
> Shouldn't there be a cancel_work_sync() in atmel_lcdfb_exit()?

Ok incremental patch follows. Tell me if you prefer that I send 
a reworked one.

I also added  might_sleep() annotation functions.

>> +	/* Initialize bottom half workqueue */
> 
> Well.  "bottom half" is an ancient term for softirqs, not for the
> new-fangled process-context callbacks.

Ok, I try to adapt this comment in the reworked patch.


Index: drivers/video/atmel_lcdfb.c
===================================================================
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -361,6 +361,8 @@ static int atmel_lcdfb_check_var(struct 
  */
 static void atmel_lcdfb_reset(struct atmel_lcdfb_info *sinfo)
 {
+	might_sleep();
+
 	/* LCD power off */
 	lcdc_writel(sinfo, ATMEL_LCDC_PWRCON, sinfo->guard_time << ATMEL_LCDC_GUARDT_OFFSET);
 
@@ -405,6 +407,8 @@ static int atmel_lcdfb_set_par(struct fb
 	unsigned long clk_value_khz;
 	unsigned long bits_per_line;
 
+	might_sleep();
+
 	dev_dbg(info->device, "%s:\n", __func__);
 	dev_dbg(info->device, "  * resolution: %ux%u (%ux%u virtual)\n",
 		 info->var.xres, info->var.yres,
@@ -840,7 +844,8 @@ static int __init atmel_lcdfb_probe(stru
 		goto unmap_mmio;
 	}
 
-	/* Initialize bottom half workqueue */
+	/* Some operations on the LCDC might sleep and 
+	 * require a preemptible task context */
 	INIT_WORK(&sinfo->task, atmel_lcdfb_task);
 
 	ret = atmel_lcdfb_init_fbinfo(sinfo);
@@ -885,6 +890,7 @@ static int __init atmel_lcdfb_probe(stru
 free_cmap:
 	fb_dealloc_cmap(&info->cmap);
 unregister_irqs:
+	cancel_work_sync(&sinfo->task);
 	free_irq(sinfo->irq_base, info);
 unmap_mmio:
 	exit_backlight(sinfo);
@@ -922,6 +928,7 @@ static int __exit atmel_lcdfb_remove(str
 	if (!sinfo)
 		return 0;
 
+	cancel_work_sync(&sinfo->task);
 	exit_backlight(sinfo);
 	if (sinfo->atmel_lcdfb_power_control)
 		sinfo->atmel_lcdfb_power_control(0);



