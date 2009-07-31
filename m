Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbZGaRkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbZGaRkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 13:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZGaRkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 13:40:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:37741 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZGaRkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 13:40:06 -0400
Date: Fri, 31 Jul 2009 17:39:43 GMT
From: "tip-bot for Tan, Wei Chong" <wei.chong.tan@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, wei.chong.tan@intel.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, wei.chong.tan@intel.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <B28277FD4E0F9247A3D55704C440A140D3278C16@pgsmsx504.gar.corp.intel.com>
References: <B28277FD4E0F9247A3D55704C440A140D3278C16@pgsmsx504.gar.corp.intel.com>
Subject: [tip:x86/urgent] x86: SMI workaround for pit_expect_msb
Message-ID: <tip-fb34a8ee86cb52ee688627f820ed6c80ee033219@git.kernel.org>
Git-Commit-ID: fb34a8ee86cb52ee688627f820ed6c80ee033219
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 31 Jul 2009 17:39:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb34a8ee86cb52ee688627f820ed6c80ee033219
Gitweb:     http://git.kernel.org/tip/fb34a8ee86cb52ee688627f820ed6c80ee033219
Author:     Tan, Wei Chong <wei.chong.tan@intel.com>
AuthorDate: Wed, 15 Jul 2009 14:47:18 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 31 Jul 2009 09:26:55 -0700

x86: SMI workaround for pit_expect_msb

pit_expect_msb() seems to be vulnerable to SMI disturbance corner case
in some platforms which causes /proc/cpuinfo to show wrong CPU MHz
value when quick_pit_calibrate() jump to success section.  This patch
try to minimize such cases by rejecting them so that other calibration
method is utilized.  Initial trial shows that out of 300 reboot
cycles, 18 uses quick_pit_calibrate() successfully and /proc/cpuinfo
shows reasonable CPU MHz.  Without the patch, 1 out of roughly 20
reboot cycles may show wrong MHz value.

Signed-off-by: Wei Chong Tan <wei.chong.tan@intel.com>
LKML-Reference: <B28277FD4E0F9247A3D55704C440A140D3278C16@pgsmsx504.gar.corp.intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/kernel/tsc.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 6e1a368..68e93c1 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -285,10 +285,29 @@ static inline int pit_expect_msb(unsigned char val, u64 *tscp, unsigned long *de
 		inb(0x42);
 		if (inb(0x42) != val)
 			break;
+		/* What if an SMI kicks in here when
+		 * count is just slightly over 5 and SMI run long enough
+		 * so that PIT MSB value is way bigger then val?
+		 * Then tscp will have an unreasonably large value,
+		 * since the code has no notion of
+		 * how much inb(0x42) MSB is bigger then val when it return from SMI.
+		 * In addition, since the 2 get_cycles() are near,
+		 * deltap may get a sane value.
+		 * If this happen on the final few readings
+		 * just before (d1+d2 < delta >> 11),
+		 * this may skew the average delta variable of quick_pit_calibrate().
+		 */
 		tsc = get_cycles();
 	}
 	*deltap = get_cycles() - tsc;
 	*tscp = tsc;
+	/* inb(0x42) will need to be separately repeated here as
+	 * the SMI may take so long that the old reading
+	 * is no longer reliable. inb(0x42) after all get_cycles is the safest.
+	 */
+	inb(0x42);
+	if (inb(0x42) < (val - 1))
+		return 0;
 
 	/*
 	 * We require _some_ success, but the quality control
