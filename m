Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbYACXlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbYACXlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYACXk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:40:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:61349 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbYACXky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:40:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,240,1196668800"; 
   d="scan'208";a="313704119"
Subject: Re: [PATCH] md: Fix data corruption when a degraded raid5 array is
	reshaped.
From: Dan Williams <dan.j.williams@intel.com>
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <1199401234.9102.3.camel@dwillia2-linux.ch.intel.com>
References: <20080104094516.19216.patches@notabene>
	 A<1080103224636.19290@suse.de>
	 <1199401234.9102.3.camel@dwillia2-linux.ch.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 03 Jan 2008 16:40:52 -0700
Message-Id: <1199403652.9102.30.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
X-OriginalArrivalTime: 03 Jan 2008 23:40:53.0017 (UTC) FILETIME=[140C4890:01C84E62]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-03 at 16:00 -0700, Williams, Dan J wrote:
> On Thu, 2008-01-03 at 15:46 -0700, NeilBrown wrote:
> > This patch fixes a fairly serious bug in md/raid5 in 2.6.23 and
> 24-rc.
> > It would be great if it cold get into 23.13 and 24.final.
> > Thanks.
> > NeilBrown
> >
> > ### Comments for Changeset
> >
> > We currently do not wait for the block from the missing device
> > to be computed from parity before copying data to the new stripe
> > layout.
> >
> > The change in the raid6 code is not techincally needed as we
> > don't delay data block recovery in the same way for raid6 yet.
> > But making the change now is safer long-term.
> >
> > This bug exists in 2.6.23 and 2.6.24-rc
> >
> > Cc: stable@kernel.org
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Neil Brown <neilb@suse.de>
> >
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> 

On closer look the safer test is:

	!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending).

The 'req_compute' field only indicates that a 'compute_block' operation
was requested during this pass through handle_stripe so that we can
issue a linked chain of asynchronous operations.

---

From: Neil Brown <neilb@suse.de>

md: Fix data corruption when a degraded raid5 array is reshaped.

We currently do not wait for the block from the missing device
to be computed from parity before copying data to the new stripe
layout.

The change in the raid6 code is not techincally needed as we
don't delay data block recovery in the same way for raid6 yet.
But making the change now is safer long-term.

This bug exists in 2.6.23 and 2.6.24-rc

Cc: stable@kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a5aad8c..e8c8157 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2865,7 +2865,8 @@ static void handle_stripe5(struct stripe_head *sh)
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (s.expanding && s.locked == 0)
+	if (s.expanding && s.locked == 0 &&
+	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending))
 		handle_stripe_expansion(conf, sh, NULL);
 
 	if (sh->ops.count)
@@ -3067,7 +3068,8 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (s.expanding && s.locked == 0)
+	if (s.expanding && s.locked == 0 &&
+	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending))
 		handle_stripe_expansion(conf, sh, &r6s);
 
 	spin_unlock(&sh->lock);

