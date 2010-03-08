Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0CHPqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:46:14 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:38714 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab0CHPqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:46:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=EDJu5Oodzs8SX+DxaMM9A/4AuSktP7m7jeOn8sF4RF1+MoNiCPlVOtcW76OGHjr/e1
         oMjT2CayhYVJhv2UnbfYybp5qYwhRh7zIC/1NJdH8wI164vh2Qx29VvFA6KhHqTew2F6
         OfjyV3zRV7MFIjtK9+x3n1DShWoo6AIi8zxWg=
Date: Mon, 8 Mar 2010 16:46:01 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs, binfmt_aout: Fix pointer warnings
Message-ID: <20100308154601.GA30454@a1.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm getting the warnings in the commit message below with current git. Maybe fix
them like this:

--
From: Borislav Petkov <petkovbb@gmail.com>
Date: Mon, 8 Mar 2010 16:37:42 +0100
Subject: [PATCH] fs, binfmt_aout: Fix pointer warnings
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

I get

fs/binfmt_aout.c: In function ‘aout_core_dump’:
fs/binfmt_aout.c:125: warning: passing argument 2 of ‘dump_write’ makes pointer from integer without a cast
include/linux/coredump.h:12: note: expected ‘const void *’ but argument is of type ‘long unsigned int’
fs/binfmt_aout.c:132: warning: passing argument 2 of ‘dump_write’ makes pointer from integer without a cast
include/linux/coredump.h:12: note: expected ‘const void *’ but argument is of type ‘long unsigned int’

due to dump_write() expecting a user void *. Fold casts into the
START_DATA/START_STACK macros and shut up the warnings.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 fs/binfmt_aout.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index 15d80bb..9b6aef0 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -75,14 +75,16 @@ static int aout_core_dump(struct coredump_params *cprm)
 	struct file *file = cprm->file;
 	mm_segment_t fs;
 	int has_dumped = 0;
-	unsigned long dump_start, dump_size;
+	void __user *dump_start;
+	int dump_size;
 	struct user dump;
 #ifdef __alpha__
-#       define START_DATA(u)	(u.start_data)
+#       define START_DATA(u)	((void __user *)u.start_data)
 #else
-#	define START_DATA(u)	((u.u_tsize << PAGE_SHIFT) + u.start_code)
+#	define START_DATA(u)	((void __user *)((u.u_tsize << PAGE_SHIFT) + \
+				 u.start_code))
 #endif
-#       define START_STACK(u)   (u.start_stack)
+#       define START_STACK(u)   ((void __user *)u.start_stack)
 
 	fs = get_fs();
 	set_fs(KERNEL_DS);
@@ -104,9 +106,9 @@ static int aout_core_dump(struct coredump_params *cprm)
 
 /* make sure we actually have a data and stack area to dump */
 	set_fs(USER_DS);
-	if (!access_ok(VERIFY_READ, (void __user *)START_DATA(dump), dump.u_dsize << PAGE_SHIFT))
+	if (!access_ok(VERIFY_READ, START_DATA(dump), dump.u_dsize << PAGE_SHIFT))
 		dump.u_dsize = 0;
-	if (!access_ok(VERIFY_READ, (void __user *)START_STACK(dump), dump.u_ssize << PAGE_SHIFT))
+	if (!access_ok(VERIFY_READ, START_STACK(dump), dump.u_ssize << PAGE_SHIFT))
 		dump.u_ssize = 0;
 
 	set_fs(KERNEL_DS);
-- 
1.6.6.1

