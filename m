Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbXGZNXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbXGZNXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 09:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbXGZNX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 09:23:28 -0400
Received: from pat.uio.no ([129.240.10.15]:42896 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbXGZNX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 09:23:27 -0400
Subject: Re: [patch] nfs: fix locking in nfs/inode.c in
	nfs_free_open_context
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christian Krafft <krafft@de.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20070726144433.080126f7@localhost>
References: <20070725170837.5fba5fd1@localhost>
	 <1185384502.6585.97.camel@localhost> <200707261323.38310.arnd@arndb.de>
	 <20070726144433.080126f7@localhost>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 09:23:23 -0400
Message-Id: <1185456203.6585.180.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.093)
X-UiO-Scanned: EFB12C1813D48FFCEEF21A0E0067C15DDE0B4B6C
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 364 total 2978186 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 14:44 +0200, Christian Krafft wrote:
> On Thu, 26 Jul 2007 13:23:37 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Wednesday 25 July 2007, Trond Myklebust wrote:
> > > 
> > > On Wed, 2007-07-25 at 17:08 +0200, Christian Krafft wrote:
> > > 
> > > > Obviously the locking code in nfs_free_open_context is wrong.
> > > > Checking the list for entries and removing the entry should be an atomic operation.
> > > 
> > > Wrong. It is quite safe to test the structure member ctx->list for
> > > emptiness outside the spinlock because we have an explicit guarantee
> > > that nobody else has a reference to this structure, plus the
> > > atomic_dec_and_test() in kref_put() has acted as a memory barrier for
> > > us.
> > 
> > Well, the real question then is how the ctx can still be present in the
> > nfsi->open_files list. Since we are in nfs_free_open_context(), there
> > must not be any pointer to the ctx anywhere, but still we have this other
> > thread calling get_nfs_open_context() on it.
> > 
> > 	Arnd <><
> 
> Thanks for the pointer Arnd,
> 
> Trond, does the patch below look better to you ?

No. That is still incorrect. The list of open contexts is used for
things like NFSv4 state recovery (when we're doing background writes,
and the server happens to reboot). The lifetime of the open context may
exceed that of the struct file that created it.

Trond

