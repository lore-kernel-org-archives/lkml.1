Return-Path: <linux-kernel-owner+w=401wt.eu-S1763870AbZCXRj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763870AbZCXRj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZCXRjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:39:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752370AbZCXRjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:39:45 -0400
Date: Tue, 24 Mar 2009 10:32:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesper Krogh <jesper@krogh.cc>
cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49C90B91.9050002@krogh.cc>
Message-ID: <alpine.LFD.2.00.0903241020250.3032@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu>
 <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <20090324133011.GB21720@elte.hu> <20090324135112.GM5814@mit.edu> <49C90B91.9050002@krogh.cc>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Mar 2009, Jesper Krogh wrote:
>
> Theodore Tso wrote:
> > That's definitely a problem too, but keep in mind that by default the
> > journal gets committed every 5 seconds, so the data gets flushed out
> > that often.  So the question is how quickly can you *dirty* 1.6GB of
> > memory?

Doesn't at least ext4 default to the _insane_ model of "data is less 
important than meta-data, and it doesn't get journalled"?

And ext3 with "data=writeback" does the same, no?

Both of which are - as far as I can tell - total braindamage. At least 
with ext3 it's not the _default_ mode.

I never understood how anybody doing filesystems (especially ones that 
claim to be crash-resistant due to journalling) would _ever_ accept the 
"writeback" behavior of having "clean fsck, but data loss".

> Say it's a file that you allready have in memory cache read in.. there
> is plenty of space in 16GB for that.. then you can dirty it at memory-speed..
> that about ½sec. (correct me if I'm wrong).

No, you'll still have to get per-page locks etc. If you use mmap(), you'll 
page-fault on each page, if you use write() you'll do all the page lookups 
etc. But yes, it can be pretty quick - the biggest cost probably _will_ be 
the speed of memory itself (doing one-byte writes at each block would 
change that, and the bottle-neck would become the system call and page 
lookup/locking path, but it's probably in the same rough cost as cost of 
writing out one page one page).

That said, this is all why we now have 'dirty_*bytes' limits too. 

The problem is that the dirty_[background_]bytes value really should be 
scaled up by the speed of IO. And we currently have no way to do that. 
Some machines can write a gigabyte in a second with some fancy RAID 
setups. Others will take minutes (or hours) to do that (crappy SSD's that 
get 25kB/s throughput on random writes).

The "dirty_[background_ratio" percentage doesn't scale up by the speed of 
IO either, of course, but at least historically there was generally a 
pretty good correlation between amount of memory and speed of IO. The 
machines that had gigs and gigs of RAM tended to always have fast IO too.  
So scaling up dirty limits by memory size made sense both in the "we have 
tons of memory, so allow tons of it to be dirty" sense _and_ in the "we 
likely have a fast disk, so allow more pending dirty data".

				Linus
