Return-Path: <linux-kernel-owner+w=401wt.eu-S1765845AbXJROvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765845AbXJROvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbXJROvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:51:47 -0400
Received: from lixom.net ([66.141.50.11]:58862 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757433AbXJROvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:51:47 -0400
Date: Thu, 18 Oct 2007 09:58:10 -0500
From: Olof Johansson <olof@lixom.net>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Benny Halevy <bhalevy@panasas.com>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018145810.GB5565@lixom.net>
References: <20071018.045505.106265100.davem@davemloft.net> <20071018115702.GW5063@kernel.dk> <20071018.050554.115911163.davem@davemloft.net> <20071018120950.GX5063@kernel.dk> <20071018121547.GY5063@kernel.dk> <4717587E.6090301@panasas.com> <20071018135605.GL5063@kernel.dk> <20071018140550.GO5063@kernel.dk> <47176AB9.2070000@panasas.com> <20071018143836.GA10674@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018143836.GA10674@kernel.dk>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 04:38:36PM +0200, Jens Axboe wrote:
> On Thu, Oct 18 2007, Benny Halevy wrote:
> > On Oct. 18, 2007, 16:05 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> > > On Thu, Oct 18 2007, Jens Axboe wrote:
> > >> On Thu, Oct 18 2007, Benny Halevy wrote:
> > >>>>  	return sg;
> > >>>>  }
> > >>>> @@ -83,6 +96,9 @@ static inline struct scatterlist *sg_last(struct scatterlist *sgl,
> > >>>>  		ret = sg;
> > >>>>  
> > >>>>  #endif
> > >>>> +#ifdef CONFIG_DEBUG_SG
> > >>>> +	BUG_ON(sgl[0].sg_magic != SG_MAGIC);
> > >>> can it also do BUG_ON(!sg_is_last(sg))?
> > >> That would make sense, definitely. I'll add that.
> > > 
> > >         BUG_ON(!sg_is_last(ret));
> > > 
> > > it should be, not sg. That's what I merged.
> > > 
> > right. of course.
> 
> OK, that found something interesting - mapping a request may shrink it,
> so we need to update the end marker to move it earlier in the list.
> Basically just a
> 
>         if (sg)
>                 __sg_mark_end(sg);
> 
> at the bottom of blk_rq_map_sg(). Updated patch below, booted on other
> machines now as well without incident.

PPC needs this. I'm guessing other arches might too. Otherwise seems to boot
and work well (with Jeff's sata patch).


Thanks,

-Olof

diff --git a/include/asm-powerpc/scatterlist.h b/include/asm-powerpc/scatterlist.h
index b9f1dbc..fcf7d55 100644
--- a/include/asm-powerpc/scatterlist.h
+++ b/include/asm-powerpc/scatterlist.h
@@ -14,6 +14,9 @@
 #include <asm/dma.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long sg_magic;
+#endif
 	unsigned long page_link;
 	unsigned int offset;
 	unsigned int length;
