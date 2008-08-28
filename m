Return-Path: <linux-kernel-owner+w=401wt.eu-S1752482AbYH1JAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbYH1JAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 05:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYH1JAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 05:00:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbYH1JAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 05:00:37 -0400
Date: Thu, 28 Aug 2008 02:00:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       jurriaan <thunder7@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc4: lots of 'in_atomic():1, irqs_disabled():0' with 
 software-raid1
Message-Id: <20080828020018.a8ea85f0.akpm@linux-foundation.org>
In-Reply-To: <18614.24929.952454.829021@notabene.brown>
References: <20080827170538.GA24393@amd64.of.nowhere>
	<200808272347.43577.rjw@sisk.pl>
	<20080828073324.GR20055@kernel.dk>
	<20080828004532.45d8b8c9.akpm@linux-foundation.org>
	<20080828074830.GV20055@kernel.dk>
	<18614.24929.952454.829021@notabene.brown>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 18:27:13 +1000 Neil Brown <neilb@suse.de> wrote:

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

I'm curious about how this happened.

afaict from reading the code, this:

	rcu_read_lock();
	might_sleep();
	rcu_read_unlock();

will warn if CONFIG_PREEMPT_RCU=n but won't warn if
CONFIG_PREEMPT_RCU=y.  If correct, that's a nasty trap.

Is that what you did?
