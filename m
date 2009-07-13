Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbZGMNMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbZGMNMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 09:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbZGMNMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 09:12:50 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:33874 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755756AbZGMNMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 09:12:49 -0400
Subject: [PATCH] Fix vc_screenbuf leak via con_init()
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Mon, 13 Jul 2009 14:12:45 +0100
Message-ID: <20090713130921.6441.17011.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2009 13:12:46.0030 (UTC) FILETIME=[9CF12EE0:01CA03BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a5f4f52e replaced the alloc_bootmem() with kzalloc() but didn't
set vc_kmalloced to 1 and the memory block is later leaked. The
corresponding kmemleak trace:

unreferenced object 0xdf828000 (size 8192):
  comm "swapper", pid 0, jiffies 4294937296
  backtrace:
    [<c006d473>] __save_stack_trace+0x17/0x1c
    [<c000d869>] log_early+0x55/0x84
    [<c01cfa4b>] kmemleak_alloc+0x33/0x3c
    [<c006c013>] __kmalloc+0xd7/0xe4
    [<c00108c7>] con_init+0xbf/0x1b8
    [<c0010149>] console_init+0x11/0x20
    [<c0008797>] start_kernel+0x137/0x1e4

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---

(note that detecting this requires additional kmemleak patches for early
log stack traces which are planned for the next merging window)

 drivers/char/vt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 7947bd1..f6ac4c2 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2881,7 +2881,7 @@ static int __init con_init(void)
 		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 		visual_init(vc, currcons, 1);
 		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
-		vc->vc_kmalloced = 0;
+		vc->vc_kmalloced = 1;
 		vc_init(vc, vc->vc_rows, vc->vc_cols,
 			currcons || !vc->vc_sw->con_save_screen);
 	}

