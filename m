Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab0BFHUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 02:20:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:56504 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab0BFHUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 02:20:40 -0500
Message-ID: <4B6D173C.4070200@kernel.org>
Date: Fri, 05 Feb 2010 23:16:12 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Brandon Philips <bphilips@suse.de>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86: keep chip_data in create_irq_nr and destroy_irq
References: <20100203033109.GA17985@jenkins.home.ifup.org> <4B694DEF.70301@kernel.org> <20100203174216.GB17985@jenkins.home.ifup.org> <4B6BDAC0.3090900@kernel.org> <20100205210926.GE4930@jenkins.home.ifup.org> <4B6C9F69.4040605@kernel.org> <20100205225535.GF4930@jenkins.home.ifup.org> <4B6CB26C.405@kernel.org> <20100206001832.GG4930@jenkins.home.ifup.org> <20100206064247.GB15556@jenkins.home.ifup.org>
In-Reply-To: <20100206064247.GB15556@jenkins.home.ifup.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2010 10:42 PM, Brandon Philips wrote:
> Version 3: Forgot to refresh patch so destroy_irq() had uninitialized
> cfg as param to __clear_irq_vector(). Fixed now.
  
> @@ -3255,19 +3252,15 @@ int create_irq(void)
>  void destroy_irq(unsigned int irq)
>  {
>  	unsigned long flags;
> -	struct irq_cfg *cfg;
>  	struct irq_desc *desc;
>  
>  	/* store it, in case dynamic_irq_cleanup clear it */
>  	desc = irq_to_desc(irq);
> -	cfg = desc->chip_data;
> -	dynamic_irq_cleanup(irq);
> -	/* connect back irq_cfg */
> -	desc->chip_data = cfg;
> +	dynamic_irq_cleanup_keep_chip_data(irq);
>  
>  	free_irte(irq);
>  	spin_lock_irqsave(&vector_lock, flags);
> -	__clear_irq_vector(irq, cfg);
> +	__clear_irq_vector(irq, desc->chip_data);
>  	spin_unlock_irqrestore(&vector_lock, flags);
>  }

==>
@@ -3308,17 +3305,12 @@ void destroy_irq(unsigned int irq)
 {
 	unsigned long flags;
 	struct irq_cfg *cfg;
-	struct irq_desc *desc;
 
-	/* store it, in case dynamic_irq_cleanup clear it */
-	desc = irq_to_desc(irq);
-	cfg = desc->chip_data;
-	dynamic_irq_cleanup(irq);
-	/* connect back irq_cfg */
-	desc->chip_data = cfg;
+	dynamic_irq_cleanup_keep_chip_data(irq);
 
 	free_irte(irq);
 	spin_lock_irqsave(&vector_lock, flags);
+	cfg = irq_to_desc(irq)->chip_data;
 	__clear_irq_vector(irq, cfg);
 	spin_unlock_irqrestore(&vector_lock, flags);
 }


Yinghai
