Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbXJ0QKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbXJ0QKR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 12:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbXJ0QKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 12:10:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56880 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbXJ0QKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 12:10:03 -0400
Subject: Re: BUG: lock held when returning to user space
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jiri Kosina <jikos@jikos.cz>, Gabriel C <nix.or.die@googlemail.com>,
       a.zummo@towertech.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com
In-Reply-To: <20071027084713.72733460@laptopd505.fenrus.org>
References: <472348F6.6050100@googlemail.com>
	 <Pine.LNX.4.64.0710271707140.18815@twin.jikos.cz>
	 <20071027084713.72733460@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Sat, 27 Oct 2007 18:09:29 +0200
Message-Id: <1193501369.5648.78.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-10-27 at 08:47 -0700, Arjan van de Ven wrote:
> On Sat, 27 Oct 2007 17:12:41 +0200 (CEST)
> Jiri Kosina <jikos@jikos.cz> wrote:
> 
> > On Sat, 27 Oct 2007, Gabriel C wrote:
> > 
> > > I found that today in dmesg after booting current git ( 
> > > ec3b67c11df42362ccda81261d62829042f223f0 ) :
> > > ...
> > > [  592.752777]
> > > [  592.752781] ================================================
> > > [  592.753478] [ BUG: lock held when returning to user space! ]
> > > [  592.753880] ------------------------------------------------
> > > [  592.754262] hwclock/1452 is leaving the kernel with locks still
> > > held! [  592.754655] 1 lock held by hwclock/1452:
> > > [  592.755007]  #0:  (&rtc->char_lock){--..}, at: [<c02a7ebb>]
> > > rtc_dev_open+0x2e/0x7e                                        
> > 
> > Yes, this is because rtc keeps a char_lock mutex locked as long as
> > the device is open, to avoid concurrent accessess.
> > 
> > It could be easily substituted by some counting -- setting and
> > clearing bit in struct rtc_device instead of using char_lock, but
> > doing this just to shut the lockdep off is questionable imho.
> 
> it's not about lockdep; what this code doing is not valid use of a
> mutex:
> A mutex is required to have a clear process as owner, and in this case
> it doesn't have that... at all. This is a violation of the kernel mutex
> semantics.. and should be fixed.

Right, the fd could be transferred using unix sockets or fork(). That
would indeed seriously break a mutex.


