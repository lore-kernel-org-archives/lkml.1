Return-Path: <linux-kernel-owner+w=401wt.eu-S1760849AbYGaAF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849AbYGaAF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759892AbYGaAFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:05:41 -0400
Received: from ns1.suse.de ([195.135.220.2]:37808 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760493AbYGaAFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:05:40 -0400
Date: Wed, 30 Jul 2008 16:58:00 -0700
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
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Adam Greenblatt <adam.greenblatt@gmail.com>
Subject: [patch 07/62] isofs: fix minor filesystem corruption
Message-ID: <20080730235800.GG12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="isofs-fix-minor-filesystem-corruption.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Adam Greenblatt <adam.greenblatt@gmail.com>

commit c0a1633b6201ef79e31b7da464d44fdf5953054d upstream

Some iso9660 images contain files with rockridge data that is either
incorrect or incompletely parsed.  Prior to commit
f2966632a134e865db3c819346a1dc7d96e05309 ("[PATCH] rock: handle directory
overflows") (included with kernel 2.6.13) the kernel ignored the rockridge
data for these files, while still allowing the files to be accessed under
their non-rockridge names.  That commit inadvertently changed things so
that files with invalid rockridge data could not be accessed at all.  (I
ran across the problem when comparing some old CDs with hard disk copies I
had made long ago under kernel 2.4: a few of the files on the hard disk
copies were no longer visible on the CDs.)

This change reverts to the pre-2.6.13 behavior.

Signed-off-by: Adam Greenblatt <adam.greenblatt@gmail.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/isofs/rock.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -209,6 +209,11 @@ repeat:
 
 	while (rs.len > 2) { /* There may be one byte for padding somewhere */
 		rr = (struct rock_ridge *)rs.chr;
+		/*
+		 * Ignore rock ridge info if rr->len is out of range, but
+		 * don't return -EIO because that would make the file
+		 * invisible.
+		 */
 		if (rr->len < 3)
 			goto out;	/* Something got screwed up here */
 		sig = isonum_721(rs.chr);
@@ -216,8 +221,12 @@ repeat:
 			goto eio;
 		rs.chr += rr->len;
 		rs.len -= rr->len;
+		/*
+		 * As above, just ignore the rock ridge info if rr->len
+		 * is bogus.
+		 */
 		if (rs.len < 0)
-			goto eio;	/* corrupted isofs */
+			goto out;	/* Something got screwed up here */
 
 		switch (sig) {
 		case SIG('R', 'R'):
@@ -307,6 +316,11 @@ parse_rock_ridge_inode_internal(struct i
 repeat:
 	while (rs.len > 2) { /* There may be one byte for padding somewhere */
 		rr = (struct rock_ridge *)rs.chr;
+		/*
+		 * Ignore rock ridge info if rr->len is out of range, but
+		 * don't return -EIO because that would make the file
+		 * invisible.
+		 */
 		if (rr->len < 3)
 			goto out;	/* Something got screwed up here */
 		sig = isonum_721(rs.chr);
@@ -314,8 +328,12 @@ repeat:
 			goto eio;
 		rs.chr += rr->len;
 		rs.len -= rr->len;
+		/*
+		 * As above, just ignore the rock ridge info if rr->len
+		 * is bogus.
+		 */
 		if (rs.len < 0)
-			goto eio;	/* corrupted isofs */
+			goto out;	/* Something got screwed up here */
 
 		switch (sig) {
 #ifndef CONFIG_ZISOFS		/* No flag for SF or ZF */

-- 
