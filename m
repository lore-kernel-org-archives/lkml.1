Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbYIXO01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbYIXO01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 10:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbYIXO0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 10:26:19 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:1284 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYIXO0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 10:26:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=vFrX2d2/SoKhR00G0mva8qDz5TziJ8vONO+o2RnMUV+ZLpx8FVUDBRd101ENHe8ceD
         yQXJ27HfFs1LPfuMGBNDkq1e1GtnvpgfDU1dQMS97f4FpPdK1TzGpksRunhlYkz5pdtH
         A1eeKVtKNaH22FyK5EtxJOBDNQYY0RV3e0tHM=
Message-ID: <48DA5D6C.4010008@gmail.com>
Date: Wed, 24 Sep 2008 16:31:56 +0100
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: [Patch -tip] x86/ftrace: use uaccess in atomic context
Content-Type: multipart/mixed;
 boundary="------------070709000503090200050108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070709000503090200050108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

With last -tip I get this bug:

[   49.439988] in_atomic():0, irqs_disabled():1
[   49.440118] INFO: lockdep is turned off.
[   49.440118] Pid: 2814, comm: modprobe Tainted: G        W 2.6.27-rc7 #4
[   49.440118]  [<c01215e1>] __might_sleep+0xe1/0x120
[   49.440118]  [<c01148ea>] ftrace_modify_code+0x2a/0xd0
[   49.440118]  [<c01148a2>] ? ftrace_test_p6nop+0x0/0xa
[   49.440118]  [<c016e80e>] __ftrace_update_code+0xfe/0x2f0
[   49.440118]  [<c01148a2>] ? ftrace_test_p6nop+0x0/0xa
[   49.440118]  [<c016f190>] ftrace_convert_nops+0x50/0x80
[   49.440118]  [<c016f1d6>] ftrace_init_module+0x16/0x20
[   49.440118]  [<c015498b>] load_module+0x185b/0x1d30
[   49.440118]  [<c01767a0>] ? find_get_page+0x0/0xf0
[   49.440118]  [<c02463c0>] ? sprintf+0x0/0x30
[   49.440118]  [<c034e012>] ? mutex_lock_interruptible_nested+0x1f2/0x350
[   49.440118]  [<c0154eb3>] sys_init_module+0x53/0x1b0
[   49.440118]  [<c0352340>] ? do_page_fault+0x0/0x740
[   49.440118]  [<c0104012>] syscall_call+0x7/0xb
[   49.440118]  =======================

It is because ftrace_modify_code() calls copy_to_user and 
copy_from_user.
These functions have been inserted after guessing that there 
couldn't be any race condition but copy_[to/from]_user might 
sleep and __ftrace_update_code is called with local_irq_saved.

These function have been inserted since this commit:
d5e92e8978fd2574e415dc2792c5eb592978243d: 
"ftrace: x86 use copy from user function"

Following is a patch which correct it.
---
Adapt uaccess functions's use to atomic context in ftrace_modify_code()
since we are in IRQ-off context: __ftrace_update_code() calls
local_irq_save().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---



--------------070709000503090200050108
Content-Type: text/plain;
 name="trace.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="trace.diff"

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 082d996..fd667f1 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -71,13 +71,13 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 	 * No real locking needed, this code is run through
 	 * kstop_machine, or before SMP starts.
 	 */
-	if (__copy_from_user(replaced, (char __user *)ip, MCOUNT_INSN_SIZE))
+	if (__copy_from_user_inatomic(replaced, (char __user *)ip, MCOUNT_INSN_SIZE))
 		return 1;
 
 	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
 		return 2;
 
-	WARN_ON_ONCE(__copy_to_user((char __user *)ip, new_code,
+	WARN_ON_ONCE(__copy_to_user_inatomic((char __user *)ip, new_code,
 				    MCOUNT_INSN_SIZE));
 
 	sync_core();

--------------070709000503090200050108--
