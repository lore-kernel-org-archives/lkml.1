Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab0BFUFY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 15:05:24 -0500
Received: from cantor.suse.de ([195.135.220.2]:40809 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab0BFUFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 15:05:23 -0500
Date: Sat, 6 Feb 2010 12:05:06 -0800
From: Brandon Philips <bphilips@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86: keep chip_data in create_irq_nr and destroy_irq
Message-ID: <20100206200506.GA8256@jenkins.home.ifup.org>
References: <4B694DEF.70301@kernel.org>
 <20100203174216.GB17985@jenkins.home.ifup.org>
 <4B6BDAC0.3090900@kernel.org>
 <20100205210926.GE4930@jenkins.home.ifup.org>
 <4B6C9F69.4040605@kernel.org>
 <20100205225535.GF4930@jenkins.home.ifup.org>
 <4B6CB26C.405@kernel.org>
 <20100206001832.GG4930@jenkins.home.ifup.org>
 <20100206064247.GB15556@jenkins.home.ifup.org>
 <4B6D173C.4070200@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6D173C.4070200@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23:16 Fri 05 Feb 2010, Yinghai Lu wrote:
> On 02/05/2010 10:42 PM, Brandon Philips wrote:
> @@ -3308,17 +3305,12 @@ void destroy_irq(unsigned int irq)
>  {
>  	unsigned long flags;
>  	struct irq_cfg *cfg;
> -	struct irq_desc *desc;
>  
> -	/* store it, in case dynamic_irq_cleanup clear it */
> -	desc = irq_to_desc(irq);
> -	cfg = desc->chip_data;
> -	dynamic_irq_cleanup(irq);
> -	/* connect back irq_cfg */
> -	desc->chip_data = cfg;
> +	dynamic_irq_cleanup_keep_chip_data(irq);
>  
>  	free_irte(irq);
>  	spin_lock_irqsave(&vector_lock, flags);
> +	cfg = irq_to_desc(irq)->chip_data;
>  	__clear_irq_vector(irq, cfg);

Or even two lines better!

 void destroy_irq(unsigned int irq)
 {
        unsigned long flags;
-       struct irq_cfg *cfg;
-       struct irq_desc *desc;
 
-       /* store it, in case dynamic_irq_cleanup clear it */
-       desc = irq_to_desc(irq);
-       cfg = desc->chip_data;
-       dynamic_irq_cleanup(irq);
-       /* connect back irq_cfg */
-       desc->chip_data = cfg;
+       dynamic_irq_cleanup_keep_chip_data(irq);
 
        free_irte(irq);
        spin_lock_irqsave(&vector_lock, flags);
-       __clear_irq_vector(irq, cfg);
+       __clear_irq_vector(irq, get_irq_chip_data(irq));
        spin_unlock_irqrestore(&vector_lock, flags);
 }
 

Sigh... I guess I will send the patch again :D

Cheers, 

	Brandon
