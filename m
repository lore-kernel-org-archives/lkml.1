Return-Path: <linux-kernel-owner+w=401wt.eu-S1759293AbZBBV52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbZBBV52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbZBBV5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:57:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753569AbZBBV5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:57:18 -0500
Date: Mon, 2 Feb 2009 13:56:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@openedhand.com, linux-kernel@vger.kernel.org,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] mfd: Support active high IRQs on WM835x
Message-Id: <20090202135650.838a3ddd.akpm@linux-foundation.org>
In-Reply-To: <1232997799-18943-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1232997799-18943-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 19:23:18 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8350-core.c       |   16 +++++++++++++++-
>  include/linux/mfd/wm8350/core.h |    2 ++
>  2 files changed, 17 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
> index e5e82c7..908284c 100644
> --- a/drivers/mfd/wm8350-core.c
> +++ b/drivers/mfd/wm8350-core.c
> @@ -1423,7 +1423,21 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
>  	mutex_init(&wm8350->irq_mutex);
>  	INIT_WORK(&wm8350->irq_work, wm8350_irq_worker);
>  	if (irq) {
> -		ret = request_irq(irq, wm8350_irq, 0,
> +		int flags = 0;
> +
> +		if (pdata && pdata->irq_high) {
> +			flags |= IRQF_TRIGGER_HIGH;
> +
> +			wm8350_set_bits(wm8350, WM8350_SYSTEM_CONTROL_1,
> +					WM8350_IRQ_POL);
> +		} else {
> +			flags |= IRQF_TRIGGER_LOW;
> +
> +			wm8350_clear_bits(wm8350, WM8350_SYSTEM_CONTROL_1,
> +					  WM8350_IRQ_POL);
> +		}
> +
> +		ret = request_irq(irq, wm8350_irq, flags,
>  				  "wm8350", wm8350);
>  		if (ret != 0) {
>  			dev_err(wm8350->dev, "Failed to request IRQ: %d\n",

This conflicts a bit with your earlier
mfd-initialise-wm8350-interrupts-earlier.patch.

I had marked mfd-initialise-wm8350-interrupts-earlier.patch as
needed-in-2.6.29 so I reworked this patch to fit.

afacit we haven't heard from Sam in a couple of weeks.  If he's having
a bit of downtime I guess I'll merge

mfd-initialise-wm8350-interrupts-earlier.patch
mfd-mark-wm835x-usb_slv_500ma-bit-as-accessible.patch
mfd-pcf50633-terminate-i2c_device_id-list.patch

myself.  But I'll leave that a week or two yet.
