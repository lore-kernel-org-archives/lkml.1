Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbZLDNw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbZLDNw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 08:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbZLDNwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 08:52:42 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:46721 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbZLDNwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 08:52:41 -0500
From: Louis Rilling <louis.rilling@kerlabs.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Louis Rilling <louis.rilling@kerlabs.com>
Subject: [PATCH 1/2] block: Fix io_context leak after clone with CLONE_IO
Date: Fri,  4 Dec 2009 14:52:41 +0100
Message-Id: <1259934762-16920-2-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1259934762-16920-1-git-send-email-louis.rilling@kerlabs.com>
References: <1259934762-16920-1-git-send-email-louis.rilling@kerlabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CLONE_IO, copy_io() increments both ioc->refcount and ioc->nr_tasks.
However exit_io_context() only decrements ioc->refcount if ioc->nr_tasks
reaches 0.

Always call put_io_context() in exit_io_context().

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 block/blk-ioc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index d4ed600..dcd0412 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -80,8 +80,8 @@ void exit_io_context(void)
 			ioc->aic->exit(ioc->aic);
 		cfq_exit(ioc);
 
-		put_io_context(ioc);
 	}
+	put_io_context(ioc);
 }
 
 struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
-- 
1.5.6.5

