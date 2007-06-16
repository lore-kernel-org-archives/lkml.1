Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbXFPCFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbXFPCFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 22:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbXFPCFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 22:05:00 -0400
Received: from neon.samage.net ([85.17.153.66]:46725 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbXFPCE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 22:04:59 -0400
Message-ID: <33677.81.207.0.53.1181959473.squirrel@secure.samage.net>
In-Reply-To: <200706150141.06142.dtor@insightbb.com>
References: <20070604112426.GA2707@elf.ucw.cz>
    <20070613081825.GF13747@elf.ucw.cz>
    <41219.81.207.0.53.1181743761.squirrel@secure.samage.net>
    <200706150141.06142.dtor@insightbb.com>
Date: Sat, 16 Jun 2007 04:04:33 +0200 (CEST)
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
From: "Indan Zupancic" <indan@nul.nu>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Cc: "Pavel Machek" <pavel@ucw.cz>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Andi Kleen" <ak@suse.de>, "Jiri Kosina" <jikos@jikos.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: bc82d6a2e188773012c482ed32290af0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, June 15, 2007 07:41, Dmitry Torokhov wrote:
> Does the patch below help?

Didn't try it yet, but will tomorrow.


> Input: atkbd - throttle LED switching
>
> On some boxes keyboard controllers are too slow to withstand
> continuous flow of requests to turn keyboard LEDs on and off
> and start losing some keypresses or even all of them.
>
> Delay executing of LED switching request if we had another one
> withing 50 ms thus easing load on the controller.
>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
>
>  drivers/input/keyboard/atkbd.c |   40 ++++++++++++++++++++++++++--------------
>  1 files changed, 26 insertions(+), 14 deletions(-)
>
> Index: work/drivers/input/keyboard/atkbd.c
> ===================================================================
> --- work.orig/drivers/input/keyboard/atkbd.c
> +++ work/drivers/input/keyboard/atkbd.c
> @@ -219,7 +219,8 @@ struct atkbd {
>  	unsigned long time;
>  	unsigned long err_count;
>
> -	struct work_struct event_work;
> +	struct delayed_work event_work;
> +	unsigned long event_jiffies;
>  	struct mutex event_mutex;
>  	unsigned long event_mask;
>  };
> @@ -565,7 +566,7 @@ static int atkbd_set_leds(struct atkbd *
>
>  static void atkbd_event_work(struct work_struct *work)
>  {
> -	struct atkbd *atkbd = container_of(work, struct atkbd, event_work);
> +	struct atkbd *atkbd = container_of(work, struct atkbd, event_work.work);
>
>  	mutex_lock(&atkbd->event_mutex);
>
> @@ -579,12 +580,30 @@ static void atkbd_event_work(struct work
>  }
>
>  /*
> + * Schedule switch for execution. We need to throttle requests,
> + * otherwise keyboard may become unresponsive.
> + */
> +static void atkbd_schedule_event_work(struct atkbd *atkbd, int event_bit)
> +{
> +	unsigned long delay = msecs_to_jiffies(50);
> +
> +	if (time_after(jiffies, atkbd->event_jiffies + delay))
> +		delay = 0;
> +
> +	atkbd->event_jiffies = jiffies;
> +	set_bit(event_bit, &atkbd->event_mask);
> +	wmb();
> +	schedule_delayed_work(&atkbd->event_work, delay);
> +}

I don't know whether schedule_delayed_work() requeues event_work, or if
it adds more work, but both seem to give wrong behaviour: In the first case
event_work can be postponed forever if atkbd_schedule_event_work() is
called repeatedly each time within 50 ms, and for the second case there's a
delay added, but the number of times the LED is switched stays the same,
so it's not being throttled.

Greetings,

Indan


