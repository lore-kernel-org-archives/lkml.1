Return-Path: <linux-kernel-owner+w=401wt.eu-S934526AbXGYR27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934526AbXGYR27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933086AbXGYR2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:28:30 -0400
Received: from pat.uio.no ([129.240.10.15]:41696 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682AbXGYR23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:28:29 -0400
Subject: Re: [patch] nfs: fix locking in nfs/inode.c in
	nfs_free_open_context
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christian Krafft <krafft@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070725170837.5fba5fd1@localhost>
References: <20070725170837.5fba5fd1@localhost>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 13:28:22 -0400
Message-Id: <1185384502.6585.97.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.104)
X-UiO-Scanned: A2AC0103E329E23C0CD73CAEC8060C1AB9FA86CF
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 226 total 2968963 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 17:08 +0200, Christian Krafft wrote:

> Obviously the locking code in nfs_free_open_context is wrong.
> Checking the list for entries and removing the entry should be an atomic operation.

Wrong. It is quite safe to test the structure member ctx->list for
emptiness outside the spinlock because we have an explicit guarantee
that nobody else has a reference to this structure, plus the
atomic_dec_and_test() in kref_put() has acted as a memory barrier for
us.

> Also list_del_init should be used, because list_del will leave the empty list in
> an undefined condition.

Huh? We're freeing the context. It will _never_ _ever_ _ever_ be used
again. If anything tries to use ctx->list after this, then that is a
major bug.

Patch rejected...

Trond

