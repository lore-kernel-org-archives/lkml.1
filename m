Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbZC0VbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbZC0VbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZC0VbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:31:06 -0400
Received: from THUNK.ORG ([69.25.196.29]:47812 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbZC0VbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:31:03 -0400
Date: Fri, 27 Mar 2009 17:30:52 -0400
From: Theodore Tso <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Cc: Ric Wheeler <rwheeler@redhat.com>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>, jack@suse.cz
Subject: Re: [PATCH 0/3] Ext3 latency improvement patches
Message-ID: <20090327213052.GC5176@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>, jack@suse.cz
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238187031.27455.212.camel@think.oraclecorp.com> <1238187818.27455.217.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238187818.27455.217.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 05:03:38PM -0400, Chris Mason wrote:
> > Ric had asked me about a test program that would show the worst case
> > ext3 behavior.  So I've modified your ext3 program a little.  It now
> > creates a 8G file and forks off another proc to do random IO to that
> > file.
> > 
> 
> My understanding of ext4 delalloc is that once blocks are allocated to
> file, we go back to data=ordered.  

Yes, that's correct.

> Ext4 is going pretty slowly for this fsync test (slower than ext3), it
> looks like we're going for a very long time in
> jbd2_journal_commit_transaction -> write_cache_pages.

One of the things that we can do to optimize this case for ext4 (and
ext3) is that if block has already been written out to disk once, we
don't have to flush it to disk a second time.  So if we add a new
buffer_head flag which can distinguish between blocks that have been
newly allocated (and not yet been flushed to disk) versus blocks that
have already been flushed to disk at least once, we wouldn't need to
force I/O for blocks in the latter case.

After all, most of the applications which do random I/O to a file
normally will use fsync() appropriately such that they are rewriting
already allocated blocks.  So there really is no reason to flush those
blocks out to disk even in data=ordered mode.

We currently flush *all* blocks out to disk in data=ordered mode
because we don't have a good way of telling the difference between the
two cases.  

						- Ted
