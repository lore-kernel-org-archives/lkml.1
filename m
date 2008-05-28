Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYE1TMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYE1TMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 15:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbYE1TME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 15:12:04 -0400
Received: from mail.vyatta.com ([216.93.170.194]:56554 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbYE1TMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 15:12:01 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.499
Date: Wed, 28 May 2008 12:12:00 -0700
From: Stephen Hemminger <stephen.hemminger@vyatta.com>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Wright <chrisw@osdl.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] sysctl: permission check based on capability not euid
Message-ID: <20080528121200.54c04b5a@speedy>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the permission checks for sysctl's from being based on uid=0 (root)
to use the capability system. This matches the behavior of other OS's using sysctl's
and capabilities. Linux has tried to get away from using uid=0 for security overrides
and use capabilities instead. 

I was working on Quagga enhancement that involved enabling a sysctl, and it didn't
work because is a safe daemon and drops privileges and resets its real/effective uid
after initialization; it then re-enables only the capabilities when it needs to
do some privileged operation. This wouldn't work because sysctl's were still using
the root based permission check. The existing code in quagga to enable ip forwarding
doesn't work for the same reason.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

---
Maybe once the BKL is gone, the last vestiges of current->euid == 0 can be wiped out
as well.

--- a/include/linux/capability.h	2008-05-27 17:33:02.000000000 -0700
+++ b/include/linux/capability.h	2008-05-27 17:33:27.000000000 -0700
@@ -261,6 +261,7 @@ typedef struct kernel_cap_struct {
    arbitrary SCSI commands */
 /* Allow setting encryption key on loopback filesystem */
 /* Allow setting zone reclaim policy */
+/* Allow setting any sysctl value */
 
 #define CAP_SYS_ADMIN        21
 
--- a/kernel/sysctl.c	2008-05-27 17:32:33.000000000 -0700
+++ b/kernel/sysctl.c	2008-05-27 17:32:46.000000000 -0700
@@ -1561,7 +1561,7 @@ out:
 
 static int test_perm(int mode, int op)
 {
-	if (!current->euid)
+	if (capable(CAP_SYS_ADMIN))
 		mode >>= 6;
 	else if (in_egroup_p(0))
 		mode >>= 3;
