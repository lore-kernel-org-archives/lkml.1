Return-Path: <linux-kernel-owner+w=401wt.eu-S1759657AbZBKAoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657AbZBKAoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757879AbZBKA2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:50 -0500
Received: from kroah.org ([198.145.64.141]:51557 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756344AbZBKA2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:47 -0500
Date: Tue, 10 Feb 2009 16:25:48 -0800
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
       alan@lxorguk.ukuu.org.uk, Chandra Seetharaman <sekharan@us.ibm.com>,
       Alasdair G Kergon <agk@redhat.com>, Hannes Reinecke <hare@suse.de>
Subject: [patch 45/56] dm mpath: avoid attempting to activate null path
Message-ID: <20090211002548.GT14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-mpath-avoid-attempting-to-activate-null-path.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Chandra Seetharaman <sekharan@us.ibm.com>

commit b81aa1c79201cb424114fd198607951900babe18 upstream.

Path activation code is called even when the pgpath is NULL. This could
lead to a panic in activate_path(). Such a panic is seen in -rt kernel.

This problem has been there before the pg_init() was moved to a
workqueue.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-mpath.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -427,13 +427,13 @@ static void process_queued_ios(struct wo
 		__choose_pgpath(m);
 
 	pgpath = m->current_pgpath;
-	m->pgpath_to_activate = m->current_pgpath;
 
 	if ((pgpath && !m->queue_io) ||
 	    (!pgpath && !m->queue_if_no_path))
 		must_queue = 0;
 
-	if (m->pg_init_required && !m->pg_init_in_progress) {
+	if (m->pg_init_required && !m->pg_init_in_progress && pgpath) {
+		m->pgpath_to_activate = pgpath;
 		m->pg_init_count++;
 		m->pg_init_required = 0;
 		m->pg_init_in_progress = 1;

