Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbZJKTR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbZJKTR6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 15:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZJKTR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 15:17:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60676 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750960AbZJKTR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 15:17:56 -0400
Date: Sun, 11 Oct 2009 20:17:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, John Kacur <jkacur@redhat.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vincent^M^J Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sound_core.c: Remove BKL from soundcore_open
Message-ID: <20091011201759.435cd93c@lxorguk.ukuu.org.uk>
In-Reply-To: <20091011103755.649f5ae1@infradead.org>
References: <alpine.LFD.2.00.0910110123510.4921@localhost.localdomain>
	<20091011004219.74c30f67@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0910110223510.4921@localhost.localdomain>
	<20091011092015.37a69847@bike.lwn.net>
	<20091011111543.1cbb9a0e@tpl.lwn.net>
	<20091011103755.649f5ae1@infradead.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> it's getting time though to bite the bullet and make it a real normal
> mutex. Lockdep will then flag a bunch of sh*t we'll need to fix, but
> without doing that we're never going to really make progress. 

It won't. Instead you get situations like one ioctl blocking another to
an unrelated device that just causes weird failures and performance
problems, or in some cases deadlocks.

Open routines block so it takes about 5 seconds of thought to realise
that using a mutex here is brain dead and doesn't work.

You push the BKL down. Next step from the call point is to replicate it
inside each of the drivers that path can call, then in those drivers push
the lock_kernel down and the internal locking up. Eventually they meet in
the middle.

If you try and do botch jobs with bogus mutex hacks it breaks, it breaks
in ways lockdep doesn't understand and it doesn't even *help* fix the
problem proper.

Alan
