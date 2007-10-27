Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbXJ0PvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbXJ0PvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 11:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXJ0PvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 11:51:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47885 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbXJ0PvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 11:51:13 -0400
Date: Sat, 27 Oct 2007 08:47:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Gabriel C <nix.or.die@googlemail.com>, a.zummo@towertech.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: BUG: lock held when returning to user space
Message-ID: <20071027084713.72733460@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.64.0710271707140.18815@twin.jikos.cz>
References: <472348F6.6050100@googlemail.com>
	<Pine.LNX.4.64.0710271707140.18815@twin.jikos.cz>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007 17:12:41 +0200 (CEST)
Jiri Kosina <jikos@jikos.cz> wrote:

> On Sat, 27 Oct 2007, Gabriel C wrote:
> 
> > I found that today in dmesg after booting current git ( 
> > ec3b67c11df42362ccda81261d62829042f223f0 ) :
> > ...
> > [  592.752777]
> > [  592.752781] ================================================
> > [  592.753478] [ BUG: lock held when returning to user space! ]
> > [  592.753880] ------------------------------------------------
> > [  592.754262] hwclock/1452 is leaving the kernel with locks still
> > held! [  592.754655] 1 lock held by hwclock/1452:
> > [  592.755007]  #0:  (&rtc->char_lock){--..}, at: [<c02a7ebb>]
> > rtc_dev_open+0x2e/0x7e                                        
> 
> Yes, this is because rtc keeps a char_lock mutex locked as long as
> the device is open, to avoid concurrent accessess.
> 
> It could be easily substituted by some counting -- setting and
> clearing bit in struct rtc_device instead of using char_lock, but
> doing this just to shut the lockdep off is questionable imho.

it's not about lockdep; what this code doing is not valid use of a
mutex:
A mutex is required to have a clear process as owner, and in this case
it doesn't have that... at all. This is a violation of the kernel mutex
semantics.. and should be fixed.

> Peter, what is the preferred way to annotate these kinds of locking
> for lockdep to express that it is intended?

the preferred method is to not use a mutex like this...


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
