Return-Path: <linux-kernel-owner+w=401wt.eu-S1752259AbZGWFMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbZGWFMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 01:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZGWFMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 01:12:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45851 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbZGWFMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 01:12:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A67F12A.9060204@jp.fujitsu.com>
Date: Thu, 23 Jul 2009 14:12:10 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
       Neil Horman <nhorman@tuxdriver.com>, Vivek Goyal <vgoyal@redhat.com>,
       Brayan Arraes <brayan@yack.com.br>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] sysrq, kdump: Make sysrq-c consistent
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ based on 2.6.31-rc4 ]

Recent commit d6580a9f15238b87e618310c862231ae3f352d2d changed the
behavior of sysrq-c to unconditional dereference of NULL pointer.
So in cases with CONFIG_KEXEC, where crash_kexec() was directly called
from sysrq-c before, now it can be said that a step of "real oops" was
inserted before starting kdump.

However, in contrast to oops via SysRq-c from keyboard which results
in panic due to in_interrupt(), oops via "echo c > /proc/sysrq-trigger"
will not become panic unless panic_on_oops=1.  It means that even if
dump is properly configured to be taken on panic, the sysrq-c from proc
interface might not start crashdump while the sysrq-c from keyboard can
start crashdump.  This confuses traditional users of kdump, i.e. people
who expect sysrq-c to do common behavior in both of the keyboard and
proc interface.

This patch brings the keyboard and proc interface behavior of sysrq-c
in line, by forcing panic_on_oops=1 before oops in sysrq-c handler.

And some updates in documentation are included, to clarify that there
is no longer dependency with CONFIG_KEXEC, and that now the system can
just crash by sysrq-c if no dump mechanism is configured.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Brayan Arraes <brayan@yack.com.br>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 Documentation/sysrq.txt |    7 ++++---
 drivers/char/sysrq.c    |    8 +++++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/Documentation/sysrq.txt b/Documentation/sysrq.txt
index cf42b82..d56a017 100644
--- a/Documentation/sysrq.txt
+++ b/Documentation/sysrq.txt
@@ -66,7 +66,8 @@ On all -  write a character to /proc/sysrq-trigger.  e.g.:
 'b'     - Will immediately reboot the system without syncing or unmounting
           your disks.
 
-'c'	- Will perform a kexec reboot in order to take a crashdump.
+'c'	- Will perform a system crash by a NULL pointer dereference.
+          A crashdump will be taken if configured.
 
 'd'	- Shows all locks that are held.
 
@@ -141,8 +142,8 @@ useful when you want to exit a program that will not let you switch consoles.
 re'B'oot is good when you're unable to shut down. But you should also 'S'ync
 and 'U'mount first.
 
-'C'rashdump can be used to manually trigger a crashdump when the system is hung.
-The kernel needs to have been built with CONFIG_KEXEC enabled.
+'C'rash can be used to manually trigger a crashdump when the system is hung.
+Note that this just triggers a crash if there is no dump mechanism available.
 
 'S'ync is great when your system is locked up, it allows you to sync your
 disks and will certainly lessen the chance of data loss and fscking. Note
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 0db3585..5d7a02f 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -35,7 +35,6 @@
 #include <linux/spinlock.h>
 #include <linux/vt_kern.h>
 #include <linux/workqueue.h>
-#include <linux/kexec.h>
 #include <linux/hrtimer.h>
 #include <linux/oom.h>
 
@@ -124,9 +123,12 @@ static struct sysrq_key_op sysrq_unraw_op = {
 static void sysrq_handle_crash(int key, struct tty_struct *tty)
 {
 	char *killer = NULL;
+
+	panic_on_oops = 1;	/* force panic */
+	wmb();
 	*killer = 1;
 }
-static struct sysrq_key_op sysrq_crashdump_op = {
+static struct sysrq_key_op sysrq_crash_op = {
 	.handler	= sysrq_handle_crash,
 	.help_msg	= "Crash",
 	.action_msg	= "Trigger a crash",
@@ -401,7 +403,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
 	 */
 	NULL,				/* a */
 	&sysrq_reboot_op,		/* b */
-	&sysrq_crashdump_op,		/* c & ibm_emac driver debug */
+	&sysrq_crash_op,		/* c & ibm_emac driver debug */
 	&sysrq_showlocks_op,		/* d */
 	&sysrq_term_op,			/* e */
 	&sysrq_moom_op,			/* f */
-- 
1.6.0

