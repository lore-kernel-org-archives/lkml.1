Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYCTWe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYCTWe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759432AbYCTWea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:34:30 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:6381 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759365AbYCTWe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:34:28 -0400
X-Trace: 700700422/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As4EALiD4kdRAVlC/2dsb2JhbACBWqlt
Subject: Re: [PATCH] 2/2 mtd: Add support for the Dreamcast VMU flash
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dwmw2@infradead.org, greg@kroah.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       linux-mtd@vger.kernel.org
In-Reply-To: <20080320141018.34127f0d.akpm@linux-foundation.org>
References: <1205879413.6250.13.camel@localhost.localdomain>
	 <1205880554.6250.25.camel@localhost.localdomain>
	 <1205880982.6250.32.camel@localhost.localdomain>
	 <20080320141018.34127f0d.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 22:34:02 +0000
Message-Id: <1206052442.6274.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-20 at 14:10 -0700, Andrew Morton wrote:

> If this error is taken, vmu_flash_write() (at least) will not call
> maple_vmu_write_block() and hence mdev->mq->sem never gets up()ed.  As far
> as I can tell.
> 
> Also, when this function is called from vmu_flash_read_char() I can't see
> where mdev->mq->sem gets up()ed ever.  But I didn't look too hard.
> 

It's not an issue - the bus will report "a no reply" at the end of the
bus read and that will result in an automatic up.


<snip>
> > +
> > +	for (x = 0; x < card->writecnt; x++) {
> > +		/* take the lock to protect the contents of sendbuf */
> > +		locking = down_interruptible(&mdev->mq->sem);
> > +		if (locking) {
> > +			error = -EBUSY;
> > +			goto fail_nolock;
> > +		}
> 
> Confused.  Where within this loop does the up(&mdev->mq->sem) happen?
> 

It's in the bus code.


> > +		((unsigned long *)sendbuf)[1] =
> > +			cpu_to_be32(partition << 24 | x << 16 | num);
> > +		memcpy(sendbuf + 8, buf + phaselen * x, phaselen);
> > +		mdev->mq->sendbuf = sendbuf;
> > +		/* wait for the mutex to be available */
> > +		maple_add_packet(mdev->mq);
> 
> Within here, I guess, via a workqueue or timer function?


It's handled in a workqueue in the main bus code, yes.

