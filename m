Return-Path: <linux-kernel-owner+w=401wt.eu-S1763267AbZFIKj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763267AbZFIKj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761189AbZFIKZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:25:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761132AbZFIKZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:25:03 -0400
Date: Tue, 9 Jun 2009 12:25:04 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: Re: [PATCH] [6/16] HWPOISON: Add various poison checks in mm/memory.c
Message-ID: <20090609102504.GH14820@wotan.suse.de>
References: <20090603846.816684333@firstfloor.org> <20090603184639.1933B1D028F@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603184639.1933B1D028F@basil.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 08:46:38PM +0200, Andi Kleen wrote:
> 
> Bail out early when hardware poisoned pages are found in page fault handling.
> Since they are poisoned they should not be mapped freshly into processes,
> because that would cause another (potentially deadly) machine check
> 
> This is generally handled in the same way as OOM, just a different
> error code is returned to the architecture code.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  mm/memory.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux/mm/memory.c
> ===================================================================
> --- linux.orig/mm/memory.c	2009-06-03 19:36:23.000000000 +0200
> +++ linux/mm/memory.c	2009-06-03 19:36:23.000000000 +0200
> @@ -2797,6 +2797,9 @@
>  	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
>  		return ret;
>  
> +	if (unlikely(PageHWPoison(vmf.page)))
> +		return VM_FAULT_HWPOISON;

Again, it would be nice if you just worry about this in your MCE
handler and don't sprinkle things like this in fastpaths.

> +
>  	/*
>  	 * For consistency in subsequent calls, make the faulted page always
>  	 * locked.
