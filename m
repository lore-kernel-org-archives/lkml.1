Return-Path: <linux-kernel-owner+w=401wt.eu-S932504AbXHVUJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbXHVUJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759055AbXHVUJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:09:13 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:62552 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756434AbXHVUJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:09:13 -0400
Date: Wed, 22 Aug 2007 16:09:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070822200910.GA25687@Krystal>
References: <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com> <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com> <20070822000323.GG29691@Krystal> <p73fy2cz7bs.fsf@bingen.suse.de> <20070822003834.GB1400@Krystal> <Pine.LNX.4.64.0708211757360.3118@schroedinger.engr.sgi.com> <20070822134532.GA3769@Krystal> <Pine.LNX.4.64.0708221224550.14795@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708221224550.14795@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:04:45 up 23 days, 20:23,  3 users,  load average: 0.20, 0.25, 0.36
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
>  void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
> @@ -1577,7 +1590,10 @@ static void __slab_free(struct kmem_cach
>  {
>  	void *prior;
>  	void **object = (void *)x;
> +	unsigned long flags;
>  
> +	local_irq_save(flags);
> +	put_cpu_no_resched();

Those two lines may skip a preempt_check.

Could we change them to this instead ?
  
  put_cpu();
  local_irq_save(flags);

Otherwise, it would be good to call

  preempt_check_resched();

  After each local_irq_restore() in this function.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
