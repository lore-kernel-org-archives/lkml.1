Return-Path: <linux-kernel-owner+w=401wt.eu-S1765385AbYBGAYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765385AbYBGAYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932523AbYBFX7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:59:33 -0500
Received: from mail.suse.de ([195.135.220.2]:46486 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758856AbYBFX7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:59:30 -0500
Date: Wed, 6 Feb 2008 15:54:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Williams <dan.j.williams@intel.com>, Neil Brown <neilb@suse.de>
Subject: [patch 58/73] md: fix data corruption when a degraded raid5 array
	is reshaped
Message-ID: <20080206235403.GG13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-fix-data-corruption-when-a-degraded-raid5-array-is-reshaped.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Dan Williams <dan.j.williams@intel.com>

patch 0f94e87cdeaaac9f0f9a28a5dd2a5070b87cd3e8 in mainline.

We currently do not wait for the block from the missing device to be
computed from parity before copying data to the new stripe layout.

The change in the raid6 code is not techincally needed as we don't delay
data block recovery in the same way for raid6 yet.  But making the change
now is safer long-term.

This bug exists in 2.6.23 and 2.6.24-rc

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2875,7 +2875,8 @@ static void handle_stripe5(struct stripe
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (s.expanding && s.locked == 0)
+	if (s.expanding && s.locked == 0 &&
+	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending))
 		handle_stripe_expansion(conf, sh, NULL);
 
 	if (sh->ops.count)
@@ -3077,7 +3078,8 @@ static void handle_stripe6(struct stripe
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (s.expanding && s.locked == 0)
+	if (s.expanding && s.locked == 0 &&
+	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending))
 		handle_stripe_expansion(conf, sh, &r6s);
 
 	spin_unlock(&sh->lock);

-- 
