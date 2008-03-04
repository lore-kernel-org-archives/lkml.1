Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYCDGJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYCDGJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYCDGI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:08:59 -0500
Received: from mail.suse.de ([195.135.220.2]:35840 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYCDGI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:08:58 -0500
From: Neil Brown <neilb@suse.de>
To: Andre Noll <maan@systemlinux.org>
Date: Tue, 4 Mar 2008 17:08:50 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18380.59250.90214.461186@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Subject: Re: [PATCH 001 of 9] md: Fix deadlock in md/raid1 and md/raid10 when handling a read error.
In-Reply-To: message from Andre Noll on Monday March 3
References: <20080303111240.23302.patches@notabene>
	<1080303001705.23577@suse.de>
	<20080303155449.GA32242@skl-net.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday March 3, maan@systemlinux.org wrote:
> On 11:17, NeilBrown wrote:
> 
> > So we create a new function 'flush_pending_writes' to give that attention,
> > and call it in freeze_array to be sure that we aren't waiting on raid1d.
> 
> Two minor remarks:

Thanks for looking.

> 
> Do we really need to take the spin lock in the common case where
> conf->pending_bio_list.head is NULL? If not, the above could be
> optimized to the slightly faster and better readable
> 
> 	struct bio *bio;
> 
> 	if (!conf->pending_bio_list.head)
> 		return 0;
> 	spin_lock_irq(&conf->device_lock);
> 	bio = bio_list_get(&conf->pending_bio_list);
> 	...
> 	spin_unlock_irq(&conf->device_lock);
> 	return 1;

Maybe... If I write a memory location inside a spinlock, then after
the spinlock is dropped, I read that location on a different CPU,
am I always guaranteed to see the new value? or do I need some sort of
memory barrier?
If I could be clear on that (and memory-barriers.txt isn't
helping... maybe if I read it 7 more times) then we probably could
make the change you suggest.
???

> 
> 
> > diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
> > --- .prev/drivers/md/raid1.c	2008-02-22 15:45:35.000000000 +1100
> > +++ ./drivers/md/raid1.c	2008-02-22 15:45:35.000000000 +1100
> > @@ -592,6 +592,37 @@ static int raid1_congested(void *data, i
> >  }
> >  
> >  
> > +static int flush_pending_writes(conf_t *conf)
> > +{
> 
> [snip]
> 
> Any chance to avoid this code duplication?

Not really.
The "conf_t" in each case is a very different conf_t that just happens
to have the same name and some common fields.
There is actually quite a lot of structural similarity between raid1
and raid10, but I don't think there is much to be gained by trying to
share code there.

Thanks,
NeilBrown
