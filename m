Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbZFPKNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbZFPKNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZFPKMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:12:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58429 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752751AbZFPKMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:12:48 -0400
Date: Tue, 16 Jun 2009 11:13:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] WARNING: at drivers/char/tty_io.c:1266
 tty_open+0x1ea/0x388()
Message-ID: <20090616111316.6b3bb078@lxorguk.ukuu.org.uk>
In-Reply-To: <20090616071057.GA29862@elte.hu>
References: <20090614081052.GA9276@elte.hu>
	<20090614115428.1127ed2d@lxorguk.ukuu.org.uk>
	<20090616071057.GA29862@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have applied your patch from yesterday (attached further below for 
> reference) and the SLAB corruption has not triggered - instead i'm 
> now getting this warning, after 96 reboots

That one is interesting btw - however its not a new bug. The WARN_ON()
was added in the new patches to catch cases where the tty open/close
locking was broken and see if all the ldisc related ones were nailed.

Apparently on a very SMP box they are not. It's not however a new bug -
just the result of checking for the problem.

+        WARN_ON(!test_bit(TTY_LDISC, &tty->flags));


..

which means that someone cleared the ldisc behind our back despite us
holding tty_mutex. That would suggest a hangup/reopen race which
shouldn't be too hard to find.

Dunno what you feed your SMP box but its very useful 8)

Alan
