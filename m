Return-Path: <linux-kernel-owner+w=401wt.eu-S1750910AbYKXSxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910AbYKXSxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYKXSwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:52:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33364 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYKXSww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:52:52 -0500
Subject: Re: about TRIM/DISCARD support and barriers
From: David Woodhouse <dwmw2@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Tejun Heo <teheo@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Dongjun Shin <djshin90@gmail.com>,
       chris.mason@oracle.com
In-Reply-To: <1227552171.25499.30.camel@localhost.localdomain>
References: <4928E010.4090801@kernel.org> <4929023C.2060302@suse.de>
	 <20081123123514.GI5707@parisc-linux.org>
	 <1227447584.4901.405.camel@macbook.infradead.org>
	 <1227480776.25499.3.camel@localhost.localdomain>
	 <1227517430.26957.20.camel@macbook.infradead.org>
	 <1227552171.25499.30.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 18:52:45 +0000
Message-Id: <1227552765.25385.129.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 13:42 -0500, James Bottomley wrote:
> On Mon, 2008-11-24 at 09:03 +0000, David Woodhouse wrote:
> > On Mon, 2008-11-24 at 07:52 +0900, James Bottomley wrote:
> > > On Sun, 2008-11-23 at 13:39 +0000, David Woodhouse wrote:
> > > > > We don't attempt to put non-contiguous ranges into a single TRIM yet.
> > > > 
> > > > We don't even merge contiguous ranges -- I still need to fix the
> > > > elevators to stop writes crossing writes,
> > > 
> > > I don't think we want to do that ... it's legal if the write isn't a
> > > barrier and it will inhibit merging.  That may be just fine for a SSD,
> > > but it's not for spinning media since they get better performance out of
> > > merged writes.
> > 
> > No, I just mean writes _to the same sector_. At the moment, we happily
> > let those cross each other in the queue.
 ...
> It's not a bug ... but changing it might be feasible ... as long as it
> doesn't affect write performance too much (which I don't think it will),
> since it is in the critical path.

We could argue about how much sense it makes to let two writes to the
same sector actually happen in reverse order.

Especially given the fact that we actually _do_ preserve ordering in
some cases; just not in others. (We preserve ordering only if the start
and end of the duplicate writes are _precisely_ matching; if it's just
overlapping (which may well happen in the presence of merges), then this
check doesn't trigger.

But that's just semantics. Yes, changing it should be feasible. I talked
to Jens about that at the kernel summit, and we agreed that it should
probably be done.

> > And _then_ we can think about special cases which let us merge
> > non-contiguous discards.
> 
> I still think that treating discards as a special command from the
> outset is the better way forwards.

They're already treated as a special command and you can special-case
them wherever you like, so I'm not entirely sure what you're suggesting.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

