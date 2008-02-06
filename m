Return-Path: <linux-kernel-owner+w=401wt.eu-S1764127AbYBFXz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764127AbYBFXz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763587AbYBFXyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:54:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:59744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763525AbYBFXx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:53:59 -0500
Date: Wed, 6 Feb 2008 15:50:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, dm-crypt@saout.de, dm-devel@redhat.com,
       Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [patch 03/73] dm crypt: fix write endio
Message-ID: <20080206235055.GD13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-crypt-fix-write-endio.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Milan Broz <mbroz@redhat.com>

patch adfe47702c4726b3e045f9f83178def02833be4c in mainline.

Fix BIO_UPTODATE test for write io.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-crypt.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -515,6 +515,9 @@ static int crypt_endio(struct bio *clone
 	struct crypt_config *cc = io->target->private;
 	unsigned read_io = bio_data_dir(clone) == READ;
 
+	if (unlikely(!bio_flagged(clone, BIO_UPTODATE) && !error))
+		error = -EIO;
+
 	/*
 	 * free the processed pages, even if
 	 * it's only a partially completed write
@@ -529,10 +532,8 @@ static int crypt_endio(struct bio *clone
 	if (!read_io)
 		goto out;
 
-	if (unlikely(!bio_flagged(clone, BIO_UPTODATE))) {
-		error = -EIO;
+	if (unlikely(error))
 		goto out;
-	}
 
 	bio_put(clone);
 	io->post_process = 1;

-- 
