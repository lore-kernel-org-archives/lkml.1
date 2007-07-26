Return-Path: <linux-kernel-owner+w=401wt.eu-S932906AbXGZMhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906AbXGZMhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 08:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbXGZMhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 08:37:36 -0400
Received: from pat.uio.no ([129.240.10.15]:41957 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbXGZMhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 08:37:35 -0400
Subject: Re: [patch] nfs: fix locking in nfs/inode.c in
	nfs_free_open_context
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Krafft <krafft@de.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200707261323.38310.arnd@arndb.de>
References: <20070725170837.5fba5fd1@localhost>
	 <1185384502.6585.97.camel@localhost>  <200707261323.38310.arnd@arndb.de>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 08:37:31 -0400
Message-Id: <1185453451.6585.174.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, AWL=0.018)
X-UiO-Scanned: 6C99B3DC640940634A4706117815A159F0C31BF0
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 449 total 2977580 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 13:23 +0200, Arnd Bergmann wrote:
> On Wednesday 25 July 2007, Trond Myklebust wrote:
> > 
> > On Wed, 2007-07-25 at 17:08 +0200, Christian Krafft wrote:
> > 
> > > Obviously the locking code in nfs_free_open_context is wrong.
> > > Checking the list for entries and removing the entry should be an atomic operation.
> > 
> > Wrong. It is quite safe to test the structure member ctx->list for
> > emptiness outside the spinlock because we have an explicit guarantee
> > that nobody else has a reference to this structure, plus the
> > atomic_dec_and_test() in kref_put() has acted as a memory barrier for
> > us.
> 
> Well, the real question then is how the ctx can still be present in the
> nfsi->open_files list. Since we are in nfs_free_open_context(), there
> must not be any pointer to the ctx anywhere, but still we have this other
> thread calling get_nfs_open_context() on it.

Yup. That is definitely a bug. I wish we had a 'kref_put_and_lock' to
deal with these situations where you want to grab a lock atomically with
the last put. It would make krefs a lot more useful...

Trond

