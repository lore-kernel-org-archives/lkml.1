Return-Path: <linux-kernel-owner+w=401wt.eu-S1759832AbXLLL3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832AbXLLL3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbXLLL3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:29:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46189 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758199AbXLLL3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:29:42 -0500
Date: Wed, 12 Dec 2007 03:29:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 44/47] Minor fixes for CRISv32 io.h
Message-Id: <20071212032939.380d15dc.akpm@linux-foundation.org>
In-Reply-To: <cdda065141073e183216982b6faf7e1aee17b215.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
	<cdda065141073e183216982b6faf7e1aee17b215.1196848533.git.jesper.nilsson@axis.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007 11:16:25 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> - Shorten include paths for machine dependent header files.
> - Add volatile to hardeware register pointers.
> - Add spinlocks around critical region.
> - Expand macros for handling of leds.
> 
> ...
>
>  struct crisv32_ioport
>  {
> -  unsigned long* oe;
> -  unsigned long* data;
> -  unsigned long* data_in;
> +  volatile unsigned long *oe;
> +  volatile unsigned long *data;
> +  volatile unsigned long *data_in;
>    unsigned int pin_count;
> +  spinlock_t lock;
>  };

tabs.

>  struct crisv32_iopin
> @@ -34,22 +36,37 @@ extern struct crisv32_iopin crisv32_led2_red;
>  extern struct crisv32_iopin crisv32_led3_green;
>  extern struct crisv32_iopin crisv32_led3_red;
>  
> +extern struct crisv32_iopin crisv32_led_net0_green;
> +extern struct crisv32_iopin crisv32_led_net0_red;
> +extern struct crisv32_iopin crisv32_led_net1_green;
> +extern struct crisv32_iopin crisv32_led_net1_red;
> +
>  static inline void crisv32_io_set(struct crisv32_iopin* iopin,
>  			   int val)
>  {
> +	long flags;
> +	spin_lock_irqsave(&iopin->port->lock, flags);
> +
>  	if (val)
>  		*iopin->port->data |= iopin->bit;
>  	else
>  		*iopin->port->data &= ~iopin->bit;
> +
> +	spin_unlock_irqrestore(&iopin->port->lock, flags);
>  }
>  
>  static inline void crisv32_io_set_dir(struct crisv32_iopin* iopin,
>  			       enum crisv32_io_dir dir)
>  {
> +	long flags;
> +	spin_lock_irqsave(&iopin->port->lock, flags);
> +
>  	if (dir == crisv32_io_dir_in)
>  		*iopin->port->oe &= ~iopin->bit;
>  	else
>  		*iopin->port->oe |= iopin->bit;
> +
> +	spin_unlock_irqrestore(&iopin->port->lock, flags);
>  }

These surely are far too large to be inlined.

> +#define LED_NETWORK_GRP0_SET(x)                          \
> +	do {                                             \
> +		LED_NETWORK_GRP0_SET_G((x) & LED_GREEN); \
> +		LED_NETWORK_GRP0_SET_R((x) & LED_RED);   \
>  	} while (0)
> +#else
> +#define LED_NETWORK_GRP0_SET(x) while (0) {}
> +#endif
> +
> +#define LED_NETWORK_GRP0_SET_G(x) \
> +	crisv32_io_set(&crisv32_led_net0_green, !(x));
> +
> +#define LED_NETWORK_GRP0_SET_R(x) \
> +	crisv32_io_set(&crisv32_led_net0_red, !(x));
> +
> +#if defined(CONFIG_ETRAX_NBR_LED_GRP_TWO)
> +#define LED_NETWORK_GRP1_SET(x)                          \
> +	do {                                             \
> +		LED_NETWORK_GRP1_SET_G((x) & LED_GREEN); \
> +		LED_NETWORK_GRP1_SET_R((x) & LED_RED);   \
> +	} while (0)
> +#else
> +#define LED_NETWORK_GRP1_SET(x) while (0) {}
> +#endif
> +
> +#define LED_NETWORK_GRP1_SET_G(x) \
> +	crisv32_io_set(&crisv32_led_net1_green, !(x));
> +
> +#define LED_NETWORK_GRP1_SET_R(x) \
> +	crisv32_io_set(&crisv32_led_net1_red, !(x));
> +
>  #define LED_ACTIVE_SET(x)                           \
>  	do {                                        \
>  		LED_ACTIVE_SET_G((x) & LED_GREEN);  \
>  		LED_ACTIVE_SET_R((x) & LED_RED);    \
>  	} while (0)
>  

PLease generally prefer (lower-case) inlined functions over macros.  They
are cleaner, clearer, safer and have better typechecking.

Several of the above macros reference their argument more than once and
hence cannot be used as, for example,

	LED_ACTIVE_SET(foo++);


