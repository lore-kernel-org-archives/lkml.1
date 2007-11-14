Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbXKNWTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbXKNWTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbXKNWS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:18:58 -0500
Received: from pat.uio.no ([129.240.10.15]:39232 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927AbXKNWS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:18:56 -0500
Subject: Re: [PATCH 3/3] nfs: use ->mmap_prepare() to avoid an AB-BA
	deadlock
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <1195077034.22457.6.camel@lappy>
References: <20071114200136.009242000@chello.nl>
	 <20071114201528.514434000@chello.nl> <20071114212246.GA31048@wotan.suse.de>
	 <1195075905.22457.3.camel@lappy>
	 <1195076485.7584.66.camel@heimdal.trondhjem.org>
	 <1195077034.22457.6.camel@lappy>
Content-Type: text/plain
Date: Wed, 14 Nov 2007 17:18:50 -0500
Message-Id: <1195078730.7584.86.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, AWL=0.016)
X-UiO-Scanned: 128A976AE94233D4B54E35300092F9390F7A4FA5
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 300 total 5137304 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-14 at 22:50 +0100, Peter Zijlstra wrote:
> Right, but I guess what Nick asked is, if pages could be stale to start
> with, how is that avoided in the future.
> 
> The way I understand it, this re-validate is just a best effort at
> getting a coherent image.

The normal convention for NFS is to use a close-to-open cache
consistency model. In that model, applications must agree never to open
the file for reading or writing if an application on a different NFS
client already holds it open for writing.

However there is no standard locking model for _enforcing_ such an
agreement, so some setups do violate it. One obvious model that we try
to support is that where the applications are using POSIX locking in
order to ensure exclusive access to the data when requires.

Another model is to rely rather on synchronous writes and heavy
attribute revalidation to detect when a competing application has
written to the file (the 'noac' mount option). While such a model is
obviously deficient in that it can never guarantee cache coherency, we
do attempt to ensure that it works on a per-operation basis (IOW: we
check cache coherency before each call to read(), to mmap(), etc) since
it is by far the easiest model to apply if you have applications that
cannot be rewritten and that satisfy the requirement that they rarely
conflict.

Cheers
  Trond

