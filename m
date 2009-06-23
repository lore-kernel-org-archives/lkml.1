Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbZFWOqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbZFWOqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbZFWOqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:46:07 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54713 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZFWOqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:46:07 -0400
Date: Tue, 23 Jun 2009 08:46:08 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] dmapools: protect page_list walk in show_pools()
Message-ID: <20090623144608.GE19977@parisc-linux.org>
References: <alpine.LFD.2.00.0906231634210.2767@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906231634210.2767@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 04:41:14PM +0200, Thomas Gleixner wrote:
> show_pools() walks the page_list of a pool w/o protection against the
> list modifications in alloc/free. Take pool->lock to avoid stomping
> into nirvana.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Looks right to me.  We're already holding pools_lock here, but pools_lock
doesn't protect against the page_list.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

I don't have a tree for dmapool work ... might as well go in through
Andrew, I suppose?

> ---
> diff --git a/mm/dmapool.c b/mm/dmapool.c
> index b1f0885..3df0637 100644
> --- a/mm/dmapool.c
> +++ b/mm/dmapool.c
> @@ -86,10 +86,12 @@ show_pools(struct device *dev, struct device_attribute *attr, char *buf)
>  		unsigned pages = 0;
>  		unsigned blocks = 0;
>  
> +		spin_lock_irq(&pool->lock);
>  		list_for_each_entry(page, &pool->page_list, page_list) {
>  			pages++;
>  			blocks += page->in_use;
>  		}
> +		spin_unlock_irq(&pool->lock);
>  
>  		/* per-pool info, no real statistics yet */
>  		temp = scnprintf(next, size, "%-16s %4u %4Zu %4Zu %2u\n",
> 
> 

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
