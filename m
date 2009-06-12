Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbZFLTbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbZFLTbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 15:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbZFLTb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 15:31:27 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:48803 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438AbZFLTb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 15:31:26 -0400
Date: Fri, 12 Jun 2009 21:31:27 +0200
From: Marc Zyngier <maz@misterjones.org>
To: Vikram Pandita <vikram.pandita@ti.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Vikram Pandita <vikram.pandita@ti.com>
Subject: Re: [PATCH] serial: 8250: add IRQ trigger support
Message-ID: <20090612213127.0f03e0c5@taxman.wild-wind.fr.eu.org>
In-Reply-To: <1244827971-14981-1-git-send-email-vikram.pandita@ti.com>
References: <1244827971-14981-1-git-send-email-vikram.pandita@ti.com>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 83.161.227.188
X-SA-Exim-Rcpt-To: vikram.pandita@ti.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk, vikram.pandita@ti.com
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 12:32:51 -0500
Vikram Pandita <vikram.pandita@ti.com> wrote:

> There is currently no provision for passing IRQ trigger flags for
> serial IRQs with triggering requirements (such as GPIO IRQs.)
> 
> This patch adds UPF_IRQ_TRIG_* flags which map on to IRQF_TRIGGER_*
> flags.
> 
> Signed-off-by: Vikram Pandita <vikram.pandita@ti.com>
> Acked-by: Kevin Hilman <khilman@deeprootsystems.com>

Note that this patch doesn't allow  the interrupt to trigger on both
edges (not that I have ever seen a 8250 with this behavior, but this
is a valid configuration from an interrupt point of view).

Aside from this remark:
Acked-by: Marc Zyngier <maz@misterjones.org>

> ---
>  drivers/serial/8250.c       |   10 ++++++++++
>  include/linux/serial_core.h |    4 ++++
>  2 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index bab115e..8235ef5 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -1641,6 +1641,16 @@ static int serial_link_irq_chain(struct
> uart_8250_port *up) struct irq_info *i;
>  	int ret, irq_flags = up->port.flags & UPF_SHARE_IRQ ?
> IRQF_SHARED : 0; 
> +	/* Get IRQ Trigger Flag */
> +	if (up->port.flags & UPF_IRQ_TRIG_RISING)
> +		irq_flags |= IRQF_TRIGGER_RISING;
> +	else if (up->port.flags & UPF_IRQ_TRIG_FALLING)
> +		irq_flags |= IRQF_TRIGGER_FALLING;
> +	else if (up->port.flags & UPF_IRQ_TRIG_HIGH)
> +		irq_flags |= IRQF_TRIGGER_HIGH;
> +	else if (up->port.flags & UPF_IRQ_TRIG_LOW)
> +		irq_flags |= IRQF_TRIGGER_LOW;
> +
>  	mutex_lock(&hash_mutex);
>  
>  	h = &irq_lists[up->port.irq % NR_IRQ_HASH];
> diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
> index 57a97e5..07591d5 100644
> --- a/include/linux/serial_core.h
> +++ b/include/linux/serial_core.h
> @@ -296,7 +296,11 @@ struct uart_port {
>  #define UPF_SPD_WARP		((__force upf_t) (0x1010))
>  #define UPF_SKIP_TEST		((__force upf_t) (1 << 6))
>  #define UPF_AUTO_IRQ		((__force upf_t) (1 << 7))
> +#define UPF_IRQ_TRIG_RISING	((__force upf_t) (1 << 8))
> +#define UPF_IRQ_TRIG_FALLING	((__force upf_t) (1 << 9))
> +#define UPF_IRQ_TRIG_HIGH	((__force upf_t) (1 << 10))
>  #define UPF_HARDPPS_CD		((__force upf_t) (1 << 11))
> +#define UPF_IRQ_TRIG_LOW	((__force upf_t) (1 << 12))
>  #define UPF_LOW_LATENCY		((__force upf_t) (1 << 13))
>  #define UPF_BUGGY_UART		((__force upf_t) (1 << 14))
>  #define UPF_NO_TXEN_TEST	((__force upf_t) (1 << 15))

