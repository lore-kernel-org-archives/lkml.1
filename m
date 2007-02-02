Return-Path: <linux-kernel-owner+w=401wt.eu-S1422979AbXBBHOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422979AbXBBHOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 02:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422971AbXBBHOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 02:14:05 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36335 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422973AbXBBHOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 02:14:02 -0500
Date: Fri, 2 Feb 2007 12:49:16 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Zach Brown <zach.brown@oracle.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4 of 4] Introduce aio system call submission and completion system calls
Message-ID: <20070202071916.GA17449@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <patchbomb.1170193181@tetsuo.zabbo.net> <p73abzzpo75.fsf@bingen.suse.de> <63FDFD68-EE2B-4BB7-B624-513243B87634@oracle.com> <200701311821.59579.ak@suse.de> <FA06EB13-4BF6-4E3A-B223-6494079F541F@oracle.com> <20070201111307.GA24723@in.ibm.com> <1170359406.6151.55.camel@lade.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170359406.6151.55.camel@lade.trondhjem.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 11:50:06AM -0800, Trond Myklebust wrote:
> On Thu, 2007-02-01 at 16:43 +0530, Suparna Bhattacharya wrote:
> > Wooo ...hold on ... I think this is swinging out of perspective :)
> > 
> > I have said some of this before, but let me try again.
> > 
> > As you already discovered when going down the fibril path, there are
> > two kinds of accesses to current-> state, (1) common state
> > for a given call chain (e.g. journal info etc), and (2) for 
> > various validations against the caller's process (uid, ulimit etc). 
> > 
> > (1) is not an issue when it comes to execution in background threads
> > (the VFS already uses background writeback for example).
> > 
> > As for (2), such checks need to happen upfront at the time of IO submission,
> > so again are not an issue.
> 
> Wrong! These checks can and do occur well after the time of I/O
> submission in the case of remote filesystems with asynchronous writeback
> support.
> 
> Consider, for instance, the cases where the server reboots and loses all
> state. Then there is the case of failover and/or migration events, where
> the entire filesystem gets moved from one server to another, and again
> you may have to recover state, etc...
> 
> > I don't see any other reason why IO paths should be assuming that they are
> > running in the original caller's context, midway through doing the IO. If
> > that were the case background writeouts and readaheads could be fragile as
> > well (or ptrace). The reason it isn't is because of this conceptual division of
> > responsibility.
> 
> The problem with this is that the security context is getting
> progressively more heavy as we add more and more features. In addition
> to the original uid/gid/fsuid/fsgid/groups, we now have stuff like
> keyrings to carry around. Then there is all the context needed to
> support selinux,...

Isn't that kind of information supposed to be captured in nfs_open_context ?
Which is associated with the open file instance ...

I know this has been a traditional issue with network filesystems, and I
haven't kept up with the latest code and decisions in that respect, but how
would you do background writeback if there is an assumption of running in
the context of the original submitter ?

Regards
Suparna

> In the end, you end up recreating most of struct task_struct...
> 
> Cheers
>   Trond
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-aio' in
> the body to majordomo@kvack.org.  For more info on Linux AIO,
> see: http://www.kvack.org/aio/
> Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

