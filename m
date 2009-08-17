Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbZHQLh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbZHQLh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757800AbZHQLh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:37:59 -0400
Received: from bu3sch.de ([62.75.166.246]:36676 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757777AbZHQLh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:37:58 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Threaded interrupt handlers broken?
Date: Mon, 17 Aug 2009 13:37:58 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200908161153.14081.mb@bu3sch.de> <alpine.LFD.2.00.0908171302430.2782@localhost.localdomain> <alpine.LFD.2.00.0908171311260.2782@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908171311260.2782@localhost.localdomain>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908171337.58713.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 August 2009 13:12:09 Thomas Gleixner wrote:
> On Mon, 17 Aug 2009, Thomas Gleixner wrote:
> > On Mon, 17 Aug 2009, Thomas Gleixner wrote:
> > 
> > > On Mon, 17 Aug 2009, Michael Buesch wrote:
> > > > Ok, I added some more debugging code:
> > > > http://bu3sch.de/patches/wireless-testing/20090817-1219/patches/001-hack-threaded-irqs.patch
> > > > 
> > > > Here's the result:
> > > > http://bu3sch.de/misc/dmesg2
> > > >
> > > > Is it possible that the irq_to_desc() in irq_thread() fails and the
> > > > resulting desc pointer points to something random? That could
> > > > probably explain why the bit is set and why the spinlock is
> > > > uninitialized. But it would not explain why desc->lock would still
> > > > work... Maybe irq_to_desc() returns a descriptor to another irq (!=
> > > > 52)?
> > > 
> > > That would cause the whole irq code to fail. Can you send/upload your
> > > .config please ?
> > 
> > Also just add printk("desc: %p \n", desc); to the various places to
> > make sure that your pointers are correct.
> 
> Gah. I think I found it.
> 
> I wonder why nobody else ever tripped over this.
> 
> Thanks,
> 
> 	tglx
> ---
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index d222515..223b062 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -607,7 +607,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  		 */
>  		get_task_struct(t);
>  		new->thread = t;
> -		wake_up_process(t);
>  	}
>  
>  	/*
> @@ -712,6 +711,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  	new->dir = NULL;
>  	register_handler_proc(irq, new);
>  
> +	if (new->thread)
> +		wake_up_process(new->thread);
> +
>  	return 0;
>  
>  mismatch:
> 
> 

This fixes it :)

Tested-by: Michael Buesch <mb@bu3sch.de>

-- 
Greetings, Michael.
