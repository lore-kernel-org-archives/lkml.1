Return-Path: <linux-kernel-owner+w=401wt.eu-S934820AbYEUOHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934820AbYEUOHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762892AbYEUOGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:06:55 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:29013 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761223AbYEUOGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:06:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=cxCWu+KypiIvW/knTwmxI5Ax5ilp3x8nMEMyGdc4/pe0FKtivtJVspeK5SC+YQUm6VVr9W8+qw26Wi7KyaSBe5hJcTO1hvqNx7pE5/W9gfunilWQMZdtV6PXJtfAU9otYuyLVjDBCkgjsQf0jJHc9zGSEDisUixSD31ODeHj9QQ=
Message-ID: <48342C6C.2010502@googlemail.com>
Date: Wed, 21 May 2008 16:06:36 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: rolandd@cisco.com
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       general@lists.openfabrics.org, sean.hefty@intel.com,
       hal.rosenstock@gmail.com, linux-next@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: [PATCH] infiniband/hw/ipath/ipath_sdma.c , fix compiler
 warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On linux-next from today , allmodconfig, I see the following warnings on 64bit:

...

  CC [M]  drivers/infiniband/hw/ipath/ipath_sdma.o
drivers/infiniband/hw/ipath/ipath_sdma.c: In function 'sdma_abort_task':
drivers/infiniband/hw/ipath/ipath_sdma.c:267: warning: passing argument 2 of 'constant_test_bit' from incompatible pointer type
drivers/infiniband/hw/ipath/ipath_sdma.c:267: warning: passing argument 2 of 'variable_test_bit' from incompatible pointer type
drivers/infiniband/hw/ipath/ipath_sdma.c:269: warning: passing argument 2 of 'constant_test_bit' from incompatible pointer type
drivers/infiniband/hw/ipath/ipath_sdma.c:269: warning: passing argument 2 of 'variable_test_bit' from incompatible pointer type
drivers/infiniband/hw/ipath/ipath_sdma.c:271: warning: passing argument 2 of 'constant_test_bit' from incompatible pointer type
drivers/infiniband/hw/ipath/ipath_sdma.c:271: warning: passing argument 2 of 'variable_test_bit' from incompatible pointer type
drivers/infiniband/hw/ipath/ipath_sdma.c:273: warning: passing argument 2 of 'constant_test_bit' from incompatible pointer type
drivers/infiniband/hw/ipath/ipath_sdma.c:273: warning: passing argument 2 of 'variable_test_bit' from incompatible pointer type
drivers/infiniband/hw/ipath/ipath_sdma.c:348: warning: format '%016llx' expects type 'long long unsigned int', but argument 3 has type 'long unsigned int'
drivers/infiniband/hw/ipath/ipath_sdma.c: In function 'ipath_restart_sdma':
drivers/infiniband/hw/ipath/ipath_sdma.c:618: warning: format '%016llx' expects type 'long long unsigned int', but argument 3 has type 'long unsigned int'

...

Signed-off-by: Gabriel C <nix.or.die@googlemail.com>

---

I see the 'format' warnings in mainline also.

 drivers/infiniband/hw/ipath/ipath_sdma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_sdma.c b/drivers/infiniband/hw/ipath/ipath_sdma.c
index 3697449..5f80151 100644
--- a/drivers/infiniband/hw/ipath/ipath_sdma.c
+++ b/drivers/infiniband/hw/ipath/ipath_sdma.c
@@ -257,7 +257,7 @@ static void sdma_abort_task(unsigned long opaque)
 	/* everything is stopped, time to clean up and restart */
 	if (status == IPATH_SDMA_ABORT_ABORTED) {
 		struct ipath_sdma_txreq *txp, *txpnext;
-		u64 hwstatus;
+		unsigned long hwstatus;
 		int notify = 0;
 
 		hwstatus = ipath_read_kreg64(dd,
@@ -346,7 +346,7 @@ resched:
 	 */
 	if (jiffies > dd->ipath_sdma_abort_jiffies) {
 		ipath_dbg("looping with status 0x%016llx\n",
-			  dd->ipath_sdma_status);
+			  (unsigned long long)dd->ipath_sdma_status);
 		dd->ipath_sdma_abort_jiffies = jiffies + 5 * HZ;
 	}
 resched_noprint:
@@ -616,7 +616,7 @@ void ipath_restart_sdma(struct ipath_devdata *dd)
 	spin_unlock_irqrestore(&dd->ipath_sdma_lock, flags);
 	if (!needed) {
 		ipath_dbg("invalid attempt to restart SDMA, status 0x%016llx\n",
-			dd->ipath_sdma_status);
+			(unsigned long long)dd->ipath_sdma_status);
 		goto bail;
 	}
 	spin_lock_irqsave(&dd->ipath_sendctrl_lock, flags);
