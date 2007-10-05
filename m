Return-Path: <linux-kernel-owner+w=401wt.eu-S1760911AbXJERuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911AbXJERuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 13:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758022AbXJERuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 13:50:32 -0400
Received: from pat.uio.no ([129.240.10.15]:43656 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763AbXJERub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 13:50:31 -0400
Subject: Re: [PATCH] remove throttle_vm_writeout()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       wfg@mail.ustc.edu.cn, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1191581854.22357.85.camel@twins>
References: <E1IdPla-0002Bd-00@dorka.pomaz.szeredi.hu>
	 <20071004145640.18ced770.akpm@linux-foundation.org>
	 <E1IdZLg-0002Wr-00@dorka.pomaz.szeredi.hu>
	 <20071004160941.e0c0c7e5.akpm@linux-foundation.org>
	 <E1Ida56-0002Zz-00@dorka.pomaz.szeredi.hu>
	 <20071004164801.d8478727.akpm@linux-foundation.org>
	 <E1Idanu-0002c1-00@dorka.pomaz.szeredi.hu>
	 <20071004174851.b34a3220.akpm@linux-foundation.org>
	 <1191572520.22357.42.camel@twins>
	 <E1IdjOa-0002qg-00@dorka.pomaz.szeredi.hu>
	 <1191577623.22357.69.camel@twins>
	 <E1IdkOf-0002tK-00@dorka.pomaz.szeredi.hu>
	 <1191581854.22357.85.camel@twins>
Content-Type: text/plain
Date: Fri, 05 Oct 2007 13:50:00 -0400
Message-Id: <1191606600.6715.94.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.084)
X-UiO-Scanned: A5C519C632382B00C3E6E966C40F78E4C24B1C5D
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 458 total 4316927 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-05 at 12:57 +0200, Peter Zijlstra wrote:
> In this patch I totally ignored unstable, but I'm not sure that's the
> proper thing to do, I'd need to figure out what happens to an unstable
> page when passed into pageout() - or if its passed to pageout at all.
> 
> If unstable pages would be passed to pageout(), and it would properly
> convert them to writeback and clean them, then there is nothing wrong.

Why would we want to do that? That would be a hell of a lot of work
(locking pages, setting flags, unlocking pages, ...) for absolutely no
reason.

Unstable writes are writes which have been sent to the server, but which
haven't been written to disk on the server. A single RPC command is then
sent (COMMIT) which basically tells the server to call fsync(). After
that is successful, we can free up the pages, but we do that with no
extra manipulation of the pages themselves: no page locks, just removal
from the NFS private radix tree, and freeing up of the NFS private
structures.

We only need to touch the pages again in the unlikely case that the
COMMIT fails because the server has rebooted. In this case we have to
resend the writes, and so the pages are marked as dirty, so we can go
through the whole writepages() rigmarole again...

So, no. I don't see sending pages through pageout() as being at all
helpful.

Trond

