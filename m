Return-Path: <linux-kernel-owner+w=401wt.eu-S1762587AbYCFDaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762587AbYCFDaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 22:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYCFD3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 22:29:50 -0500
Received: from mail.suse.de ([195.135.220.2]:53147 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbYCFD3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 22:29:49 -0500
From: Neil Brown <neilb@suse.de>
To: Andre Noll <maan@systemlinux.org>
Date: Thu, 6 Mar 2008 14:29:37 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18383.25889.876350.431676@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Subject: Re: [PATCH 001 of 9] md: Fix deadlock in md/raid1 and md/raid10 when handling a read error.
In-Reply-To: message from Andre Noll on Tuesday March 4
References: <20080303111240.23302.patches@notabene>
	<1080303001705.23577@suse.de>
	<20080303155449.GA32242@skl-net.de>
	<18380.59250.90214.461186@notabene.brown>
	<20080304112945.GB32242@skl-net.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday March 4, maan@systemlinux.org wrote:
> On 17:08, Neil Brown wrote:
> > > Do we really need to take the spin lock in the common case where
> > > conf->pending_bio_list.head is NULL? If not, the above could be
> > > optimized to the slightly faster and better readable
> > > 
> > > 	struct bio *bio;
> > > 
> > > 	if (!conf->pending_bio_list.head)
> > > 		return 0;
> > > 	spin_lock_irq(&conf->device_lock);
> > > 	bio = bio_list_get(&conf->pending_bio_list);
> > > 	...
> > > 	spin_unlock_irq(&conf->device_lock);
> > > 	return 1;
> > 
> > Maybe... If I write a memory location inside a spinlock, then after
> > the spinlock is dropped, I read that location on a different CPU,
> > am I always guaranteed to see the new value? or do I need some sort of
> > memory barrier?
> 
> Are you worried about another CPU setting conf->pending_bio_list.head
> to != NULL after the if statement? If that's an issue I think also
> the original patch is problematic because the same might happen after
> the final spin_unlock_irq() but but before flush_pending_writes()
> returns zero.

No.  I'm worried that another CPU might set
conf->pending_bio_list.head *before* the if statement, but it isn't
seen by this CPU because of the lack of memory barriers.  The spinlock
ensures that the memory state is consistent.
It is possible that I am being overcautious.  But I think that is
better than the alternative.

Thanks,
NeilBrown
