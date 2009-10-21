Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbZJUXi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbZJUXi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 19:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZJUXi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 19:38:29 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:33846 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbZJUXi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 19:38:28 -0400
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.44,600,1249257600"; 
   d="scan'208";a="216735499"
Message-ID: <4ADF9B78.4060807@cisco.com>
Date: Wed, 21 Oct 2009 16:38:32 -0700
From: Michael Sundius <msundius@cisco.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, msundius@sundius.com, msundius@cisco.com
Subject: [patch] delay panic during startup of kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been, from time to time,  running into various problems early on
the initialization of the kernel, encountering situations where we really
should panic, but we can't because its too early to do so.
(see * if you care to know why this is a problem for us). Anyhow, I've
created this patch to have a little better way of orderly finishing the
bring-up to the point where we can panic safely. Any comments?


*One reason this often happens to us is that we have added hooks
for our drivers to allocate contiguous blocks of memory very early and
our driver team doesn't always communicate when changes have been
made.

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f4e3184..b2e7bac 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -163,6 +163,10 @@ extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char * fmt, ...)
        __attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
+extern void panic_later(const char * fmt, ...)
+       __attribute__ ((format (printf, 1, 2)));
+extern void panic_later_complete(void);
+extern bool panic_later_pending(void);
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
diff --git a/init/main.c b/init/main.c
index 5988deb..2a9347a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -185,7 +185,6 @@ __setup("reset_devices", set_reset_devices);

 static char * argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
 char * envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
-static const char *panic_later, *panic_param;

 extern struct obs_kernel_param __setup_start[], __setup_end[];

@@ -281,7 +280,7 @@ static int __init unknown_bootoption(char *param, 
char *val)
                return 0;
        }

-       if (panic_later)
+       if (panic_later_pending())
                return 0;

        if (val) {
@@ -289,8 +288,7 @@ static int __init unknown_bootoption(char *param, 
char *val)
                unsigned int i;
                for (i = 0; envp_init[i]; i++) {
                        if (i == MAX_INIT_ENVS) {
-                               panic_later = "Too many boot env vars at 
`%s'";
-                               panic_param = param;
+                               panic_later("Too many boot env vars at 
`%s'", param);
                        }
                        if (!strncmp(param, envp_init[i], val - param))
                                break;
@@ -301,8 +299,7 @@ static int __init unknown_bootoption(char *param, 
char *val)
                unsigned int i;
                for (i = 0; argv_init[i]; i++) {
                        if (i == MAX_INIT_ARGS) {
-                               panic_later = "Too many boot init vars 
at `%s'";
-                               panic_param = param;
+                               panic_later("Too many boot init vars at 
`%s'", param);
                        }
                }
                argv_init[i] = param;
@@ -621,8 +618,7 @@ asmlinkage void __init start_kernel(void)
         * this. But we do want output early, in case something goes wrong.
         */
        console_init();
-       if (panic_later)
-               panic(panic_later, panic_param);
+       panic_later_complete();

        lockdep_info();

diff --git a/kernel/panic.c b/kernel/panic.c
index 96b45d0..092bb46 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -23,6 +23,9 @@
 #include <linux/nmi.h>
 #include <linux/dmi.h>

+#define MAX_PANIC_LATER_LEN    1024
+static char panic_later_msg[MAX_PANIC_LATER_LEN];
+
 int panic_on_oops;
 static unsigned long tainted_mask;
 static int pause_on_oops;
@@ -40,6 +43,28 @@ static long no_blink(long time)
        return 0;
 }

+void panic_later(const char *fmt, ...)
+{
+       va_list args;
+
+       if (!panic_later_pending()) {
+               va_start(args, fmt);
+               vsnprintf(panic_later_msg, sizeof(panic_later_msg), fmt, 
args);
+               va_end(args);
+       }
+}
+
+bool panic_later_pending()
+{
+       return panic_later_msg[0] != 0;
+}
+
+void panic_later_complete()
+{
+       if (panic_later_pending())
+               panic("%s", panic_later_msg);
+}
+
 /* Returns how long it waited in ms */
 long (*panic_blink)(long time);
 EXPORT_SYMBOL(panic_blink);
