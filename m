Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbYH1Igc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbYH1Igc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 04:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYH1IgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 04:36:23 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53684 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYH1IgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 04:36:23 -0400
Date: Thu, 28 Aug 2008 10:36:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, jurriaan <thunder7@xs4all.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc4: lots of 'in_atomic():1, irqs_disabled():0' with  software-raid1
Message-ID: <20080828083620.GX20055@kernel.dk>
References: <20080827170538.GA24393@amd64.of.nowhere> <200808272347.43577.rjw@sisk.pl> <20080828073324.GR20055@kernel.dk> <20080828004532.45d8b8c9.akpm@linux-foundation.org> <20080828074830.GV20055@kernel.dk> <18614.24929.952454.829021@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18614.24929.952454.829021@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28 2008, Neil Brown wrote:
> On Thursday August 28, jens.axboe@oracle.com wrote:
> > On Thu, Aug 28 2008, Andrew Morton wrote:
> > > 
> > > Cant sleep inside rcu_read_lock(), with CONFIG_PREEMPT_RCU=n, at least.
> > > 
> > > Dunno if it's legal if CONFIG_PREEMPT_RCU=y.  Hopefully not - that
> > > would be insane.  But I've failed to keep up with rcu goings-on
> > > recently.
> > 
> > Doh right, we of course can't block inside a RCU section. Then
> > bitmap.c:write_sb_page() wants fixing:
> > 
> >         rcu_read_lock();
> >         rdev_for_each_rcu(...)
> >                 md_super_write(...)
> >                         bio_alloc(GFP_NOIO, 1);
> > 
> > Neil?
> 
> 
> Yes......
> 
> And not only can't I call bio_alloc inside the rcu_read_lock, I also
> cannot call submit_bio, as that can do a mempool alloc for a request
> structure.

Right, it's not the only broken part there.

> I can get around that by putting the bios on the ->biolist that
> md_super_wait will resubmit requests from.  But I still need to
> allocate those bios.
> Maybe I can count how many there need to be, then allocate them and
> make a list, then pass them down into md_super_write.
> It's a bit ugly but it should work.
> 
> I think I'll have to think about it a bit more.

That was my initial thought as well, but the problem there is that you
cannot prealloc > 1 bio without matching it with a submit_bio() as well,
or you'd violate the bio_alloc() restriction on having the previous in
flight before allocating a new one.

-- 
Jens Axboe

