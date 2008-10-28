Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbYJ1X36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbYJ1X36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYJ1X3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:29:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:57445 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbYJ1X3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:29:48 -0400
Date: Wed, 29 Oct 2008 00:29:44 +0100
From: Nick Piggin <npiggin@suse.de>
To: Glauber Costa <glommer@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
       aliguori@codemonkey.ws, Jeremy Fitzhardinge <jeremy@goop.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] regression: vmalloc easily fail.
Message-ID: <20081028232944.GA3759@wotan.suse.de>
References: <1225234513-3996-1-git-send-email-glommer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225234513-3996-1-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 08:55:13PM -0200, Glauber Costa wrote:
> Commit db64fe02258f1507e13fe5212a989922323685ce broke
> KVM (the symptom) for me. The cause is that vmalloc
> allocations fail, despite of the fact that /proc/meminfo
> shows plenty of vmalloc space available.
> 
> After some investigation, it seems to me that the current
> way to compute the next addr in the rb-tree transversal
> leaves a spare page between each allocation. After a few
> allocations, regardless of their size, we run out of vmalloc
> space.

Right... that was to add a guard page like the old vmalloc allocator.
vmallocs still add their extra page too, so most of them will have
a 2 page guard area, but I didn't think this would hurt significantly.

I'm not against the patch, but I wonder exactly what is filling it up
and how? (can you look at the vmalloc proc function to find out?)

> 
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
> ---
>  mm/vmalloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 0365369..a33b0d1 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -363,7 +363,7 @@ retry:
>  		}
>  
>  		while (addr + size >= first->va_start && addr + size <= vend) {
> -			addr = ALIGN(first->va_end + PAGE_SIZE, align);
> +			addr = ALIGN(first->va_end, align);
>  
>  			n = rb_next(&first->rb_node);
>  			if (n)
> -- 
> 1.5.6.5
