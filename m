Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbZJKRQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbZJKRQF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 13:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbZJKRQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 13:16:03 -0400
Received: from vena.lwn.net ([206.168.112.25]:40302 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540AbZJKRQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 13:16:01 -0400
Date: Sun, 11 Oct 2009 11:15:43 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: John Kacur <jkacur@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vincent^M^J Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sound_core.c: Remove BKL from soundcore_open
Message-ID: <20091011111543.1cbb9a0e@tpl.lwn.net>
In-Reply-To: <20091011092015.37a69847@bike.lwn.net>
References: <alpine.LFD.2.00.0910110123510.4921@localhost.localdomain>
	<20091011004219.74c30f67@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0910110223510.4921@localhost.localdomain>
	<20091011092015.37a69847@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009 09:20:15 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> Changing the
> BKL to a mutex is a real semantic change which requires a real survey
> of the code affected.

One other aspect of this I forgot to mention...it's actually possible
(if unlikely) that one of those lower-level open routines depends on
the BKL's release-on-sleep semantics.  Swapping in a mutex would change
that behavior, possibly resulting in deadlocks.

I think it was Alan who once pointed out that the BKL is badly
misnamed.  It isn't really a lock, it's a modified execution
environment designed to let naive kernel code think it's still running
in a uniprocessor, no-preemption situation.  Replacing the BKL with a
different lock changes that environment, so one has to be *really*
careful about looking for any assumptions which may remain in the code.

That's why BKL-hunting is harder than it looks - and why the BKL has
hung around for all these years.

jon
