Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbYHHGx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbYHHGx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbYHHGws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:52:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:18951 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422AbYHHGwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:52:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,325,1215414000"; 
   d="scan'208";a="31313420"
Subject: [PATCH -v2 4/8] kexec jump: remove duplication of
	kexec_restart_prepare()
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 14:52:39 +0800
Message-Id: <1218178359.22039.77.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call kernel_restart_prepare() in kernel_kexec() instead of duplicating
the code.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Pavel Machek <pavel@suse.cz>
Acked-by: Vivek Goyal <vgoyal@redhat.com>

---
 include/linux/reboot.h |    1 +
 kernel/kexec.c         |    6 +-----
 kernel/sys.c           |    2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -59,6 +59,7 @@ extern void machine_crash_shutdown(struc
  * Architecture independent implemenations of sys_reboot commands.
  */
 
+extern void kernel_restart_prepare(char *cmd);
 extern void kernel_restart(char *cmd);
 extern void kernel_halt(void);
 extern void kernel_power_off(void);
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -274,7 +274,7 @@ void emergency_restart(void)
 }
 EXPORT_SYMBOL_GPL(emergency_restart);
 
-static void kernel_restart_prepare(char *cmd)
+void kernel_restart_prepare(char *cmd)
 {
 	blocking_notifier_call_chain(&reboot_notifier_list, SYS_RESTART, cmd);
 	system_state = SYSTEM_RESTART;
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1472,11 +1472,7 @@ int kernel_kexec(void)
 	} else
 #endif
 	{
-		blocking_notifier_call_chain(&reboot_notifier_list,
-					     SYS_RESTART, NULL);
-		system_state = SYSTEM_RESTART;
-		device_shutdown();
-		sysdev_shutdown();
+		kernel_restart_prepare(NULL);
 		printk(KERN_EMERG "Starting new kernel\n");
 		machine_shutdown();
 	}


