Return-Path: <linux-kernel-owner+w=401wt.eu-S1760719AbZCXNay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760719AbZCXNay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbZCXNan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:30:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34150 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757823AbZCXNam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:30:42 -0400
Date: Tue, 24 Mar 2009 14:30:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324133011.GB21720@elte.hu>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324132032.GK5814@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Tso <tytso@mit.edu> wrote:

> More recently (as in this past weekend), I went back to the ext3 
> problem, and found a better solution, here:
> 
> 	 http://lkml.org/lkml/2009/3/21/304
> 	 http://lkml.org/lkml/2009/3/21/302
> 	 http://lkml.org/lkml/2009/3/21/303
> 
> These patches cause the synchronous writes caused by an fsync() to 
> be submitted using WRITE_SYNC, instead of WRITE, which definitely 
> helps in the case where there is a heavy read workload in the 
> background.
> 
> They don't solve the problem where there is a *huge* amount of 
> writes going on, though --- if something is dirtying pages at a 
> rate far greater than the local disk can write it out, say, either 
> "dd if=/dev/zero of=/mnt/make-lots-of-writes" or a massive distcc 
> cluster driving a huge amount of data towards a single system or a 
> wget over a local 100 megabit ethernet from a massive NFS server 
> where everything is in cache, then you can have a major delay with 
> the fsync().

Nice, thanks for the update! The situation isnt nearly as bleak as i 
feared they are :)

> However, what I've found, though, is that if you're just doing a 
> local copy from one hard drive to another, or downloading a huge 
> iso file from an ftp server over a wide area network, the fsync() 
> delays really don't get *that* bad, even with ext3.  At least, I 
> haven't found a workload that doesn't involve either dd 
> if=/dev/zero or a massive amount of data coming in over the 
> network that will cause fsync() delays in the > 1-2 second 
> category.  Ext3 has been around for a long time, and it's only 
> been the last couple of years that people have really complained 
> about this; my theory is that it was the rise of > 10 megabit 
> ethernets and the use of systems like distcc that really made this 
> problem really become visible.  The only realistic workload I've 
> found that triggers this requires a fast network dumping data to a 
> local filesystem.

i think the problem became visible via the rise in memory size, 
combined with the non-improvement of the performance of rotational 
disks.

The disk speed versus RAM size ratio has become dramatically worse - 
and our "5% of RAM" dirty ratio on a 32 GB box is 1.6 GB - which 
takes an eternity to write out if you happen to sync on that. When 
we had 1 GB of RAM 5% meant 51 MB - one or two seconds to flush out 
- and worse than that, chances are that it's spread out widely on 
the disk, the whole thing becoming seek-limited as well.

That's where the main difference in perception of this problem comes 
from i believe. The problem was always there, but only in the last 
1-2 years did 4G/8G systems become really common for people to 
notice.

SSDs will save us eventually, but they will take up to a decade to 
trickle through for us to forget about this problem altogether.

	Ingo
