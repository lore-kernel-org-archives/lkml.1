Return-Path: <linux-kernel-owner+w=401wt.eu-S1752416AbZILOAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbZILOAX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 10:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZILOAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 10:00:23 -0400
Received: from mx.treblig.org ([80.68.94.177]:54055 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbZILOAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 10:00:22 -0400
Date: Sat, 12 Sep 2009 16:00:20 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
Message-ID: <20090912150020.GA24172@gallifrey>
References: <20090613230842.GA18347@gallifrey> <alpine.LNX.2.00.0906231038500.7457@wotan.suse.de> <20090623185814.GB24108@gallifrey> <200906231106.37460.dmitry.torokhov@gmail.com> <20090628140452.GA15816@gallifrey> <20090904055139.4BEAB526EA5@mailhub.coreip.homeip.net> <20090905235159.GA23660@gallifrey> <20090908064542.CDF50526EC9@mailhub.coreip.homeip.net> <20090909022718.A177E526EC9@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909022718.A177E526EC9@mailhub.coreip.homeip.net>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.29.2-bytemark-kvm-tickless-2009-05-05 (i686)
X-Uptime: 15:59:47 up 109 days,  8:21,  2 users,  load average: 0.00, 0.00, 0.00
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dmitry Torokhov (dmitry.torokhov@gmail.com) wrote:

<snip>

> Bah, that one was completely screwed up, please try this one instead.

Yep - that works nicely.  Thanks.

Dave

> 
> Thanks!
> 
> -- 
> Dmitry
> 
> Input: i8042 - try disabling and re-enabling AUX port at close
> 
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> Ever since we switched from having a polling timer to registering IRQ
> handlers for both keyboard and AUX ports at the driver registration
> time, on certain boxes probing for a mouse results in keyboard
> stopping working. The only real difference between old and new way is
> that before we disabled ports after unsuccessful probe whereas now we
> leave them as is. Try to emulate the old behavior by disabling and
> immediately re-enabling AUX and KBD ports when corresponding serio
> port is being closed.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
>  drivers/input/serio/i8042.c |   50 ++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 49 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
> index b53a015..8aaf8fc 100644
> --- a/drivers/input/serio/i8042.c
> +++ b/drivers/input/serio/i8042.c
> @@ -264,6 +264,49 @@ static int i8042_aux_write(struct serio *serio, unsigned char c)
>  					I8042_CMD_MUX_SEND + port->mux);
>  }
>  
> +
> +/*
> + * i8042_aux_close attempts to clear AUX or KBD port state by disabling
> + * and then re-enabling it.
> + */
> +
> +static void i8042_port_close(struct serio *serio)
> +{
> +	int irq_bit;
> +	int disable_bit;
> +	const char *port_name;
> +
> +	if (serio == i8042_ports[I8042_AUX_PORT_NO].serio) {
> +		irq_bit = I8042_CTR_AUXINT;
> +		disable_bit = I8042_CTR_AUXDIS;
> +		port_name = "AUX";
> +	} else {
> +		irq_bit = I8042_CTR_KBDINT;
> +		disable_bit = I8042_CTR_KBDDIS;
> +		port_name = "KBD";
> +	}
> +
> +	i8042_ctr &= ~irq_bit;
> +	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR))
> +		printk(KERN_WARNING
> +			"i8042.c: Can't write CTR while closing %s port.\n",
> +			port_name);
> +
> +	udelay(50);
> +
> +	i8042_ctr &= ~disable_bit;
> +	i8042_ctr |= irq_bit;
> +	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR))
> +		printk(KERN_ERR "i8042.c: Can't reactivate %s port.\n",
> +			port_name);
> +
> +	/*
> +	 * See if there is any data appeared while we were messing with
> +	 * port state.
> +	 */
> +	i8042_interrupt(0, NULL);
> +}
> +
>  /*
>   * i8042_start() is called by serio core when port is about to finish
>   * registering. It will mark port as existing so i8042_interrupt can
> @@ -393,7 +436,7 @@ static irqreturn_t i8042_interrupt(int irq, void *dev_id)
>  }
>  
>  /*
> - * i8042_enable_kbd_port enables keybaord port on chip
> + * i8042_enable_kbd_port enables keyboard port on chip
>   */
>  
>  static int i8042_enable_kbd_port(void)
> @@ -841,6 +884,9 @@ static void i8042_controller_reset(void)
>  	i8042_ctr |= I8042_CTR_KBDDIS | I8042_CTR_AUXDIS;
>  	i8042_ctr &= ~(I8042_CTR_KBDINT | I8042_CTR_AUXINT);
>  
> +	if (i8042_command(&i8042_initial_ctr, I8042_CMD_CTL_WCTR))
> +		printk(KERN_WARNING "i8042.c: Can't write CTR while resetting.\n");
> +
>  /*
>   * Disable MUX mode if present.
>   */
> @@ -1026,6 +1072,7 @@ static int __devinit i8042_create_kbd_port(void)
>  	serio->write		= i8042_dumbkbd ? NULL : i8042_kbd_write;
>  	serio->start		= i8042_start;
>  	serio->stop		= i8042_stop;
> +	serio->close		= i8042_port_close;
>  	serio->port_data	= port;
>  	serio->dev.parent	= &i8042_platform_device->dev;
>  	strlcpy(serio->name, "i8042 KBD port", sizeof(serio->name));
> @@ -1056,6 +1103,7 @@ static int __devinit i8042_create_aux_port(int idx)
>  	if (idx < 0) {
>  		strlcpy(serio->name, "i8042 AUX port", sizeof(serio->name));
>  		strlcpy(serio->phys, I8042_AUX_PHYS_DESC, sizeof(serio->phys));
> +		serio->close = i8042_port_close;
>  	} else {
>  		snprintf(serio->name, sizeof(serio->name), "i8042 AUX%d port", idx);
>  		snprintf(serio->phys, sizeof(serio->phys), I8042_MUX_PHYS_DESC, idx + 1);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
