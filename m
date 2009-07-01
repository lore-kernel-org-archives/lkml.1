Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbZGAAiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbZGAAiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759979AbZGAAab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:30:31 -0400
Received: from kroah.org ([198.145.64.141]:34404 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759920AbZGAAaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:30:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:04:01 2009
Message-Id: <20090701000400.977850179@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:00:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 29/30] dm mpath: validate table argument count
References: <20090630235944.868879272@mini.kroah.org>
Content-Disposition: inline; filename=dm-mpath-validate-table-argument-count.patch
In-Reply-To: <20090701002817.GA6156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 0e0497c0c017664994819f4602dc07fd95896c52 upstream.

The parser reads the argument count as a number but doesn't check that
sufficient arguments are supplied. This command triggers the bug:

dmsetup create mpath --table "0 `blockdev --getsize /dev/mapper/cr0`
    multipath 0 0 2 1 round-robin 1000 0 1 1 /dev/mapper/cr0
    round-robin 0 1 1 /dev/mapper/cr1 1000"
kernel BUG at drivers/md/dm-mpath.c:530!

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-mpath.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -540,6 +540,12 @@ static int parse_path_selector(struct ar
 		return -EINVAL;
 	}
 
+	if (ps_argc > as->argc) {
+		dm_put_path_selector(pst);
+		ti->error = "not enough arguments for path selector";
+		return -EINVAL;
+	}
+
 	r = pst->create(&pg->ps, ps_argc, as->argv);
 	if (r) {
 		dm_put_path_selector(pst);


