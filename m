Return-Path: <linux-kernel-owner+w=401wt.eu-S1759771AbZAMBed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759771AbZAMBed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758199AbZAMB3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:29:10 -0500
Received: from kroah.org ([198.145.64.141]:36052 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758164AbZAMB3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:29:07 -0500
Date: Mon, 12 Jan 2009 17:27:19 -0800
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
       alan@lxorguk.ukuu.org.uk,
       "Stephen M. Cameron" <scameron@beardog.cca.cpqcorp.net>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 14/21] cciss: fix problem that deleting multiple logical
	drives could cause a panic
Message-ID: <20090113012719.GO4512@kroah.com>
References: <20090113012006.063755472@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cciss-fix-problem-that-deleting-multiple-logical-drives-could-cause-a-panic.patch"
In-Reply-To: <20090113012633.GA4512@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

commit d8a0be6ab7ba1ffa43e7ea0dcdde3e8b68d4f762 upstream.

Fix problem that deleting multiple logical drives could cause a panic.

It fixes a panic which can be easily reproduced in the following way: Just
create several "arrays," each with multiple logical drives via hpacucli,
then delete the first array, and it will blow up in deregister_disk(), in
the call to get_host() when it tries to dig the hba pointer out of a NULL
queue pointer.

The problem has been present since my code to make rebuild_lun_table
behave better went in.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/cciss.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1692,6 +1692,11 @@ static int rebuild_lun_table(ctlr_info_t
 	for (i = 0; i <= h->highest_lun; i++) {
 		int j;
 		drv_found = 0;
+
+		/* skip holes in the array from already deleted drives */
+		if (h->drv[i].raid_level == -1)
+			continue;
+
 		for (j = 0; j < num_luns; j++) {
 			memcpy(&lunid, &ld_buff->LUN[j][0], 4);
 			lunid = le32_to_cpu(lunid);

