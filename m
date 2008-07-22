Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbYGVX06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbYGVX06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbYGVXTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:19:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57811 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757125AbYGVXTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:19:43 -0400
Date: Tue, 22 Jul 2008 16:16:22 -0700
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
       Dan Williams <dan.j.williams@intel.com>, Neil Brown <neilb@suse.de>
Subject: [patch 26/47] md: ensure all blocks are uptodate or locked when
	syncing
Message-ID: <20080722231622.GA8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-ensure-all-blocks-are-uptodate-or-locked-when-syncing.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Dan Williams <dan.j.williams@intel.com>

commit 7a1fc53c5adb910751a9b212af90302eb4ffb527 upstream

Remove the dubious attempt to prefer 'compute' over 'read'.  Not only is it
wrong given commit c337869d (md: do not compute parity unless it is on a failed
drive), but it can trigger a BUG_ON in handle_parity_checks5().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1999,12 +1999,7 @@ static int __handle_issuing_new_read_req
 			 */
 			s->uptodate++;
 			return 0; /* uptodate + compute == disks */
-		} else if ((s->uptodate < disks - 1) &&
-			test_bit(R5_Insync, &dev->flags)) {
-			/* Note: we hold off compute operations while checks are
-			 * in flight, but we still prefer 'compute' over 'read'
-			 * hence we only read if (uptodate < * disks-1)
-			 */
+		} else if (test_bit(R5_Insync, &dev->flags)) {
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantread, &dev->flags);
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))

-- 
