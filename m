Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173Ab0A1Oc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0A1Oc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 09:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863Ab0A1Oc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 09:32:56 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:54284 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab0A1Ocz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 09:32:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bRUTBPCRyB53YXAECqfY3y+osjdgB8YrojJD1XjZRPr/sCKz6U6OWr33DxDZ+lbqop
         1DuSr8NoVbcYTIDDr87DHBDzQXHp0vH2lDX3BHzCxGPHnenCUVfgygCklmYaF6EDKVQ3
         mf35xXWB/foUaFVggLa3MKQ7xglEta+ZTlp/s=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Maneesh Soni <maneesh@in.ibm.com>
Subject: [GIT PULL] hw_breakpoint fix
Date: Thu, 28 Jan 2010 15:32:52 +0100
Message-Id: <1264689172-9077-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

Thanks,
	Frederic
---

Mahesh Salgaonkar (1):
      hw_breakpoints: Release the bp slot if arch_validate_hwbkpt_settings() fails.


 kernel/hw_breakpoint.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

---
commit b23ff0e9330e4b11e18af984d50573598e10e7f9
Author: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Date:   Thu Jan 21 18:25:16 2010 +0530

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
 
