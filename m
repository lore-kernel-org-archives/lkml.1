Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbYD2SxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbYD2SxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762162AbYD2SvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:51:01 -0400
Received: from mail.suse.de ([195.135.220.2]:51583 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762118AbYD2Su7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:50:59 -0400
Date: Tue, 29 Apr 2008 11:49:39 -0700
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
       Martin Creutziger <martin.creutziger@barco.com>,
       Damir Shayhutdinov <lost404@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: [07/12] JFFS2: Fix free space leak with in-band cleanmarkers
Message-ID: <20080429184939.GH24199@suse.de>
References: <20080429184543.308594866@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="jffs2-fix-free-space-leak-with-in-band-cleanmarkers.patch"
In-Reply-To: <20080429184911.GA24199@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

We were accounting for the cleanmarker by calling jffs2_link_node_ref()
(without locking!), which adjusted both superblock and per-eraseblock
accounting, subtracting the size of the cleanmarker from {jeb,c}->free_size
and adding it to {jeb,c}->used_size.

But only _then_ were we adding the size of the newly-erased block back
to the superblock counts, and we were adding each of jeb->{free,used}_size
to the corresponding superblock counts. Thus, the size of the cleanmarker
was effectively subtracted from the superblock's free_size _twice_.

Fix this, by always adding a full eraseblock size to c->free_size when
we've erased a block. And call jffs2_link_node_ref() under the proper
lock, while we're at it.

Thanks to Alexander Yurchenko and/or Damir Shayhutdinov for (almost)
pinpointing the problem.

[Backport of commit 014b164e1392a166fe96e003d2f0e7ad2e2a0bb7]

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jffs2/erase.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/fs/jffs2/erase.c
+++ b/fs/jffs2/erase.c
@@ -419,9 +419,6 @@ static void jffs2_mark_erased_block(stru
 			if (jffs2_write_nand_cleanmarker(c, jeb))
 				goto filebad;
 		}
-
-		/* Everything else got zeroed before the erase */
-		jeb->free_size = c->sector_size;
 	} else {
 
 		struct kvec vecs[1];
@@ -449,18 +446,19 @@ static void jffs2_mark_erased_block(stru
 
 			goto filebad;
 		}
-
-		/* Everything else got zeroed before the erase */
-		jeb->free_size = c->sector_size;
-		/* FIXME Special case for cleanmarker in empty block */
-		jffs2_link_node_ref(c, jeb, jeb->offset | REF_NORMAL, c->cleanmarker_size, NULL);
 	}
+	/* Everything else got zeroed before the erase */
+	jeb->free_size = c->sector_size;
 
 	down(&c->erase_free_sem);
 	spin_lock(&c->erase_completion_lock);
+
 	c->erasing_size -= c->sector_size;
-	c->free_size += jeb->free_size;
-	c->used_size += jeb->used_size;
+	c->free_size += c->sector_size;
+
+	/* Account for cleanmarker now, if it's in-band */
+	if (c->cleanmarker_size && !jffs2_cleanmarker_oob(c))
+		jffs2_link_node_ref(c, jeb, jeb->offset | REF_NORMAL, c->cleanmarker_size, NULL);
 
 	jffs2_dbg_acct_sanity_check_nolock(c,jeb);
 	jffs2_dbg_acct_paranoia_check_nolock(c, jeb);

-- 
