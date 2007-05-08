Return-Path: <linux-kernel-owner+w=401wt.eu-S1031658AbXEHTrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031658AbXEHTrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031656AbXEHTrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:47:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031641AbXEHTq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:46:58 -0400
Date: Tue, 8 May 2007 20:45:54 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Edward Goggin <egoggin@emc.com>
Subject: [2.6.22 PATCH 09/26] dm mpath: log device name
Message-ID: <20070508194554.GP24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Edward Goggin <egoggin@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Edward Goggin <egoggin@emc.com>

Make the mapped device structure accessible to hardware
handlers so error messages can include the device name.

Signed-off-by: Edward Goggin <egoggin@emc.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-hw-handler.h |    1 +
 drivers/md/dm-mpath.c      |    3 +++
 drivers/md/dm.c            |    1 +
 3 files changed, 5 insertions(+)

Index: linux-2.6.21/drivers/md/dm-hw-handler.h
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-hw-handler.h	2007-05-01 17:38:32.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-hw-handler.h	2007-05-01 17:40:50.000000000 +0100
@@ -16,6 +16,7 @@
 struct hw_handler_type;
 struct hw_handler {
 	struct hw_handler_type *type;
+	struct mapped_device *md;
 	void *context;
 };
 
Index: linux-2.6.21/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-mpath.c	2007-05-01 17:38:32.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-mpath.c	2007-05-01 17:40:50.000000000 +0100
@@ -668,6 +668,9 @@ static int parse_hw_handler(struct arg_s
 		return -EINVAL;
 	}
 
+	m->hw_handler.md = dm_table_get_md(ti->table);
+	dm_put(m->hw_handler.md);
+
 	r = hwht->create(&m->hw_handler, hw_argc - 1, as->argv);
 	if (r) {
 		dm_put_hw_handler(hwht);
Index: linux-2.6.21/drivers/md/dm.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm.c	2007-05-01 17:38:32.000000000 +0100
+++ linux-2.6.21/drivers/md/dm.c	2007-05-01 17:40:50.000000000 +0100
@@ -1236,6 +1236,7 @@ void dm_put(struct mapped_device *md)
 		free_dev(md);
 	}
 }
+EXPORT_SYMBOL_GPL(dm_put);
 
 /*
  * Process the deferred bios
