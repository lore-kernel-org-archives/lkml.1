Return-Path: <linux-kernel-owner+w=401wt.eu-S1752061Ab0AUMzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab0AUMzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 07:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795Ab0AUMzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 07:55:51 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:40224 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab0AUMzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 07:55:50 -0500
Date: Thu, 21 Jan 2010 18:25:16 +0530
From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, fweisbec@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       prasad@linux.vnet.ibm.com,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>, maneesh@in.ibm.com
Subject: [patch] HWBKPT FIX: Release the bp slot if
 arch_validate_hwbkpt_settings() fails.
Message-ID: <20100121125516.GA32521@in.ibm.com>
References: <20100121125113.152043766@mars.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hwbkpt_common_code_fix.patch"
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On a given architecture, when hardware breakpoint registration fails due
to un-supported access type (read/write/execute), we loose the bp slot since
register_perf_hw_breakpoint() does not release the bp slot on failure.
Hence, any subsequent hardware breakpoint registration starts failing
with 'no space left on device' error.

This patch introduces error handling in register_perf_hw_breakpoint()
function and releases bp slot on error.

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
---

 kernel/hw_breakpoint.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 50dbd59..c030ae6 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -296,6 +296,10 @@ int register_perf_hw_breakpoint(struct perf_event *bp)
 	if (!bp->attr.disabled || !bp->overflow_handler)
 		ret = arch_validate_hwbkpt_settings(bp, bp->ctx->task);
 
+	/* if arch_validate_hwbkpt_settings() fails then release bp slot */
+	if (ret)
+		release_bp_slot(bp);
+
 	return ret;
 }
 

