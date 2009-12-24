Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbZLXB0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbZLXB0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 20:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZLXB0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 20:26:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:65157 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbZLXB0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 20:26:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="226234646"
Date: Thu, 24 Dec 2009 09:26:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Steve Rago <sar@nec-labs.com>, Peter Zijlstra <peterz@infradead.org>,
       "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Trond.Myklebust@netapp.com" <Trond.Myklebust@netapp.com>,
       "jens.axboe" <jens.axboe@oracle.com>,
       Peter Staubach <staubach@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] improve the performance of large sequential write NFS
	workloads
Message-ID: <20091224012606.GB8486@localhost>
References: <1261015420.1947.54.camel@serenity> <1261037877.27920.36.camel@laptop> <20091219122033.GA11360@localhost> <1261232747.1947.194.camel@serenity> <20091222015907.GA6223@localhost> <20091222123538.GB604@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091222123538.GB604@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 08:35:39PM +0800, Jan Kara wrote:
> > 2) NFS commit stops pipeline because it sleep&wait inside i_mutex,
> >    which blocks all other NFSDs trying to write/writeback the inode.
> > 
> >    nfsd_sync:
> >      take i_mutex
> >        filemap_fdatawrite
> >        filemap_fdatawait
> >      drop i_mutex
>   I believe this is unrelated to the problem Steve is trying to solve.
> When we get to doing sync writes the performance is busted so we better
> shouldn't get to that (unless user asked for that of course).

Yes, first priority is always to reduce the COMMITs and the number of
writeback pages they submitted under WB_SYNC_ALL. And I guess the
"increase write chunk beyond 128MB" patches can serve it well.

The i_mutex should impact NFS write performance for single big copy in
this way: pdflush submits many (4MB write, 1 commit) pairs, because
the write and commit each will take i_mutex, it effectively limits the
server side io queue depth to <=4MB: the next 4MB dirty data won't
reach page cache until the previous 4MB is completely synced to disk.

There are two kinds of inefficiency here:
- the small queue depth
- the interleaved use of CPU/DISK:
        loop {
                write 4MB       => normally only CPU
                writeback 4MB   => mostly disk
        }

When writing many small dirty files _plus_ one big file, there will
still be interleaved write/writeback: the 4MB write will be broken
into 8 NFS writes with the default wsize=524288. So there may be one
nfsd doing COMMIT, another 7 nfsd waiting for the big file's i_mutex.
All 8 nfsd are "busy" and pipeline is destroyed. Just a possibility.

> >    If filemap_fdatawait() can be moved out of i_mutex (or just remove
> >    the lock), we solve the root problem:
> > 
> >    nfsd_sync:
> >      [take i_mutex]
> >        filemap_fdatawrite  => can also be blocked, but less a problem
> >      [drop i_mutex]
> >        filemap_fdatawait
> >  
> >    Maybe it's a dumb question, but what's the purpose of i_mutex here?
> >    For correctness or to prevent livelock? I can imagine some livelock
> >    problem here (current implementation can easily wait for extra
> >    pages), however not too hard to fix.
>   Generally, most filesystems take i_mutex during fsync to
> a) avoid all sorts of livelocking problems
> b) serialize fsyncs for one inode (mostly for simplicity)
>   I don't see what advantage would it bring that we get rid of i_mutex
> for fdatawait - only that maybe writers could proceed while we are
> waiting but is that really the problem?

The i_mutex at least has some performance impact. Another one would be
the WB_SYNC_ALL. All are related to the COMMIT/sync write behavior.

Are there some other _direct_ causes?

Thanks,
Fengguang
