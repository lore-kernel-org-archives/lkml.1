Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbYLEI2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbYLEI2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYLEI2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:28:08 -0500
Received: from ozlabs.org ([203.10.76.45]:53731 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbYLEI2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:28:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/3] [PATCH] param: Stop gcc from inlining empty weak functions
Date: Fri, 5 Dec 2008 18:58:00 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20081203163207.13965.56517.stgit@warthog.procyon.org.uk> <20081203163212.13965.80352.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081203163212.13965.80352.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812051858.00246.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2008 03:02:12 David Howells wrote:
> Stop gcc from inlining empty weak functions by making them non-empty.  The gcc
> I have for FRV (4.1.2) will inline empty weak functions that are in the same
> file, even if those functions are marked 'noinline'.
> 
> Without this patch, the default arch_get_boot_command_line() is rolled into
> start_kernel(), and the arch specific one is not called, thus making the
> kernel unbootable.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Ouch.  I'd prefer to fix this by moving the weak noop version to
kernel/params.c.  You may still need to fix the rest.

Here's what I ended up with (I'll eventually fold it):

commit 4858874241391aa62b5818781f702883e4ddf4ed
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Dec 5 18:56:34 2008 +1030

    Move arch_get_boot_command_line out of init/main.c for broken gccs.

diff --git a/include/linux/init.h b/include/linux/init.h
index 71cd0f5..8cd1a93 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -150,7 +150,7 @@ extern unsigned int reset_devices;
 
 /* used by init/main.c */
 void setup_arch(void);
-void arch_get_cmdline(char *cmdline);
+void arch_get_boot_command_line(void);
 void prepare_namespace(void);
 
 extern void (*late_time_init)(void);
diff --git a/init/main.c b/init/main.c
index 9595dba..f6032ba 100644
--- a/init/main.c
+++ b/init/main.c
@@ -528,11 +528,6 @@ void __init __weak thread_info_cache_init(void)
 {
 }
 
-/* If the arch already sets boot_command_line, we need do nothing. */
-void __init __weak arch_get_boot_command_line(void)
-{
-}
-
 /* Ideally, this would take a 'const char *cmdline' param. */
 asmlinkage void __init start_kernel(void)
 {
diff --git a/kernel/params.c b/kernel/params.c
index 69dd623..7fac630 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -30,6 +30,15 @@
 #define DEBUGP(fmt, a...)
 #endif
 
+/*
+ * If the arch already sets boot_command_line, we need do nothing. 
+ * This is not in init/main.c because David Howells reports that on FRV
+ * gcc 4.1.2 will inline empty functions, ignoring noinline and weak.
+ */
+void __init __weak arch_get_boot_command_line(void)
+{
+}
+
 static inline char dash2underscore(char c)
 {
 	if (c == '-')


