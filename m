Return-Path: <linux-kernel-owner+w=401wt.eu-S935412AbXHGXOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935412AbXHGXOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 19:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbXHGXOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 19:14:35 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49475 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbXHGXOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 19:14:34 -0400
Date: Wed, 8 Aug 2007 03:14:37 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>,
       Johannes Berg <johannes@sipsolutions.net>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [NFS] 2.6.23-rc1-mm2
Message-ID: <20070807231437.GA1004@tv-sign.ru>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <200708031301.01569.marc.dietrich@ap.physik.uni-giessen.de> <20070803093830.39852a01.akpm@linux-foundation.org> <1186160608.7255.10.camel@localhost> <20070803172137.GA3783@tv-sign.ru> <1186520929.6625.12.camel@heimdal.trondhjem.org> <20070807213749.GA461@tv-sign.ru> <1186524314.6625.29.camel@heimdal.trondhjem.org> <20070807222042.GA553@tv-sign.ru> <1186528107.6625.71.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186528107.6625.71.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07, Trond Myklebust wrote:
>
> On Wed, 2007-08-08 at 02:20 +0400, Oleg Nesterov wrote:
> 
> > But. nfs4_renew_state() checks list_empty(&clp->cl_superblocks) under
> > clp->cl_sem? So, if it is possible that clp->cl_renewd was scheduled
> > at the time when nfs4_kill_renewd(), we can deadlock, no? Because
> > nfs4_renew_state() needs clp->cl_sem to complete, but nfs4_kill_renewd()
> > holds this sem, and waits for nfs4_renew_state() completion.
> 
> They both take read locks,

Aaaaaaaaaah. Please ignore me, thanks!

> which means that they can take them
> simultaneously. AFAICS, the deadlock can only occur if something manages
> to insert a request for a write lock after nfs4_kill_renewd() takes its
> read lock, but before nfs4_renew_state() takes its read lock:
> 
> 1) nfs4_kill_renewd()		2) nfs4_renew_state()		3) somebody else
> -------------------             ------------------		-------------
> read lock
> wait on (2) to complete
> 								write lock <waits on (1)>
> 				read lock <waits on (3),
> 					because rw_semaphores
> 					don't allow a read lock
> 					request to jump a write
> 					lock request>
> 
> however as I explained earlier, the only process that can take a write
> lock is the reclaimer daemon, but we _know_ that cannot be running (for
> one thing, the reference count on nfs_client is zero, for the other,
> there are no superblocks).

Oleg.

