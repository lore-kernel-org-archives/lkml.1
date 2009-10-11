Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbZJKRiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbZJKRiP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 13:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbZJKRiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 13:38:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:36047 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297AbZJKRiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 13:38:07 -0400
Date: Sun, 11 Oct 2009 10:37:55 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jonathan Corbet <corbet@lwn.net>, John Kacur <jkacur@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vincent^M^J Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sound_core.c: Remove BKL from soundcore_open
Message-ID: <20091011103755.649f5ae1@infradead.org>
In-Reply-To: <20091011111543.1cbb9a0e@tpl.lwn.net>
References: <alpine.LFD.2.00.0910110123510.4921@localhost.localdomain>
	<20091011004219.74c30f67@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0910110223510.4921@localhost.localdomain>
	<20091011092015.37a69847@bike.lwn.net>
	<20091011111543.1cbb9a0e@tpl.lwn.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009 11:15:43 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> On Sun, 11 Oct 2009 09:20:15 -0600
> Jonathan Corbet <corbet@lwn.net> wrote:
> 
> > Changing the
> > BKL to a mutex is a real semantic change which requires a real
> > survey of the code affected.
> 
> One other aspect of this I forgot to mention...it's actually possible
> (if unlikely) that one of those lower-level open routines depends on
> the BKL's release-on-sleep semantics.  Swapping in a mutex would
> change that behavior, possibly resulting in deadlocks.
> 
> I think it was Alan who once pointed out that the BKL is badly
> misnamed.  It isn't really a lock, it's a modified execution
> environment designed to let naive kernel code think it's still running
> in a uniprocessor, no-preemption situation.  Replacing the BKL with a
> different lock changes that environment, so one has to be *really*
> careful about looking for any assumptions which may remain in the
> code.
> 

it's getting time though to bite the bullet and make it a real normal
mutex. Lockdep will then flag a bunch of sh*t we'll need to fix, but
without doing that we're never going to really make progress. 

The BKL has outlived its usefulness. Many of the things it used to
protect (device open, module load etc) no longer take the BKL since
quite a while, making the notion of "if you see the BKL you have a bug" 
more and more true.

Going from rather obscure semantics to more defined, and more
importantly, checkable-by-lockdep semantics is going to be a step
forward in this sense; while we can't check that it protects what it
should, we can at least start treating it like a real lock...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
