Return-Path: <linux-kernel-owner+w=401wt.eu-S1761214AbYCXR4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761214AbYCXR4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 13:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbYCXR4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:56:15 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:14098 "EHLO
	mk-filter-2-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753220AbYCXR4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:56:14 -0400
X-Trace: 691451825/mk-filter-2.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj8FAKmH50dRAVlC/2dsb2JhbACBW6YN
Subject: Re: [PATCH] 3/3 maple: update bus driver to support Dreamcast VMU
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Greg KH <greg@kroah.com>,
       dwmw2 <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <20080324173856.GI2899@logfs.org>
References: <1206207805.6324.13.camel@localhost.localdomain>
	 <1206209786.6324.41.camel@localhost.localdomain>
	 <20080324033344.GB15872@linux-sh.org> <20080324144647.GC2899@logfs.org>
	 <1206371178.6283.37.camel@localhost.localdomain>
	 <20080324152952.GF2899@logfs.org>
	 <1206373900.6283.39.camel@localhost.localdomain>
	 <20080324160429.GG2899@logfs.org> <20080324170707.GH2899@logfs.org>
	 <20080324173856.GI2899@logfs.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 24 Mar 2008 17:55:51 +0000
Message-Id: <1206381351.7543.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-24 at 18:38 +0100, Jörn Engel wrote:
> On Mon, 24 March 2008 18:07:07 +0100, Jörn Engel wrote:
> > 
> > The second rearranges the list locking a bit.  Previously it was
> > possible to touch maple_waitq or maple_sentq without holding the lock.
> > With my limited understanding of the driver, the second patch may
> > already be enough to prevent the type of corruption you've been seeing.
> 
> Limited understanding indeed.  The problem in the mtd driver is that it
> has no concept of ownership.  For example maple_vmu_read_block() does
> the following:
> 	mdev->mq->sendbuf = sendbuf;
> 	...
> 	maple_add_packet(mdev->mq);
> 
> It accesses some field in mdev->mq, then sends the structure off to
> maple_add_packet().  From this point on, mdev->mq belongs to the bus
> driver - until it calls the callback, vmu_blockread() in this case.
> 
> But a second thread can call into maple_vmu_read_block() again and
> access mdev->mq while it rightfully belongs to the bus driver.  Bad
> things will happen.
> 
> So these two patches try to close the race windows.  Please note the
> FIXME in the write patch - I didn't do all the work.  Real life calls
> for attention, so these will be the last patches for a while.
> 
> Jörn
> 

The problem is that the hardware does not support another callback. In
any case while you are right that the function might be called as second
time, in the original code it will sleep while waiting for the lock,
which is allocated per device.

On the second patch - aiui completions do an uninterruptible wait, that
means they are surely not a good choice for this - especially as the
device could be unplugged at any time. (Admittedly my documentation
migght be of date here)

