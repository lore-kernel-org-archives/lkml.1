Return-Path: <linux-kernel-owner+w=401wt.eu-S1422970AbXBATuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422970AbXBATuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 14:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422971AbXBATuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 14:50:35 -0500
Received: from pat.uio.no ([129.240.10.15]:56610 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422970AbXBATue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 14:50:34 -0500
Subject: Re: [PATCH 4 of 4] Introduce aio system call submission and
	completion system calls
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: suparna@in.ibm.com
Cc: Zach Brown <zach.brown@oracle.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20070201111307.GA24723@in.ibm.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	 <p73abzzpo75.fsf@bingen.suse.de>
	 <63FDFD68-EE2B-4BB7-B624-513243B87634@oracle.com>
	 <200701311821.59579.ak@suse.de>
	 <FA06EB13-4BF6-4E3A-B223-6494079F541F@oracle.com>
	 <20070201111307.GA24723@in.ibm.com>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 11:50:06 -0800
Message-Id: <1170359406.6151.55.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 1FCDB80E5C056E3D7DC8749A54D8E2D1E625F789
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 468 total 209682 max/h 1956 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-01 at 16:43 +0530, Suparna Bhattacharya wrote:
> Wooo ...hold on ... I think this is swinging out of perspective :)
> 
> I have said some of this before, but let me try again.
> 
> As you already discovered when going down the fibril path, there are
> two kinds of accesses to current-> state, (1) common state
> for a given call chain (e.g. journal info etc), and (2) for 
> various validations against the caller's process (uid, ulimit etc). 
> 
> (1) is not an issue when it comes to execution in background threads
> (the VFS already uses background writeback for example).
> 
> As for (2), such checks need to happen upfront at the time of IO submission,
> so again are not an issue.

Wrong! These checks can and do occur well after the time of I/O
submission in the case of remote filesystems with asynchronous writeback
support.

Consider, for instance, the cases where the server reboots and loses all
state. Then there is the case of failover and/or migration events, where
the entire filesystem gets moved from one server to another, and again
you may have to recover state, etc...

> I don't see any other reason why IO paths should be assuming that they are
> running in the original caller's context, midway through doing the IO. If
> that were the case background writeouts and readaheads could be fragile as
> well (or ptrace). The reason it isn't is because of this conceptual division of
> responsibility.

The problem with this is that the security context is getting
progressively more heavy as we add more and more features. In addition
to the original uid/gid/fsuid/fsgid/groups, we now have stuff like
keyrings to carry around. Then there is all the context needed to
support selinux,...
In the end, you end up recreating most of struct task_struct...

Cheers
  Trond

