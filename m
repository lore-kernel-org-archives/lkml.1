Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbZF2IGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbZF2IGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbZF2IGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:06:31 -0400
Received: from mga05.intel.com ([192.55.52.89]:29996 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751263AbZF2IGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:06:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,308,1243839600"; 
   d="scan'208";a="703346503"
Subject: ffsb create_4k 16% regression
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 29 Jun 2009 16:06:58 +0800
Message-Id: <1246262818.2560.443.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I run many ffsb test cases on JBODs (typically 13/12 disks). Comparing
with kernel 2.6.30, 2.6.31-rc1 has about 16% regression with
ffsb_create_4k. The sub test case creates files continuously for 10
minitues and every file is 1MB.

Bisect located below patch. 


5cee5815d1564bbbd505fea86f4550f1efdb5cd0 is first bad commit
commit 5cee5815d1564bbbd505fea86f4550f1efdb5cd0
Author: Jan Kara <jack@suse.cz>
Date:   Mon Apr 27 16:43:51 2009 +0200

    vfs: Make sys_sync() use fsync_super() (version 4)
    
    It is unnecessarily fragile to have two places (fsync_super() and do_sync())
    doing data integrity sync of the filesystem. Alter __fsync_super() to
    accommodate needs of both callers and use it. So after this patch
    __fsync_super() is the only place where we gather all the calls needed to
    properly send all data on a filesystem to disk.


As a matter of fact, ffsb calls sys_sync in the end to make sure all data is
flushed to disks and the flushing is counted into the result. vmstat shows
ffsb is blocked when syncing for a long time. With 2.6.30, ffsb is blocked for
a short time.

I checked the patch and did experiments to recover the original methods. Eventually,
the root cause is the patch deletes the calling to wakeup_pdflush when syncing, so
only ffsb is blocked on disk I/O. ﻿wakeup_pdflush could ask pdflush to write back pages
with ffsb at the same time.

Below patch against 2.6.31-rc1 fixes it.

﻿Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

--- linux-2.6.31-rc1/fs/sync.c	2009-06-29 12:18:03.000000000 +0800
+++ linux-2.6.31-rc1_sync/fs/sync.c	2009-06-29 14:56:49.000000000 +0800
@@ -114,6 +114,7 @@ restart:
 
 SYSCALL_DEFINE0(sync)
 {
+	wakeup_pdflush(0);
 	sync_filesystems(0);
 	sync_filesystems(1);
 	if (unlikely(laptop_mode))



