Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYH1I1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYH1I1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 04:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYH1I13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 04:27:29 -0400
Received: from ns2.suse.de ([195.135.220.15]:58631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbYH1I1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 04:27:25 -0400
From: Neil Brown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 28 Aug 2008 18:27:13 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18614.24929.952454.829021@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, jurriaan <thunder7@xs4all.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc4: lots of 'in_atomic():1, irqs_disabled():0' with  software-raid1
In-Reply-To: message from Jens Axboe on Thursday August 28
References: <20080827170538.GA24393@amd64.of.nowhere>
	<200808272347.43577.rjw@sisk.pl>
	<20080828073324.GR20055@kernel.dk>
	<20080828004532.45d8b8c9.akpm@linux-foundation.org>
	<20080828074830.GV20055@kernel.dk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday August 28, jens.axboe@oracle.com wrote:
> On Thu, Aug 28 2008, Andrew Morton wrote:
> > 
> > Cant sleep inside rcu_read_lock(), with CONFIG_PREEMPT_RCU=n, at least.
> > 
> > Dunno if it's legal if CONFIG_PREEMPT_RCU=y.  Hopefully not - that
> > would be insane.  But I've failed to keep up with rcu goings-on
> > recently.
> 
> Doh right, we of course can't block inside a RCU section. Then
> bitmap.c:write_sb_page() wants fixing:
> 
>         rcu_read_lock();
>         rdev_for_each_rcu(...)
>                 md_super_write(...)
>                         bio_alloc(GFP_NOIO, 1);
> 
> Neil?


Yes......

And not only can't I call bio_alloc inside the rcu_read_lock, I also
cannot call submit_bio, as that can do a mempool alloc for a request
structure.
I can get around that by putting the bios on the ->biolist that
md_super_wait will resubmit requests from.  But I still need to
allocate those bios.
Maybe I can count how many there need to be, then allocate them and
make a list, then pass them down into md_super_write.
It's a bit ugly but it should work.

I think I'll have to think about it a bit more.

Thanks,
NeilBrown
