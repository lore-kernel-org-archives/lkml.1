Return-Path: <linux-kernel-owner+w=401wt.eu-S1763656AbZCYRhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763656AbZCYRhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763556AbZCYRhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:37:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762730AbZCYRhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:37:18 -0400
Date: Wed, 25 Mar 2009 10:29:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090325150041.GM32307@mit.edu>
Message-ID: <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu>
 <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Mar 2009, Theodore Tso wrote:
>
> I still think the fsync() problem is the much bigger deal, and solving 
> the contention problem isn't going to solve the fsync() latency problem 
> with ext3 data=ordered mode.

The fsync() problem is really annoying, but what is doubly annoying is 
that sometimes one process doing fsync() (or sync) seems to cause other 
processes to hickup too. 

Now, I personally solved that problem by moving to (good) SSD's on my 
desktop, and I think that's indeed the long-term solution. But it would be 
good to try to figure out a solution in the short term for people who 
don't have new hardware thrown at them from random companies too.

I suspect it's a combination of filesystem transaction locking, together 
with the VM wanting to write out some unrelated blocks or inodes due to 
the system just being close to the dirty limits. Which is why the 
system-wide hickups then happen especially when writing big files.

The VM _tries_ to do writes in the background, but if the writepage() path 
hits a filesystem-level blocking lock, that background write suddenly 
becomes largely synchronous.

I suspect there is also some possibility of confusion with inter-file 
(false) metadata dependencies. If a filesystem were to think that the file 
size is metadata that should be journaled (in a single journal), and the 
journaling code then decides that it needs to do those meta-data updates 
in the correct order (ie the big file write _before_ the file write that 
wants to be fsync'ed), then the fsync() will be delayed by a totally 
irrelevant large file having to have its data written out (due to 
data=ordered or whatever).

I'd like to think that no filesystem designer would ever be that silly, 
but I'm too scared to try to actually go and check. Because I could well 
imagine that somebody really thought that "size" is metadata.

			Linus
