Return-Path: <linux-kernel-owner+w=401wt.eu-S1752949AbXJ0Wrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbXJ0Wrp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 18:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbXJ0Wrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 18:47:37 -0400
Received: from twin.jikos.cz ([213.151.79.26]:58722 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbXJ0Wrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 18:47:37 -0400
Date: Sun, 28 Oct 2007 00:47:15 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Gabriel C <nix.or.die@googlemail.com>, a.zummo@towertech.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: BUG: lock held when returning to user space
In-Reply-To: <1193498921.5648.68.camel@lappy>
Message-ID: <Pine.LNX.4.64.0710280043590.18815@twin.jikos.cz>
References: <472348F6.6050100@googlemail.com>  <Pine.LNX.4.64.0710271707140.18815@twin.jikos.cz>
 <1193498921.5648.68.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007, Peter Zijlstra wrote:

> > > [  592.752781] ================================================
> > > [  592.753478] [ BUG: lock held when returning to user space! ]
> > > [  592.753880] ------------------------------------------------
> > > [  592.754262] hwclock/1452 is leaving the kernel with locks still held!
> > > [  592.754655] 1 lock held by hwclock/1452:
> > > [  592.755007]  #0:  (&rtc->char_lock){--..}, at: [<c02a7ebb>] rtc_dev_open+0x2e/0x7e                                        
> > Yes, this is because rtc keeps a char_lock mutex locked as long as the 
> > device is open, to avoid concurrent accessess.
> I think, in this case, the lock is associated with a kernel object that
> is properly cleaned up if the holding tasks gets a SIGKILL. But in
> general I'd like to see this kind of thing go away.

Yes, but the fact is that is really is invalid use of mutex -- because the 
mutex owner could become seriously wrong after fork() or sending the 
filedescriptor through unix socket ... this easily leads to broken 
situation.

This seems to have been introduced in e824290e5d ... Alessandro, could you 
convert this to test_and_set_bit()/clear_bit() semantics instead of a 
mutex please?

Thanks,

-- 
Jiri Kosina
