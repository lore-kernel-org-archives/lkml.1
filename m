Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbYJGAsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbYJGAsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbYJGAnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:43:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:46752 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757351AbYJGAnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:43:33 -0400
Date: Mon, 6 Oct 2008 17:38:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 22/71] block: submit_bh() inadvertently discards barrier
	flag on a sync write
Message-ID: <20081007003823.GW3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="block-submit_bh-inadvertently-discards-barrier-flag-on-a-sync-write.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jens Axboe <jens.axboe@oracle.com>

commit 48fd4f93a00eac844678629f2f00518e146ed30d upstream

Reported by Milan Broz <mbroz@redhat.com>, commit 18ce3751 inadvertently
made submit_bh() discard the barrier bit for a WRITE_SYNC request. Fix
that up.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/buffer.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2868,14 +2868,17 @@ int submit_bh(int rw, struct buffer_head
 	BUG_ON(!buffer_mapped(bh));
 	BUG_ON(!bh->b_end_io);
 
-	if (buffer_ordered(bh) && (rw == WRITE))
-		rw = WRITE_BARRIER;
+	/*
+	 * Mask in barrier bit for a write (could be either a WRITE or a
+	 * WRITE_SYNC
+	 */
+	if (buffer_ordered(bh) && (rw & WRITE))
+		rw |= WRITE_BARRIER;
 
 	/*
-	 * Only clear out a write error when rewriting, should this
-	 * include WRITE_SYNC as well?
+	 * Only clear out a write error when rewriting
 	 */
-	if (test_set_buffer_req(bh) && (rw == WRITE || rw == WRITE_BARRIER))
+	if (test_set_buffer_req(bh) && (rw & WRITE))
 		clear_buffer_write_io_error(bh);
 
 	/*

-- 
