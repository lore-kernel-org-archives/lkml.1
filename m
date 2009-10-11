Return-Path: <linux-kernel-owner+w=401wt.eu-S1751586AbZJKUwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbZJKUwq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 16:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbZJKUwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 16:52:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43699 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751390AbZJKUwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 16:52:44 -0400
Date: Sun, 11 Oct 2009 21:51:31 +0100
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
Message-ID: <20091011215131.03655961@lxorguk.ukuu.org.uk>
In-Reply-To: <20091011122632.53a61a09@infradead.org>
References: <alpine.LFD.2.00.0910110123510.4921@localhost.localdomain>
	<20091011004219.74c30f67@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0910110223510.4921@localhost.localdomain>
	<20091011092015.37a69847@bike.lwn.net>
	<20091011111543.1cbb9a0e@tpl.lwn.net>
	<20091011103755.649f5ae1@infradead.org>
	<20091011201759.435cd93c@lxorguk.ukuu.org.uk>
	<20091011122632.53a61a09@infradead.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It won't. Instead you get situations like one ioctl blocking another
> > to an unrelated device that just causes weird failures and performance
> > problems, or in some cases deadlocks.
> 
> yes the bkl using code will be slower because it'll now hit contention.

No - the mutex using ioctls that sleep now block each other out - this
mistake was made in some video drivers.

> > Open routines block so it takes about 5 seconds of thought to realise
> > that using a mutex here is brain dead and doesn't work.
> 
> it also takes 5 seconds to realize "uh oh. they block. BKL is rather
> limited in what it provides".

Which is what the code was written for.

This is why you can't just slap in a mutex but have to push it down.

Chances are that for a lot of small drivers you go

lock_kernel
foo->op()
unlock_kernel


to

foo->op()

	op()
	lock_kernel
	blah
	unlock_kernel

correctly on to

	op()
	{
		mutex_lock(instance->lock);
		blah
		mutex_unlock(instance->lock);

but you can't jump those steps and hope to get it right.

Alan
