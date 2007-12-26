Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbXLZQOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbXLZQOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 11:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbXLZQOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 11:14:04 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:53878 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbXLZQOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 11:14:03 -0500
Date: Wed, 26 Dec 2007 17:13:50 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: tglx@linutronix.de, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/3] arch/x86: Use offsetof
Message-ID: <Pine.LNX.4.58.0712261712450.1185@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In the patch cc154ac64aa8d3396b187f64cef01ce67f433324, Al Viro observed
that the proper way to compute the distance between two structure fields is
to use offsetof() or a cast to a pointer to character.  The same change can
be applied to a few more files.

The change was made using the following semantic patch
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r@
type T;
T s;
type T1, T2;
identifier fld1, fld2;
typedef uint8_t;
typedef u8;
@@

(
  (char *)&s.fld1 - (char *)&s.fld2
|
  (uint8_t *)&s.fld1 - (uint8_t *)&s.fld2
|
  (u8 *)&s.fld1 - (u8 *)&s.fld2
|
- (T1)&s.fld1 - (T2)&s.fld2
+ offsetof(T,fld1) - offsetof(T,fld2)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
--- a/arch/x86/kernel/vm86_32.c	2007-10-22 11:25:00.000000000 +0200
+++ b/arch/x86/kernel/vm86_32.c	2007-12-26 16:27:15.000000000 +0100
@@ -215,7 +215,9 @@ asmlinkage int sys_vm86old(struct pt_reg
 	ret = -EFAULT;
 	if (tmp)
 		goto out;
-	memset(&info.vm86plus, 0, (int)&info.regs32 - (int)&info.vm86plus);
+	memset(&info.vm86plus, 0,
+	       offsetof(struct kernel_vm86_struct, regs32) -
+	       offsetof(struct kernel_vm86_struct, vm86plus));
 	info.regs32 = &regs;
 	tsk->thread.vm86_info = v86;
 	do_sys_vm86(&info, tsk);
