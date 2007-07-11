Return-Path: <linux-kernel-owner+w=401wt.eu-S934501AbXGKVJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501AbXGKVJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934444AbXGKVI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:08:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934441AbXGKVI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:08:57 -0400
Date: Wed, 11 Jul 2007 22:02:21 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Mike Anderson <andmike@us.ibm.com>
Subject: [2.6.23 PATCH 15/18] dm: netlink mpath
Message-ID: <20070711210221.GG24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Mike Anderson <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Anderson <andmike@us.ibm.com>

This patch adds calls to dm_path_event for a failed path and a reinstated
path.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-mpath.c |    7 +++++++
 1 files changed, 7 insertions(+)

Index: linux/drivers/md/dm-mpath.c
===================================================================
--- linux.orig/drivers/md/dm-mpath.c	2007-07-11 21:37:47.000000000 +0100
+++ linux/drivers/md/dm-mpath.c	2007-07-11 21:37:53.000000000 +0100
@@ -10,6 +10,7 @@
 #include "dm-hw-handler.h"
 #include "dm-bio-list.h"
 #include "dm-bio-record.h"
+#include "dm-netlink.h"
 
 #include <linux/ctype.h>
 #include <linux/init.h>
@@ -834,6 +835,9 @@ static int fail_path(struct pgpath *pgpa
 	if (pgpath == m->current_pgpath)
 		m->current_pgpath = NULL;
 
+	dm_path_event(DM_EVENT_PATH_FAILED, m->ti->table,
+		      pgpath->path.dev->name, m->nr_valid_paths);
+
 	queue_work(kmultipathd, &m->trigger_event);
 
 out:
@@ -873,6 +877,9 @@ static int reinstate_path(struct pgpath 
 	if (!m->nr_valid_paths++ && m->queue_size)
 		queue_work(kmultipathd, &m->process_queued_ios);
 
+	dm_path_event(DM_EVENT_PATH_REINSTATED, m->ti->table,
+		      pgpath->path.dev->name, m->nr_valid_paths);
+
 	queue_work(kmultipathd, &m->trigger_event);
 
 out:
