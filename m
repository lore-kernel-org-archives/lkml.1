Return-Path: <linux-kernel-owner+w=401wt.eu-S1765994AbZGABPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765994AbZGABPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761597AbZGAAfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:52 -0400
Received: from kroah.org ([198.145.64.141]:60705 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761517AbZGAAfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:42 2009
Message-Id: <20090701002442.283134938@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 097/108] dm mpath: flush keventd queue in destructor
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=dm-mpath-flush-keventd-queue-in-destructor.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 53b351f972a882ea8b6cdb19602535f1057c884a upstream.

The commit fe9cf30eb8186ef267d1868dc9f12f2d0f40835a moves dm table event
submission from kmultipath queue to kernel kevent queue to avoid a
deadlock.

There is a possibility of race condition because kevent queue is not flushed
in the multipath destructor. The scenario is:
- some event happens and is queued to keventd
- keventd thread is delayed due to scheuling latency or some other work
- multipath device is destroyed
- keventd now attempts to process work_struct that is residing in already
  released memory.

The patch flushes the keventd queue in multipath constructor.
I've already fixed similar bug in dm-raid1.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-mpath.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -847,6 +847,7 @@ static void multipath_dtr(struct dm_targ
 
 	flush_workqueue(kmpath_handlerd);
 	flush_workqueue(kmultipathd);
+	flush_scheduled_work();
 	free_multipath(m);
 }
 


