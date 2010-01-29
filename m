Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814Ab0A2JZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab0A2JZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424Ab0A2JZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:25:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:50558 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab0A2JZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:25:20 -0500
Date: Fri, 29 Jan 2010 09:24:38 GMT
From: tip-bot for Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, maneesh@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, mahesh@linux.vnet.ibm.com, ananth@in.ibm.com,
       fweisbec@gmail.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com
Reply-To: ananth@in.ibm.com, mingo@redhat.com, hpa@zytor.com,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       mahesh@linux.vnet.ibm.com, tglx@linutronix.de,
       prasad@linux.vnet.ibm.com
In-Reply-To: <20100121125516.GA32521@in.ibm.com>
References: <20100121125516.GA32521@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw_breakpoints: Release the bp slot if arch_validate_hwbkpt_settings() fails.
Message-ID: <tip-b23ff0e9330e4b11e18af984d50573598e10e7f9@git.kernel.org>
Git-Commit-ID: b23ff0e9330e4b11e18af984d50573598e10e7f9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:24:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b23ff0e9330e4b11e18af984d50573598e10e7f9
Gitweb:     http://git.kernel.org/tip/b23ff0e9330e4b11e18af984d50573598e10e7f9
Author:     Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
AuthorDate: Thu, 21 Jan 2010 18:25:16 +0530
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 28 Jan 2010 14:15:51 +0100

hw_breakpoints: Release the bp slot if arch_validate_hwbkpt_settings() fails.

On a given architecture, when hardware breakpoint registration fails
due to un-supported access type (read/write/execute), we lose the bp
slot since register_perf_hw_breakpoint() does not release the bp slot
on failure.
Hence, any subsequent hardware breakpoint registration starts failing
with 'no space left on device' error.

This patch introduces error handling in register_perf_hw_breakpoint()
function and releases bp slot on error.

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: K. Prasad <prasad@linux.vnet.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
LKML-Reference: <20100121125516.GA32521@in.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
 
