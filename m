Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbZDVMkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbZDVMkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 08:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZDVMkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 08:40:12 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36185 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbZDVMkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 08:40:10 -0400
Date: Wed, 22 Apr 2009 14:40:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block bits for 2.6.30-rc3
Message-ID: <20090422124009.GG4593@kernel.dk>
References: <20090422120355.GD4593@kernel.dk> <20090422123109.GA22631@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422123109.GA22631@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22 2009, Damien Wyart wrote:
> Hello,
> 
> > A collection of fixes for 2.6.30-rc3. It includes fixes for
> > regressions and bug fixes in general, along with two buglets in CFQ.
> > Please pull.
> 
> What about this bug in CFQ: http://lkml.org/lkml/2009/4/20/68 ?
> 
> Do you plan to have it fixed for 2.6.30 or will it wait until 2.6.31?

Not sure. In theory we could just do the one-liner and make
->slice_resid negative (like below), but it needs some targetted
testing. And given that it's been there for several releases, it's not
really a rush to get it fixed for 2.6.30.

But I'll definitely throw it into the testing mix, and if deemed safe
enough, get it in there for 2.6.30.

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7e13f04..17549f7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -887,7 +887,7 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	 * store what was left of this slice, if the queue idled/timed out
 	 */
 	if (timed_out && !cfq_cfqq_slice_new(cfqq)) {
-		cfqq->slice_resid = cfqq->slice_end - jiffies;
+		cfqq->slice_resid = jiffies - cfqq->slice_end;
 		cfq_log_cfqq(cfqd, cfqq, "resid=%ld", cfqq->slice_resid);
 	}
 

-- 
Jens Axboe

