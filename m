Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbYGDRRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbYGDRRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYGDRRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 13:17:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879AbYGDRRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 13:17:36 -0400
Date: Fri, 4 Jul 2008 10:17:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] handle failure of irqchip->set_type in setup_irq
Message-Id: <20080704101717.28f6a771.akpm@linux-foundation.org>
In-Reply-To: <20080704104634.GA31634@digi.com>
References: <20080625131101.GA6205@digi.com>
	<20080704104634.GA31634@digi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2008 12:46:34 +0200 Uwe Kleine-K__nig <Uwe.Kleine-Koenig@digi.com> wrote:

> set_type returns an int indicating success or failure, but up to now
> setup_irq ignores that.
> 
> In my case this resulted in a machine hang:
> gpio-keys requested IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING, but
> arm/ns9xxx can only trigger on one direction so set_type didn't touch
> the configuration which happens do default to a level sensitiveness and
> returned -EINVAL.  setup_irq ignored that and unmasked the irq.  This
> resulted in an endless triggering of the gpio-key interrupt service
> routine which effectively killed the machine.
> 
> With this patch applied setup_irq propagates the error to the caller.
> 
> Note that before in the case 
> 
> 	chip && !chip->set_type && !chip->name
> 
> a NULL pointer was feed to printk.  This is fixed, too.
> 

hm, OK.  Do I recall there being some urgency to this?

> +	if (ret) {
> +		char buf[100];
> +
> +		snprintf(buf, sizeof(buf), KERN_ERR
> +				"setting flow type for irq %u failed (%%s)\n",
> +				irq);
> +		print_fn_descriptor_symbol(buf, chip->set_type);
> +	}

eww.  We really mucked up that interface.  I wonder if we can do better.
Let me think about that.


