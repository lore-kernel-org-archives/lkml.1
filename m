Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbZIAUnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbZIAUnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 16:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZIAUno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 16:43:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751581AbZIAUno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 16:43:44 -0400
Date: Tue, 1 Sep 2009 13:43:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, dg@emlix.com
Subject: Re: [patch 2.6.31-rc7] gpiolib: allow poll() on value
Message-Id: <20090901134311.95fba3c8.akpm@linux-foundation.org>
In-Reply-To: <200908271650.59287.david-b@pacbell.net>
References: <200908271650.59287.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 16:50:57 -0700
David Brownell <david-b@pacbell.net> wrote:

> From: Daniel Gl__ckner <dg@emlix.com>
> Subject: [PATCH v3] gpiolib: allow poll(2) on gpio value
> 
> Many gpio chips allow to generate interrupts when the value of a pin
> changes. This patch gives usermode application the opportunity to make
> use of this feature by calling poll(2) on the /sys/class/gpio/gpioN/value
> sysfs file. The edge to trigger can be set in the edge file in the same
> directory. Possible values are "none", "rising", "falling", and "both".
> 
> Using level triggers is not possible with current sysfs since nothing
> changes the GPIO value (and the IRQ keeps triggering).  Edge triggering
> will "just work".  Note that if there was an event between read() and
> poll(), the poll() returns immediately.
> 
> Also note that this version only supports true GPIO interrupts.  Some
> later patch might be able to synthesize this behavior by timer-driven
> polling; some systems seem to need that.
>
> ...
>
> +static struct idr pdesc_idr;

There's no locking to protect this tree.  If that isn't a bug then I'd
suggest that a comment be added here explaining why.

> +static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
> +{
> +	struct work_struct	*work = priv;
> +
> +	schedule_work(work);
> +	return IRQ_HANDLED;
> +}

The only place where we explicitly cancel the pending work is in
gpio_setup_irq().  Is that sufficient?  Is there any way in which the
work callback can occur after things have been
freed/closed/deinitialised/etc?


