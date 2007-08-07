Return-Path: <linux-kernel-owner+w=401wt.eu-S1760404AbXHGXJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404AbXHGXJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 19:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758008AbXHGXI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 19:08:57 -0400
Received: from pat.uio.no ([129.240.10.15]:42416 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758169AbXHGXI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 19:08:56 -0400
Subject: Re: [NFS] 2.6.23-rc1-mm2
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>,
       Johannes Berg <johannes@sipsolutions.net>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070807222042.GA553@tv-sign.ru>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	 <200708031301.01569.marc.dietrich@ap.physik.uni-giessen.de>
	 <20070803093830.39852a01.akpm@linux-foundation.org>
	 <1186160608.7255.10.camel@localhost> <20070803172137.GA3783@tv-sign.ru>
	 <1186520929.6625.12.camel@heimdal.trondhjem.org>
	 <20070807213749.GA461@tv-sign.ru>
	 <1186524314.6625.29.camel@heimdal.trondhjem.org>
	 <20070807222042.GA553@tv-sign.ru>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 19:08:27 -0400
Message-Id: <1186528107.6625.71.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.107)
X-UiO-Scanned: DF0C2614DFEE5410E8E7CE12ACAA4FC80CF1AB72
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 40 total 3142110 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 02:20 +0400, Oleg Nesterov wrote:

> But. nfs4_renew_state() checks list_empty(&clp->cl_superblocks) under
> clp->cl_sem? So, if it is possible that clp->cl_renewd was scheduled
> at the time when nfs4_kill_renewd(), we can deadlock, no? Because
> nfs4_renew_state() needs clp->cl_sem to complete, but nfs4_kill_renewd()
> holds this sem, and waits for nfs4_renew_state() completion.

They both take read locks, which means that they can take them
simultaneously. AFAICS, the deadlock can only occur if something manages
to insert a request for a write lock after nfs4_kill_renewd() takes its
read lock, but before nfs4_renew_state() takes its read lock:

1) nfs4_kill_renewd()		2) nfs4_renew_state()		3) somebody else
-------------------             ------------------		-------------
read lock
wait on (2) to complete
								write lock <waits on (1)>
				read lock <waits on (3),
					because rw_semaphores
					don't allow a read lock
					request to jump a write
					lock request>

however as I explained earlier, the only process that can take a write
lock is the reclaimer daemon, but we _know_ that cannot be running (for
one thing, the reference count on nfs_client is zero, for the other,
there are no superblocks).

Cheers
  Trond

