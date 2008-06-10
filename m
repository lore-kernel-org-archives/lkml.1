Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbYFJRfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbYFJRfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYFJRfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:35:12 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:24490 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753115AbYFJRfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:35:10 -0400
Date: Wed, 11 Jun 2008 02:32:53 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, "Hans J. Koch" <hjk@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080610173253.GA21204@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	"Hans J. Koch" <hjk@linutronix.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>
References: <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com> <20080605112744.GB3198@local> <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com> <20080608205455.GA3191@local> <aec7e5c30806081812m532882e0p7ad3ef9a74f53337@mail.gmail.com> <20080609084411.GA3223@local> <20080609090123.GA12080@linux-sh.org> <20080609123406.GB27803@digi.com> <aec7e5c30806092140s21cc8cbdtbaf69f864dd2bda7@mail.gmail.com> <20080610071032.GB22814@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610071032.GB22814@digi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 09:10:32AM +0200, Uwe Kleine-K?nig wrote:
> Signed-off-by: Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>
> ---
>  include/linux/uio_driver.h |   33 +++++++++++++++++++++++++++++++++
>  1 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
> index cdf338d..671a7a8 100644
> --- a/include/linux/uio_driver.h
> +++ b/include/linux/uio_driver.h
> @@ -63,6 +63,7 @@ struct uio_info {
>  	long			irq;
>  	unsigned long		irq_flags;
>  	void			*priv;
> +	unsigned int		flags;
>  	irqreturn_t (*handler)(int irq, struct uio_info *dev_info);
>  	int (*mmap)(struct uio_info *info, struct vm_area_struct *vma);
>  	int (*open)(struct uio_info *info, struct inode *inode);

This should be unsigned long.

> @@ -92,4 +93,36 @@ extern void uio_event_notify(struct uio_info *info);
>  #define UIO_MEM_LOGICAL	2
>  #define UIO_MEM_VIRTUAL 3
>  
> +/* defines for uio_info->flags */
> +#define UIO_FLAGS_IRQDISABLED 0
> +
> +static inline irqreturn_t uio_userirq_handler(int irq,
> +		struct uio_info *dev_info)
> +{
> +	int ret;
> +
> +	if (likely(dev_info->irqcontrol)) {
> +		ret = dev_info->irqcontrol(dev_info, 0);
> +		if (ret) {
> +			pr_warning("%s: failed to disable irq\n", __func__);
> +			return IRQ_NONE;
> +		} else
> +			return IRQ_HANDLED;
> +	} else
> +		return IRQ_NONE;
> +}
> +
You can simplify this by just using IRQ_RETVAL() on
dev_info->irqcontrol(...). The printk() shouldn't be necessary, as the
other layers should already catch that.
