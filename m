Return-Path: <linux-kernel-owner+w=401wt.eu-S1762678AbXHFDe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762678AbXHFDe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 23:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759059AbXHFDeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 23:34:22 -0400
Received: from waste.org ([66.93.16.53]:59006 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758948AbXHFDeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 23:34:21 -0400
Date: Sun, 5 Aug 2007 22:34:46 -0500
From: Matt Mackall <mpm@selenic.com>
To: Dave Boutcher <boutcher@cs.umn.edu>
Cc: linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix /proc/pid/pagemap return length calculation
Message-ID: <20070806033446.GU11115@waste.org>
References: <18102.33131.876436.899189@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18102.33131.876436.899189@gargle.gargle.HOWL>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 09:03:23PM -0500, Dave Boutcher wrote:
> 
> /proc/pid/pagemap has a header (usually 8 bytes) the length
> of which needs to be compensated for when converting from
> proc file offset to page number.  The calculation of the
> starting page number (svpfn) compensates for this, but the
> calculation of the ending page number (evpfn) does not, resulting
> in reads returning 8 bytes more than were asked for and
> nastily overwriting userspace memory.

Does this mean you're running on a 64-bit arch? I'd already fixed this
locally, but it was off by 4 for me.

Acked-by: Matt Mackall <mpm@selenic.com>
 
> Diffed against 2.6.23-rc1-mm2
> 
> Signed-off-by: Dave Boutcher <boutcher@cs.umn.edu>
> ---
>  fs/proc/task_mmu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 4594f15..b2baeab 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -627,7 +627,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
>  	addr = PAGE_SIZE * svpfn;
>  	if ((svpfn + 1) * sizeof(unsigned long) != src)
>  		goto out;
> -	evpfn = min((src + count) / sizeof(unsigned long),
> +	evpfn = min((src + count) / sizeof(unsigned long) - 1,
>  		    ((~0UL) >> PAGE_SHIFT) + 1);
>  	count = (evpfn - svpfn) * sizeof(unsigned long);
>  	end = PAGE_SIZE * evpfn;
> -- 
> 1.4.4.2

-- 
Mathematics is the supreme nostalgia of our time.
