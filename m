Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbZFOJ71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbZFOJ71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZFOJ7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:59:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbZFOJ7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:59:19 -0400
Date: Mon, 15 Jun 2009 11:59:20 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, yinghai@kernel.org,
       benh@kernel.crashing.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090615095920.GA10294@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI> <20090615081831.GA5411@osiris.boeblingen.de.ibm.com> <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com> <20090615094148.GC1314@wotan.suse.de> <1245059324.23207.13.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245059324.23207.13.camel@penberg-laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 12:48:44PM +0300, Pekka Enberg wrote:
> Hi Nick,
> 
> On Mon, Jun 15, 2009 at 11:18 AM, Heiko Carstens<heiko.carstens@de.ibm.com> wrote:
> > > > I didn't look any deeper into this, but looks to me like doing something like
> > > > schedule_work() this early isn't ok.
> > > >
> > > > This is the conversion that leads to the crash:
> > > >
> > > > -               alloc_bootmem_low(sizeof(struct raw3215_info));
> > > > +               kzalloc(sizeof(struct raw3215_info), GFP_NOWAIT | GFP_DMA);
> > > >
> > > > Might be that I missed something. Maybe some special flag?
> 
> On Mon, Jun 15, 2009 at 12:10:01PM +0300, Pekka Enberg wrote:
> > > Btw, you should not need to use GFP_NOWAIT anymore and GFP_KERNEL
> > > should be fine even during early boot.
> 
> On Mon, 2009-06-15 at 11:41 +0200, Nick Piggin wrote:
> > Is this the agreed way forward? I would like to maybe continue to
> > try having early allocations pass in special flags where possible
> > (it could even be a GFP_BOOT or something). It can make it easier
> > to perhaps reduce branches in core code in future and things can
> > be flagged in warnings....
> > 
> > I just like the idea of keeping such annotations.
> 
> I don't know if we agreed or not but Linus expressed his liking to the
> masking patch (that is merged now).

Yes I do like your patch, but more as the implementation of the
workaround for slab rather than being able to use it to mask
of random bits.


> I was more on the GFP_BOOT side also but I am beginning to like the fact
> that we can just do GFP_KERNEL and expect that to work in a sane way
> during boot (and perhaps later on during suspend). We can probably shave

I'd just not like to give up on it right away. I'm not convinced
that it is a "too hard" problem to have callers figure out the
right context (they do it for all other problems like whether
they can sleep and whether they hold specific types of locks
or whether they can be called in reclaim path etc etc etc).

And it is pretty trivial to add warnings to catch any of these
conditions. So while auditing might not be trivial, we would
likely be able to mop up remainders with some runtime warnings.

