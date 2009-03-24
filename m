Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbZCXNvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbZCXNvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZCXNvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:51:38 -0400
Received: from THUNK.ORG ([69.25.196.29]:34296 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZCXNvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:51:38 -0400
Date: Tue, 24 Mar 2009 09:51:12 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324135112.GM5814@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <20090324133011.GB21720@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324133011.GB21720@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 02:30:11PM +0100, Ingo Molnar wrote:
> i think the problem became visible via the rise in memory size, 
> combined with the non-improvement of the performance of rotational 
> disks.
> 
> The disk speed versus RAM size ratio has become dramatically worse - 
> and our "5% of RAM" dirty ratio on a 32 GB box is 1.6 GB - which 
> takes an eternity to write out if you happen to sync on that. When 
> we had 1 GB of RAM 5% meant 51 MB - one or two seconds to flush out 
> - and worse than that, chances are that it's spread out widely on 
> the disk, the whole thing becoming seek-limited as well.

That's definitely a problem too, but keep in mind that by default the
journal gets committed every 5 seconds, so the data gets flushed out
that often.  So the question is how quickly can you *dirty* 1.6GB of
memory?

"dd if=/dev/zero of=/u1/dirty-me-harder" will certainly do it, but
normally we're doing something useful, and so you're either copying
data from local disk, at which point you're limited by the read speed
of your local disk (I suppose it could be in cache, but how common of
a case is that?), *or*, you're copying from the network, and to copy
in 1.6GB of data in 5 seconds, that means you're moving 320
megabytes/second, which if we're copying in the data from the network,
requires a 10 gigabit ethernet.

Hence my statement that this probably became much more visible with
fast ethernets --- but you're right, the huge increase in memory sizes
was also a key factor; otherwise, write throttling would have kicked
in and the VM would have started pushing the dirty pages to disk much
sooner.

						- Ted
