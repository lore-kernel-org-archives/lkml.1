Return-Path: <linux-kernel-owner+w=401wt.eu-S934486AbXGRCk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486AbXGRCk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 22:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758847AbXGRCkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 22:40:07 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:2531 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074AbXGRCkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 22:40:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CACIanUarR7MV/2dsb2JhbAA
X-IronPort-AV: i="4.16,548,1175497200"; 
   d="scan'208"; a="386387168:sNHT42473908"
To: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org,
       gregkh@suse.de
Subject: Re: [git patches 1/2] warnings: attack valid cases spotted by warnings
X-Message-Flag: Warning: May contain useful information
References: <20070717214239.GF28448@devserv.devel.redhat.com>
	<ada8x9epuip.fsf@cisco.com> <469D3E66.3010502@garzik.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 17 Jul 2007 19:35:05 -0700
In-Reply-To: <469D3E66.3010502@garzik.org> (Jeff Garzik's message of "Tue, 17 Jul 2007 18:10:46 -0400")
Message-ID: <adamyxuo2w6.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jul 2007 02:35:05.0790 (UTC) FILETIME=[40295DE0:01C7C8E4]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I don't buy that performance argument, in this case.  You are already
 > dirtying the same cacheline with other variable initializations.
 > 
 > Like I noted in the changeset description (hey, this is precisely why
 > I included it, so that we could have this discussion), IMO the flow of
 > control makes it not only impossible for the compiler to understand
 > the full value range of 'f0', but also difficult for humans as well.
 > 
 > I could perhaps understand initializing the variable to some poison
 > value rather than zero, but IMO the code is stronger with f0 set to a
 > sane value.

The more I think about it, the less sense initializing f0 to 0 makes.
The whole problem with an uninitialized variable is that a random
value from the stack might be used.  So setting a variable to
something meaningless (guaranteeing that a garbage value is used in
case of a bug) just to shut up a warning makes no sense -- it's no
safer than leaving the code as is.  uninitialized_var() gets rid of
the warning, saves a little text and instruction cache, and documents
things better.

(BTW, I agree the code is a little confusing as written.  I think
things could be cleaned up and made more efficient by getting rid of
the initialization of size0 too -- I'll look at doing that)

Anyway, I queued this up for my next merge with Linus:

commit 6d7d080e9f7cd535a8821efd3835c5cfa5223ab6
Author: Roland Dreier <rolandd@cisco.com>
Date:   Tue Jul 17 19:30:51 2007 -0700

    IB/mthca: Use uninitialized_var() for f0
    
    Commit 9db48926 ("drivers/infiniband/hw/mthca/mthca_qp: kill uninit'd
    var warning") added "= 0" to the declarations of f0 to shut up gcc
    warnings.  However, there's no point in making the code bigger by
    initializing f0 to a random value just to get rid of a warning;
    setting f0 to 0 is no safer than just using uninitialized_var(), which
    documents the situation better and gives smaller code too.  For example,
    on x86_64:
    
    add/remove: 0/0 grow/shrink: 0/2 up/down: 0/-16 (-16)
    function                                     old     new   delta
    mthca_tavor_post_send                       1352    1344      -8
    mthca_arbel_post_send                       1489    1481      -8
    
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index 11f1d99..0e9ef24 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -1591,7 +1591,13 @@ int mthca_tavor_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	int i;
 	int size;
 	int size0 = 0;
-	u32 f0 = 0;
+	/*
+	 * f0 is only used if nreq != 0, and f0 will be initialized
+	 * the first time through the main loop, since size0 == 0 the
+	 * first time through.  So nreq cannot become non-zero without
+	 * initializing f0, and f0 is in fact never used uninitialized.
+	 */
+	u32 uninitialized_var(f0);
 	int ind;
 	u8 op0 = 0;
 
@@ -1946,7 +1952,13 @@ int mthca_arbel_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	int i;
 	int size;
 	int size0 = 0;
-	u32 f0 = 0;
+	/*
+	 * f0 is only used if nreq != 0, and f0 will be initialized
+	 * the first time through the main loop, since size0 == 0 the
+	 * first time through.  So nreq cannot become non-zero without
+	 * initializing f0, and f0 is in fact never used uninitialized.
+	 */
+	u32 uninitialized_var(f0);
 	int ind;
 	u8 op0 = 0;
 
