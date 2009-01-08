Return-Path: <linux-kernel-owner+w=401wt.eu-S1762583AbZAHUeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762583AbZAHUeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbZAHUeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:34:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755140AbZAHUeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:34:20 -0500
Date: Thu, 8 Jan 2009 12:33:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Daney <ddaney@caviumnetworks.com>
cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] cpumask fallout: Initialize irq_default_affinity
 earlier.
In-Reply-To: <1231446081-8448-1-git-send-email-ddaney@caviumnetworks.com>
Message-ID: <alpine.LFD.2.00.0901081227360.3283@localhost.localdomain>
References: <1231446081-8448-1-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Jan 2009, David Daney wrote:
>  
> +#ifdef CONFIG_SMP
> +	init_irq_default_affinity();
> +#endif

Don't do this. It's horrible. It makes the code much harder to read.

What's so wrong with initializing affinity on UP? It's still conceptually 
a fine thing to do, although it's obviously trivially a no-op.

Also, since it's only used in "handle.c", why not just move it there? 
Then, just make it static, and make it a no-op for the non-SMP case. Ok?

In fact, I think it already is a no-op in the UP case, and you can 
literally just do

	static inline void __init init_irq_default_affinity(void)
	{
	 	alloc_cpumask_var(&irq_default_affinity, GFP_KERNEL);
	 	cpumask_setall(irq_default_affinity);
	}

and be done with it. I think it should all compile away to nothing if 
CONFIG_SMP isn't set.

			Linus
