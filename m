Return-Path: <linux-kernel-owner+w=401wt.eu-S965051AbXDIU5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051AbXDIU5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965528AbXDIU5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:57:33 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60052 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965051AbXDIU5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:57:32 -0400
Date: Mon, 9 Apr 2007 13:57:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch] Pad irq_desc to internode cacheline size
Message-Id: <20070409135729.a466e9cb.akpm@linux-foundation.org>
In-Reply-To: <20070409195356.GA5275@localhost.localdomain>
References: <20070409195356.GA5275@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007 12:56:27 -0700
Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> We noticed a drop in n/w performance due to the irq_desc being cacheline
> aligned rather than internode aligned.  We see 50% of expected performance
> when two e1000 nics local to two different nodes have consecutive irq
> descriptors allocated, due to false sharing.
> 
> Note that this patch does away with cacheline padding for the UP case, as it
> does not seem useful for UP configurations.
> 
> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
> Signed-off-by: Shai Fultheim <shai@scalex86.org>
> 
> Index: linux-2.6.21-rc5/include/linux/irq.h
> ===================================================================
> --- linux-2.6.21-rc5.orig/include/linux/irq.h	2007-04-09 10:16:23.560848473 -0700
> +++ linux-2.6.21-rc5/include/linux/irq.h	2007-04-09 10:16:45.401177929 -0700
> @@ -175,7 +175,7 @@ struct irq_desc {
>  	struct proc_dir_entry	*dir;
>  #endif
>  	const char		*name;
> -} ____cacheline_aligned;
> +} ____cacheline_internodealigned_in_smp;
>  
>  extern struct irq_desc irq_desc[NR_IRQS];

This will consume nearly 4k per irq won't it?  What is the upper bound
here, across all configs and all hardware?

Is VSMP the only arch which has ____cacheline_internodealigned_in_smp
larger than ____cacheline_aligned_in_smp?

