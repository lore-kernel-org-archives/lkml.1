Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbZCZCLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbZCZCLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZCZCLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:11:15 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33330 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbZCZCLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:11:14 -0400
Date: Thu, 26 Mar 2009 02:10:34 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090326021034.GA26559@srcf.ucam.org>
References: <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <20090325194851.GA1617@infradead.org> <20090325215016.GP32307@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325215016.GP32307@mit.edu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 05:50:16PM -0400, Theodore Tso wrote:

> To be fair, though, one problem which Matthew Garrett has pointed out
> is that if lots of applications issue fsync(), it will have the
> tendency to wake up the hard drive a lot, and do a real number on
> power utilization.  I believe the right solution for this is an
> extension to laptop mode which synchronizes the filesystem at a clean
> point, and then which suppresses fsync()'s until the hard drive wakes
> up, at which point it should flush all dirty data to the drive, and
> then freezes writes to the disk again.  Presumably that should be OK,
> because who are using laptop mode are inherently trading off a certain
> amount of safety for power savings; but then other people who want to
> run a mysql server on a laptop get cranky, and then if we start
> implementing ways that applications can exempt themselves from the
> fsync() suppression, the complexity level starts rising.

I disagree with this approach. If fsync() means anything other than "Get 
my data on disk and then return" then we're breaking guarantees to 
applications. The problem is that you're insisting that the only way 
applications can ensure that their requests occur in order is to use 
fsync(), which will achieve that but also provides guarantees above and 
beyond what the majority of applications want.

I've done some benchmarking now and I'm actually fairly happy with the 
behaviour of ext4 now - it seems that the real world impact of doing the 
block allocation at rename time isn't that significant, and if that's 
the only practical way to ensure ordering guarantees in ext4 then fine. 
But given that, I don't think there's any reason to try to convince 
application authors to use fsync() more.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
