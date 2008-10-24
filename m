Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbYJXEnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbYJXEnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYJXEjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:20 -0400
Received: from kroah.org ([198.145.64.141]:51755 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751854AbYJXEjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:16 -0400
Date: Thu, 23 Oct 2008 21:34:27 -0700
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
       alan@lxorguk.ukuu.org.uk, Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 12/27] dm exception store: fix misordered writes
Message-ID: <20081024043427.GM30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-exception-store-fix-misordered-writes.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Mikulas Patocka <mpatocka@redhat.com>

commit 7acedc5b98a2fcff64f00c21110aae7d3ac2f7df upstream

We must zero the next chunk on disk *before* writing out the current chunk, not
after.  Otherwise if the machine crashes at the wrong time, the "end of metadata"
marker may be missing.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-exception-store.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -603,17 +603,22 @@ static void persistent_commit(struct exc
 		return;
 
 	/*
+	 * If we completely filled the current area, then wipe the next one.
+	 */
+	if ((ps->current_committed == ps->exceptions_per_area) &&
+	     zero_disk_area(ps, ps->current_area + 1))
+		ps->valid = 0;
+
+	/*
 	 * Commit exceptions to disk.
 	 */
-	if (area_io(ps, WRITE))
+	if (ps->valid && area_io(ps, WRITE))
 		ps->valid = 0;
 
 	/*
 	 * Advance to the next area if this one is full.
 	 */
 	if (ps->current_committed == ps->exceptions_per_area) {
-		if (zero_disk_area(ps, ps->current_area + 1))
-			ps->valid = 0;
 		ps->current_committed = 0;
 		ps->current_area++;
 		zero_memory_area(ps);

-- 
