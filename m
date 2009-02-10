Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbZBJTGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbZBJTGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbZBJTDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:34 -0500
Received: from kroah.org ([198.145.64.141]:53665 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754860AbZBJTDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:33 -0500
Date: Tue, 10 Feb 2009 10:59:58 -0800
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
       alan@lxorguk.ukuu.org.uk, Andre Noll <maan@systemlinux.org>,
       NeilBrown <neilb@suse.de>
Subject: [patch 09/53] md: Fix a bug in linear.c causing which_dev() to
	return the wrong device.
Message-ID: <20090210185958.GJ14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-fix-a-bug-in-linear.c-causing-which_dev-to-return-the-wrong-device.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Andre Noll <maan@systemlinux.org>

commit 852c8bf484a0e17ee27f413ef26e87f522af5607 upstream.

ab5bd5cbc8d4b868378d062eed3d4240930fbb86 introduced the following
bug in linear software raid for large arrays on 32 bit machines:

which_dev() computes the device holding a given sector by shifting
down the sector number to a 32 bit range, dividing by the array
spacing and looking up the resulting index in the hash table of
the array.

Because the computed index might be slightly too small, a loop at
the end of which_dev() increases the index until the given sector
actually falls into the range of the device associated with that index.

The changes of the above mentioned commit caused this loop to check
whether the _index_ rather than the sector number is small enough,
effectively bypassing the loop and thus possibly returning the wrong
device.

As reported by Simon Kirby, this leads to errors such as

	linear_make_request: Sector 2340486136 out of bounds on dev sdi: 156301312 sectors, offset 2109870464

Fix this bug by introducing a local variable for the index so that
the variable containing the passed sector is left unchanged.

Signed-off-by: Andre Noll <maan@systemlinux.org>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/linear.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -25,13 +25,13 @@ static inline dev_info_t *which_dev(mdde
 {
 	dev_info_t *hash;
 	linear_conf_t *conf = mddev_to_conf(mddev);
+	sector_t idx = sector >> conf->sector_shift;
 
 	/*
 	 * sector_div(a,b) returns the remainer and sets a to a/b
 	 */
-	sector >>= conf->sector_shift;
-	(void)sector_div(sector, conf->spacing);
-	hash = conf->hash_table[sector];
+	(void)sector_div(idx, conf->spacing);
+	hash = conf->hash_table[idx];
 
 	while (sector >= hash->num_sectors + hash->start_sector)
 		hash++;

