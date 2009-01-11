Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbZAKH6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbZAKH6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 02:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbZAKH5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 02:57:54 -0500
Received: from 8bytes.org ([88.198.83.132]:38436 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbZAKH5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 02:57:53 -0500
Date: Sun, 11 Jan 2009 08:57:52 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joerg.roedel@amd.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com
Subject: Re: [PATCH 08/16] dma-debug: add core checking functions
Message-ID: <20090111075752.GI9466@8bytes.org>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-9-git-send-email-joerg.roedel@amd.com> <20090110231127.GK17917@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110231127.GK17917@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 12:11:27AM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > +#define err_printk(dev, format, arg...) do {			\
> > +		error_count += 1;				\
> > +		if (show_all_errors || show_num_errors > 0) {	\
> > +			WARN(1, "%s %s: " format,		\
> > +			     dev_driver_string(dev),		\
> > +			     dev_name(dev) , ## arg);		\
> > +		}						\
> > +		if (!show_all_errors && show_num_errors > 0)	\
> > +			show_num_errors -= 1;			\
> 
> Note that the arithmetics here is SMP-unsafe: we only hold the hash bucket 
> so if two errors hit at once on two CPUs then the error tracking variables 
> can be accessed at once.
> 
> I'd suggest a simple global lock for this error case (taken inside the 
> hash bucket lock), to be on the safe side.
> 
> Also, please dont use a macro for this - printk details can be passed in 
> to helper inlines/functions too.

Yeah, this is not SMP-safe, I know. But debugfs does not support
atomic_t so I made the variables u32. But at least a race condition has
not a too bad impact. What may habben is that error_count misses a error
or the show_num_errors become negative.
But if we really want to avoid this I think its better to add atomic_t
support to debugfs. What do you think?

Joerg
