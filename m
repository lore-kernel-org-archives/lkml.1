Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYGVXU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYGVXU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbYGVXRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:17:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:57471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993AbYGVXRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:17:53 -0400
Date: Tue, 22 Jul 2008 16:14:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Neil Brown <neilb@suse.de>
Subject: [patch 07/47] md: Dont acknowlege that stripe-expand is complete
	until it really is.
Message-ID: <20080722231438.GH8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-don-t-acknowlege-that-stripe-expand-is-complete-until-it-really-is.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Neil Brown <neilb@notabene.brown>

commit efe311431869b40d67911820a309f9a1a41306f3 upstream

We shouldn't acknowledge that a stripe has been expanded (When
reshaping a raid5 by adding a device) until the moved data has
actually been written out.  However we are currently
acknowledging (by calling md_done_sync) when the POST_XOR
is complete and before the write.

So track in s.locked whether there are pending writes, and don't
call md_done_sync yet if there are.

Note: we all set R5_LOCKED on devices which are are about to
read from.  This probably isn't technically necessary, but is
usually done when writing a block, and justifies the use of
s.locked here.

This bug can lead to a crash if an array is stopped while an reshape
is in progress.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2861,6 +2861,8 @@ static void handle_stripe5(struct stripe
 
 		for (i = conf->raid_disks; i--; ) {
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
+			set_bit(R5_LOCKED, &dev->flags);
+			s.locked++;
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 				sh->ops.count++;
 		}
@@ -2874,6 +2876,7 @@ static void handle_stripe5(struct stripe
 			conf->raid_disks);
 		s.locked += handle_write_operations5(sh, 1, 1);
 	} else if (s.expanded &&
+		   s.locked == 0 &&
 		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);

-- 
