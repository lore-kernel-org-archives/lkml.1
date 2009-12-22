Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbZLVMfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbZLVMfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 07:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZLVMfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 07:35:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48117 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZLVMfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 07:35:40 -0500
Date: Tue, 22 Dec 2009 13:35:39 +0100
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Steve Rago <sar@nec-labs.com>, Peter Zijlstra <peterz@infradead.org>,
       "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Trond.Myklebust@netapp.com" <Trond.Myklebust@netapp.com>,
       "jens.axboe" <jens.axboe@oracle.com>,
       Peter Staubach <staubach@redhat.com>, Jan Kara <jack@suse.cz>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] improve the performance of large sequential write NFS workloads
Message-ID: <20091222123538.GB604@atrey.karlin.mff.cuni.cz>
References: <1261015420.1947.54.camel@serenity> <1261037877.27920.36.camel@laptop> <20091219122033.GA11360@localhost> <1261232747.1947.194.camel@serenity> <20091222015907.GA6223@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091222015907.GA6223@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2) NFS commit stops pipeline because it sleep&wait inside i_mutex,
>    which blocks all other NFSDs trying to write/writeback the inode.
> 
>    nfsd_sync:
>      take i_mutex
>        filemap_fdatawrite
>        filemap_fdatawait
>      drop i_mutex
  I believe this is unrelated to the problem Steve is trying to solve.
When we get to doing sync writes the performance is busted so we better
shouldn't get to that (unless user asked for that of course).

>    If filemap_fdatawait() can be moved out of i_mutex (or just remove
>    the lock), we solve the root problem:
> 
>    nfsd_sync:
>      [take i_mutex]
>        filemap_fdatawrite  => can also be blocked, but less a problem
>      [drop i_mutex]
>        filemap_fdatawait
>  
>    Maybe it's a dumb question, but what's the purpose of i_mutex here?
>    For correctness or to prevent livelock? I can imagine some livelock
>    problem here (current implementation can easily wait for extra
>    pages), however not too hard to fix.
  Generally, most filesystems take i_mutex during fsync to
a) avoid all sorts of livelocking problems
b) serialize fsyncs for one inode (mostly for simplicity)
  I don't see what advantage would it bring that we get rid of i_mutex
for fdatawait - only that maybe writers could proceed while we are
waiting but is that really the problem?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
