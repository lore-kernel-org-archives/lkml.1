Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbZC0DXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbZC0DXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 23:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbZC0DXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 23:23:13 -0400
Received: from thunk.org ([69.25.196.29]:53135 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615AbZC0DXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 23:23:13 -0400
Date: Thu, 26 Mar 2009 23:23:01 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327032301.GN6239@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49C88C80.5010803@krogh.cc> <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com> <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 06:03:15PM -0700, Linus Torvalds wrote:
> 
> Everybody accepts that if you've written a 20MB file and then call 
> "fsync()" on it, it's going to take a while. But when you've written a 2kB 
> file, and "fsync()" takes 20 seconds, because somebody else is just 
> writing normally, _that_ is a bug. And it is actually almost totally 
> unrelated to the whole 'dirty_limit' thing.

Yeah, well, it's caused by data=ordered, which is an ext3 unique
thing; no other filesystem (or operating system) has such a feature.
I'm beginning to wish we hadn't implemented it.  Yeah, it solved a
security problem (which delayed allocation also solves), but it
trained application programs to be careless about fsync(), and it's
caused us so many other problems, including the fsync() and unrelated
commit latency problems.

We are where we are, though, and people have been trained to think
they don't need fsync(), so we're going to have to deal with the
problem by having these implied fsync for cases like
replace-via-rename, and in addition to that, some kind of hueristic to
force out writes early to avoid these huge write latencies.  It would
be good to make it be autotuning it so that filesystems that don't do
ext3 data=ordered don't have to pay the price of having to force out
writes so aggressively early (since in some cases if the file
subsequently is deleted, we might be able to optimize out the write
altogether --- and that's good for SSD endurance).

	     	       		      	  	 - Ted
