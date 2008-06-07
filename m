Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbYFGBNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbYFGBNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760018AbYFGBJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:04 -0400
Received: from sous-sol.org ([216.99.217.87]:42383 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760733AbYFGBJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:01 -0400
Message-Id: <20080607010636.182581291@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:03:03 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Williams <dan.j.williams@intel.com>, Neil Brown <neilb@suse.de>
Subject: [patch 48/50] md: fix prexor vs sync_request race
Content-Disposition: inline; filename=md-fix-prexor-vs-sync_request-race.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dan Williams <dan.j.williams@intel.com>

upstream commit: e0a115e5aa554b93150a8dc1c3fe15467708abb2

During the initial array synchronization process there is a window between
when a prexor operation is scheduled to a specific stripe and when it
completes for a sync_request to be scheduled to the same stripe.  When
this happens the prexor completes and the stripe is unconditionally marked
"insync", effectively canceling the sync_request for the stripe.  Prior to
2.6.23 this was not a problem because the prexor operation was done under
sh->lock.  The effect in older kernels being that the prexor would still
erroneously mark the stripe "insync", but sync_request would be held off
and re-mark the stripe as "!in_sync".

Change the write completion logic to not mark the stripe "in_sync" if a
prexor was performed.  The effect of the change is to sometimes not set
STRIPE_INSYNC.  The worst this can do is cause the resync to stall waiting
for STRIPE_INSYNC to be set.  If this were happening, then STRIPE_SYNCING
would be set and handle_issuing_new_read_requests would cause all
available blocks to eventually be read, at which point prexor would never
be used on that stripe any more and STRIPE_INSYNC would eventually be set.

echo repair > /sys/block/mdN/md/sync_action will correct arrays that may
have lost this race.

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[chrisw: backport to 2.6.25.5]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/raid5.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2621,6 +2621,7 @@ static void handle_stripe5(struct stripe
 	struct stripe_head_state s;
 	struct r5dev *dev;
 	unsigned long pending = 0;
+	int prexor;
 
 	memset(&s, 0, sizeof(s));
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d "
@@ -2740,9 +2741,11 @@ static void handle_stripe5(struct stripe
 	/* leave prexor set until postxor is done, allows us to distinguish
 	 * a rmw from a rcw during biodrain
 	 */
+	prexor = 0;
 	if (test_bit(STRIPE_OP_PREXOR, &sh->ops.complete) &&
 		test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete)) {
 
+		prexor = 1;
 		clear_bit(STRIPE_OP_PREXOR, &sh->ops.complete);
 		clear_bit(STRIPE_OP_PREXOR, &sh->ops.ack);
 		clear_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
@@ -2776,6 +2779,8 @@ static void handle_stripe5(struct stripe
 				if (!test_and_set_bit(
 				    STRIPE_OP_IO, &sh->ops.pending))
 					sh->ops.count++;
+				if (prexor)
+					continue;
 				if (!test_bit(R5_Insync, &dev->flags) ||
 				    (i == sh->pd_idx && s.failed == 0))
 					set_bit(STRIPE_INSYNC, &sh->state);

-- 
