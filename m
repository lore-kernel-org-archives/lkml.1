Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbZAFMMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbZAFMMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZAFML7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:11:59 -0500
Received: from smtp.nokia.com ([192.100.122.230]:22636 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZAFML6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:11:58 -0500
Subject: Re: mmotm 2009-01-05-12-50 uploaded (ubifs)
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <20090105142437.9406c375.akpm@linux-foundation.org>
References: <200901052050.n05Kox9j012519@imap1.linux-foundation.org>
	 <49628515.7010609@oracle.com>
	 <20090105142437.9406c375.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Jan 2009 14:11:44 +0200
Message-Id: <1231243904.6608.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Jan 2009 12:11:00.0246 (UTC) FILETIME=[D6766B60:01C96FF7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 14:24 -0800, Andrew Morton wrote:
> WB_SYNC_HOLD got removed by
> http://userweb.kernel.org/~akpm/mmotm/broken-out/fs-remove-wb_sync_hold.patch
> 
> I think I'll just switch that to WB_SYNC_NONE.  The `wait==0' mode is
> just an advisory thing to help the fs shove lots of data into the
> queues.  If some gets missed then it'll be picked up on the second
> ->sync_fs call, with wait==1.

Sorry for the problems caused by this patch. Here is a fix for your
convenience. Will you send it to Linus or I should do this?

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] UBIFS: do not use WB_SYNC_HOLD

WB_SYNC_HOLD is going to be zapped so we should not use it. Use
%WB_SYNC_NONE instead. Here is what akpm said:

"I think I'll just switch that to WB_SYNC_NONE.  The `wait==0' mode is
just an advisory thing to help the fs shove lots of data into the
queues.  If some gets missed then it'll be picked up on the second
->sync_fs call, with wait==1."

Thanks to Randy Dunlap <randy.dunlap@oracle.com> for catching this.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/super.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 0d7564b..89556ee 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -432,12 +432,19 @@ static int ubifs_sync_fs(struct super_block *sb, int wait)
 	int i, err;
 	struct ubifs_info *c = sb->s_fs_info;
 	struct writeback_control wbc = {
-		.sync_mode   = wait ? WB_SYNC_ALL : WB_SYNC_HOLD,
+		.sync_mode   = wait ? WB_SYNC_ALL : WB_SYNC_NONE,
 		.range_start = 0,
 		.range_end   = LLONG_MAX,
 		.nr_to_write = LONG_MAX,
 	};
 
+	/*
+	 * Note by akpm about WB_SYNC_NONE used above: zero @wait is just an
+	 * advisory thing to help the file system shove lots of data into the
+	 * queues. If some gets missed then it'll be picked up on the second
+	 * '->sync_fs()' call, with non-zero @wait.
+	 */
+
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
-- 
1.6.0.6

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

