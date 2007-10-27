Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbXJ0PaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbXJ0PaG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 11:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbXJ0P3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 11:29:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54161 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbXJ0P3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 11:29:55 -0400
Subject: Re: BUG: lock held when returning to user space
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Gabriel C <nix.or.die@googlemail.com>, a.zummo@towertech.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0710271707140.18815@twin.jikos.cz>
References: <472348F6.6050100@googlemail.com>
	 <Pine.LNX.4.64.0710271707140.18815@twin.jikos.cz>
Content-Type: text/plain
Date: Sat, 27 Oct 2007 17:28:41 +0200
Message-Id: <1193498921.5648.68.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-10-27 at 17:12 +0200, Jiri Kosina wrote:
> On Sat, 27 Oct 2007, Gabriel C wrote:
> 
> > I found that today in dmesg after booting current git ( 
> > ec3b67c11df42362ccda81261d62829042f223f0 ) :
> > ...
> > [  592.752777]
> > [  592.752781] ================================================
> > [  592.753478] [ BUG: lock held when returning to user space! ]
> > [  592.753880] ------------------------------------------------
> > [  592.754262] hwclock/1452 is leaving the kernel with locks still held!
> > [  592.754655] 1 lock held by hwclock/1452:
> > [  592.755007]  #0:  (&rtc->char_lock){--..}, at: [<c02a7ebb>] rtc_dev_open+0x2e/0x7e                                        
> 
> Yes, this is because rtc keeps a char_lock mutex locked as long as the 
> device is open, to avoid concurrent accessess.
> 
> It could be easily substituted by some counting -- setting and clearing 
> bit in struct rtc_device instead of using char_lock, but doing this just 
> to shut the lockdep off is questionable imho.
> 
> Peter, what is the preferred way to annotate these kinds of locking for 
> lockdep to express that it is intended?

Not sure, I'd not thought that anyone would actually want to do this.
I'm also not sure how I stand on this, I'd prefer to say: don't do this!

I think, in this case, the lock is associated with a kernel object that
is properly cleaned up if the holding tasks gets a SIGKILL. But in
general I'd like to see this kind of thing go away.

Now I could probably come up with an annotation to hide it, but what do
other people think, Ingo, Linus, Andrew, do we want to keep kernel locks
held over userspace?



