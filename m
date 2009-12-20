Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbZLTQxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbZLTQxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 11:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbZLTQxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 11:53:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38086 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbZLTQxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 11:53:18 -0500
Date: Sun, 20 Dec 2009 17:53:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, rusty@rustcorp.com.au, rguenther@suse.de
Cc: arnd@arndb.de
Subject: [PATCH] Fix BUILD_BUG_ON in fs/compat_ioctl.c to build with gcc
	4.5 snapshot
Message-ID: <20091220165315.GA13208@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix BUILD_BUG_ON in fs/compat_ioctl.c to build with gcc 4.5 snapshot

The BUILD_BUG_ON in compat_ioctl_check_table() fails
with a recent gcc mainline snapshot (gcc version 4.5.0 20091219)
(GCC)), even though it works with older compilers.

 const int max = ARRAY_SIZE(ioctl_pointer) - 1;
 BUILD_BUG_ON(max >= (1 << 16));

I replaced the BUILD_BUG_ON with a old style extern reference and 
that works.

That shows that the actual expression is evaluated ok and something must be 
wrong with the BUILD_BUG_ON macro itself. Maybe Rusty's rework
will fix that (I haven't tried but it's probably worth investigating) 

I filed a bug on the compiler too 
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=42439

According to Joseph Myers the problem is that even when declared
with const "max" is not a constant expression in the C standard sense,
so the code is indeed incorrect.

Anyways with this workaround a relatively standard defconfig like 
configuration and a 64bit allyes configuration builds again with gcc 4.5

Cc: jbeulich@novell.com
Cc: rusty@rustcorp.com.au
Cc: rguenther@suse.de

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/compat_ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.33-rc1-ak/fs/compat_ioctl.c
===================================================================
--- linux-2.6.33-rc1-ak.orig/fs/compat_ioctl.c
+++ linux-2.6.33-rc1-ak/fs/compat_ioctl.c
@@ -1649,8 +1649,10 @@ static int compat_ioctl_check_table(unsi
 {
 	int i;
 	const int max = ARRAY_SIZE(ioctl_pointer) - 1;
+	extern void __ioctl_pointer_too_large(void);
 
-	BUILD_BUG_ON(max >= (1 << 16));
+	if (max >= (1 << 16))
+		__ioctl_pointer_too_large();
 
 	/* guess initial offset into table, assuming a
 	   normalized distribution */
