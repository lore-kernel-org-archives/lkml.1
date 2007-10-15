Return-Path: <linux-kernel-owner+w=401wt.eu-S1762689AbXJOXiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762689AbXJOXiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbXJOXim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:38:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39021 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbXJOXil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:38:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=PYWrltOoKirGp7BHWlJdoYLo51VoSaXrg199ToT48IHoVYro5+5B4RMBZtHXr+t9s
	14RmcdHuH113tfaJSXJjA==
Date: Mon, 15 Oct 2007 16:36:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 1/11] maps3: add proportional set size accounting in
 smaps
In-Reply-To: <2.290135367@selenic.com>
Message-ID: <alpine.DEB.0.9999.0710151633150.16611@chino.kir.corp.google.com>
References: <2.290135367@selenic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Matt Mackall wrote:

> Index: l/fs/proc/task_mmu.c
> ===================================================================
> --- l.orig/fs/proc/task_mmu.c	2007-10-14 13:35:31.000000000 -0500
> +++ l/fs/proc/task_mmu.c	2007-10-14 13:36:56.000000000 -0500
> @@ -122,6 +122,27 @@ struct mem_size_stats
>  	unsigned long private_clean;
>  	unsigned long private_dirty;
>  	unsigned long referenced;
> +
> +	/*
> +	 * Proportional Set Size(PSS): my share of RSS.
> +	 *
> +	 * PSS of a process is the count of pages it has in memory, where each
> +	 * page is divided by the number of processes sharing it.  So if a
> +	 * process has 1000 pages all to itself, and 1000 shared with one other
> +	 * process, its PSS will be 1500.               - Matt Mackall, lwn.net
> +	 */
> +	u64 	      pss;
> +	/*
> +	 * To keep (accumulated) division errors low, we adopt 64bit pss and
> +	 * use some low bits for division errors. So (pss >> PSS_DIV_BITS)
> +	 * would be the real byte count.
> +	 *
> +	 * A shift of 12 before division means(assuming 4K page size):
> +	 * 	- 1M 3-user-pages add up to 8KB errors;
> +	 * 	- supports mapcount up to 2^24, or 16M;
> +	 * 	- supports PSS up to 2^52 bytes, or 4PB.
> +	 */
> +#define PSS_DIV_BITS	12
>  };
>  

I know this gets moved again in the eighth patch of the series, but the 
#define still has no place inside the struct definition.

The pss is going to need accessor functions, preferably inlined, and the 
comment adjusted stating that all accesses should be through those 
functions and not directly to the mem_size_stats struct.

	static inline u64 pss_up(unsigned long pss)
	{
		return pss << PSS_DIV_BITS;
	}

	static inline unsigned long pss_down(u64 pss)
	{
		return pss >> PSS_DIV_BITS;
	}
