Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbYACWqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbYACWqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 17:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYACWqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 17:46:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38072 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbYACWqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 17:46:45 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 4 Jan 2008 09:46:36 +1100
Message-Id: <1080103224636.19290@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: stable@kernel.org
Subject: [PATCH] md: Fix data corruption when a degraded raid5 array is reshaped.
References: <20080104094516.19216.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a fairly serious bug in md/raid5 in 2.6.23 and 24-rc.
It would be great if it cold get into 23.13 and 24.final.
Thanks.
NeilBrown

### Comments for Changeset

We currently do not wait for the block from the missing device
to be computed from parity before copying data to the new stripe
layout.

The change in the raid6 code is not techincally needed as we
don't delay data block recovery in the same way for raid6 yet.
But making the change now is safer long-term.

This bug exists in 2.6.23 and 2.6.24-rc

Cc: stable@kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-01-04 09:42:05.000000000 +1100
+++ ./drivers/md/raid5.c	2008-01-04 09:42:27.000000000 +1100
@@ -2865,7 +2865,7 @@ static void handle_stripe5(struct stripe
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (s.expanding && s.locked == 0)
+	if (s.expanding && s.locked == 0 && s.req_compute == 0)
 		handle_stripe_expansion(conf, sh, NULL);
 
 	if (sh->ops.count)
@@ -3067,7 +3067,7 @@ static void handle_stripe6(struct stripe
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (s.expanding && s.locked == 0)
+	if (s.expanding && s.locked == 0 && s.req_compute == 0)
 		handle_stripe_expansion(conf, sh, &r6s);
 
 	spin_unlock(&sh->lock);
