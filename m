Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbXJQMzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbXJQMzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 08:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761494AbXJQMz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 08:55:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932602AbXJQMz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 08:55:26 -0400
Date: Wed, 17 Oct 2007 13:55:11 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [2.6.24 PATCH 04/04] dm mpath: send uevents
Message-ID: <20071017125511.GP24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Mike Anderson <andmike@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Anderson <andmike@linux.vnet.ibm.com>

This patch adds calls to dm_path_event for a failed path and a reinstated
path.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-mpath.c |    7 +++++++
 1 files changed, 7 insertions(+)

Index: linux-2.6.23/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-mpath.c	2007-10-16 23:39:02.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-mpath.c	2007-10-16 23:39:06.000000000 +0100
@@ -10,6 +10,7 @@
 #include "dm-hw-handler.h"
 #include "dm-bio-list.h"
 #include "dm-bio-record.h"
+#include "dm-uevent.h"
 
 #include <linux/ctype.h>
 #include <linux/init.h>
@@ -857,6 +858,9 @@ static int fail_path(struct pgpath *pgpa
 	if (pgpath == m->current_pgpath)
 		m->current_pgpath = NULL;
 
+	dm_path_uevent(DM_UEVENT_PATH_FAILED, m->ti,
+		      pgpath->path.dev->name, m->nr_valid_paths);
+
 	queue_work(kmultipathd, &m->trigger_event);
 
 out:
@@ -896,6 +900,9 @@ static int reinstate_path(struct pgpath 
 	if (!m->nr_valid_paths++ && m->queue_size)
 		queue_work(kmultipathd, &m->process_queued_ios);
 
+	dm_path_uevent(DM_UEVENT_PATH_REINSTATED, m->ti,
+		      pgpath->path.dev->name, m->nr_valid_paths);
+
 	queue_work(kmultipathd, &m->trigger_event);
 
 out:
