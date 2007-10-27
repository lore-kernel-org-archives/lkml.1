Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbXJ0PNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbXJ0PNR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 11:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbXJ0PNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 11:13:05 -0400
Received: from twin.jikos.cz ([213.151.79.26]:53054 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbXJ0PNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 11:13:04 -0400
Date: Sat, 27 Oct 2007 17:12:41 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Gabriel C <nix.or.die@googlemail.com>
cc: a.zummo@towertech.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: BUG: lock held when returning to user space
In-Reply-To: <472348F6.6050100@googlemail.com>
Message-ID: <Pine.LNX.4.64.0710271707140.18815@twin.jikos.cz>
References: <472348F6.6050100@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007, Gabriel C wrote:

> I found that today in dmesg after booting current git ( 
> ec3b67c11df42362ccda81261d62829042f223f0 ) :
> ...
> [  592.752777]
> [  592.752781] ================================================
> [  592.753478] [ BUG: lock held when returning to user space! ]
> [  592.753880] ------------------------------------------------
> [  592.754262] hwclock/1452 is leaving the kernel with locks still held!
> [  592.754655] 1 lock held by hwclock/1452:
> [  592.755007]  #0:  (&rtc->char_lock){--..}, at: [<c02a7ebb>] rtc_dev_open+0x2e/0x7e                                        

Yes, this is because rtc keeps a char_lock mutex locked as long as the 
device is open, to avoid concurrent accessess.

It could be easily substituted by some counting -- setting and clearing 
bit in struct rtc_device instead of using char_lock, but doing this just 
to shut the lockdep off is questionable imho.

Peter, what is the preferred way to annotate these kinds of locking for 
lockdep to express that it is intended?

-- 
Jiri Kosina
