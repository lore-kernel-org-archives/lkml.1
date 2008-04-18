Return-Path: <linux-kernel-owner+w=401wt.eu-S1760803AbYDRSv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803AbYDRSv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 14:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760205AbYDRSvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 14:51:20 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:30162 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760007AbYDRSvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 14:51:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hDRWFUvX4cz8zbvLNDLVJEq25JwrB7KmF4pUFrL6H0oYtEFm8C6vgylumDBM14nhFoBFhd0cOZkcHLW75xP/GJzPiDXfD2OvsUSB7X9z5ds1yCrSjF68hSMSOHU+CtKLsvTSBgM3sShdWO1YUXv+d1QfM29LyK1X27dG4GfO8Nc=
Subject: [PATCH] kgdb: fix signedness mixmatches, add statics, add
	declaration to header
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 11:51:31 -0700
Message-Id: <1208544691.17196.48.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed by sparse:
arch/x86/kernel/kgdb.c:556:15: warning: symbol 'kgdb_arch_pc' was not declared. Should it be static?
kernel/kgdb.c:149:8: warning: symbol 'kgdb_do_roundup' was not declared. Should it be static?
kernel/kgdb.c:193:22: warning: symbol 'kgdb_arch_pc' was not declared. Should it be static?
kernel/kgdb.c:712:5: warning: symbol 'remove_all_break' was not declared. Should it be static?

Related to kgdb_hex2long:
arch/x86/kernel/kgdb.c:371:28: warning: incorrect type in argument 2 (different signedness)
arch/x86/kernel/kgdb.c:371:28:    expected long *long_val
arch/x86/kernel/kgdb.c:371:28:    got unsigned long *<noident>
kernel/kgdb.c:469:27: warning: incorrect type in argument 2 (different signedness)
kernel/kgdb.c:469:27:    expected long *long_val
kernel/kgdb.c:469:27:    got unsigned long *<noident>
kernel/kgdb.c:470:27: warning: incorrect type in argument 2 (different signedness)
kernel/kgdb.c:470:27:    expected long *long_val
kernel/kgdb.c:470:27:    got unsigned long *<noident>
kernel/kgdb.c:894:27: warning: incorrect type in argument 2 (different signedness)
kernel/kgdb.c:894:27:    expected long *long_val
kernel/kgdb.c:894:27:    got unsigned long *<noident>
kernel/kgdb.c:895:27: warning: incorrect type in argument 2 (different signedness)
kernel/kgdb.c:895:27:    expected long *long_val
kernel/kgdb.c:895:27:    got unsigned long *<noident>
kernel/kgdb.c:1127:28: warning: incorrect type in argument 2 (different signedness)
kernel/kgdb.c:1127:28:    expected long *long_val
kernel/kgdb.c:1127:28:    got unsigned long *<noident>
kernel/kgdb.c:1132:25: warning: incorrect type in argument 2 (different signedness)
kernel/kgdb.c:1132:25:    expected long *long_val
kernel/kgdb.c:1132:25:    got unsigned long *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/kgdb.h |    4 +++-
 kernel/kgdb.c        |    8 ++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 9757b1a..6adcc29 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -261,10 +261,12 @@ struct kgdb_io {
 
 extern struct kgdb_arch		arch_kgdb_ops;
 
+extern unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs);
+
 extern int kgdb_register_io_module(struct kgdb_io *local_kgdb_io_ops);
 extern void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops);
 
-extern int kgdb_hex2long(char **ptr, long *long_val);
+extern int kgdb_hex2long(char **ptr, unsigned long *long_val);
 extern int kgdb_mem2hex(char *mem, char *buf, int count);
 extern int kgdb_hex2mem(char *buf, char *mem, int count);
 
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 1bd0ec1..39e31a0 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -61,7 +61,7 @@ struct kgdb_state {
 	int			err_code;
 	int			cpu;
 	int			pass_exception;
-	long			threadid;
+	unsigned long		threadid;
 	long			kgdb_usethreadid;
 	struct pt_regs		*linux_regs;
 };
@@ -146,7 +146,7 @@ atomic_t			kgdb_cpu_doing_single_step = ATOMIC_INIT(-1);
  * the other CPUs might interfere with your debugging context, so
  * use this with care:
  */
-int				kgdb_do_roundup = 1;
+static int kgdb_do_roundup = 1;
 
 static int __init opt_nokgdbroundup(char *str)
 {
@@ -438,7 +438,7 @@ int kgdb_hex2mem(char *buf, char *mem, int count)
  * While we find nice hex chars, build a long_val.
  * Return number of chars processed.
  */
-int kgdb_hex2long(char **ptr, long *long_val)
+int kgdb_hex2long(char **ptr, unsigned long *long_val)
 {
 	int hex_val;
 	int num = 0;
@@ -709,7 +709,7 @@ int kgdb_isremovedbreak(unsigned long addr)
 	return 0;
 }
 
-int remove_all_break(void)
+static int remove_all_break(void)
 {
 	unsigned long addr;
 	int error;
-- 
1.5.5.144.g3e42



