Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbYKLAa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbYKLAa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYKLA0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:17 -0500
Received: from kroah.org ([198.145.64.141]:42198 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753388AbYKLA0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:15 -0500
Date: Tue, 11 Nov 2008 16:23:18 -0800
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
Subject: [patch 13/49] md: linear: Fix a division by zero bug for very
	small arrays.
Message-ID: <20081112002318.GN10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-linear-fix-a-division-by-zero-bug-for-very-small-arrays.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andre Noll <maan@systemlinux.org>

commit f1cd14ae52985634d0389e934eba25b5ecf24565 upstream

Date: Thu, 6 Nov 2008 19:41:24 +1100
Subject: [patch 13/49] md: linear: Fix a division by zero bug for very small arrays.

We currently oops with a divide error on starting a linear software
raid array consisting of at least two very small (< 500K) devices.

The bug is caused by the calculation of the hash table size which
tries to compute sector_div(sz, base) with "base" being zero due to
the small size of the component devices of the array.

Fix this by requiring the hash spacing to be at least one which
implies that also "base" is non-zero.

This bug has existed since about 2.6.14.

Signed-off-by: Andre Noll <maan@systemlinux.org>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/linear.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -157,6 +157,8 @@ static linear_conf_t *linear_conf(mddev_
 
 	min_spacing = conf->array_sectors / 2;
 	sector_div(min_spacing, PAGE_SIZE/sizeof(struct dev_info *));
+	if (min_spacing == 0)
+		min_spacing = 1;
 
 	/* min_spacing is the minimum spacing that will fit the hash
 	 * table in one PAGE.  This may be much smaller than needed.

-- 
