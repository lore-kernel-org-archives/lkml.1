Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbZCYKpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbZCYKpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbZCYKpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:45:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49238 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbZCYKph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:45:37 -0400
Date: Wed, 25 Mar 2009 11:46:41 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH 02/12] DRBD: activity_log
Message-ID: <20090325104641.GB11935@one.firstfloor.org>
References: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com> <1237823287-12734-3-git-send-email-philipp.reisner@linbit.com> <87bprrhzqw.fsf@basil.nowhere.org> <200903251127.23287.philipp.reisner@linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903251127.23287.philipp.reisner@linbit.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 11:27:22AM +0100, Philipp Reisner wrote:
> md_io_page gets allocated with GFP_KERNEL (no GFP_HIGHMEM either).
> 
> 
> [...]
> > > +
> > > +		spin_lock_irq(&mdev->al_lock);
> > > +		lc_changed(mdev->act_log, al_ext);
> > > +		spin_unlock_irq(&mdev->al_lock);
> > > +		wake_up(&mdev->al_wait);
> >
> > The wake_up outside the lock looks a little dangerous.
> >
> 
> Please share you thoughts, why this looks a little dangerous ?

I haven't double checked the whole path, but unlocked wake up
is often a good recipe to potentially lose wake ups.

> [...]
> > > +	mutex_lock(&mdev->md_io_mutex); /* protects md_io_buffer, al_tr_cycle,
> > > ... */
> >
> > Doing checksumming inside a lock looks nasty.
> >
> 
> Well, that is a mutex, not a spinlock. We need to hold that lock here,

Yes it's independent. If it takes a lot of CPU time you'll likely have
a bottle neck. It's normally a bad idea to do anything CPU intensive
under a lock covering more than your current limited object.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
