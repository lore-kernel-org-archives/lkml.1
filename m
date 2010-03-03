Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab0CCHxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:53:30 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49869 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab0CCHx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:53:29 -0500
To: <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 02 Mar 2010 23:53:19 -0800
Message-ID: <m1sk8hn8nk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [RFC][PATCH] init: Open /dev/console from rootfs
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


To avoid potential problems with an empty /dev open /dev/console
from rootfs instead of waiting to mount our root filesystem and
mounting it there.   This effectively guarantees that there will
be a device node, and it won't be on a filesystem that we will
ever unmount, so there are no issues with leaving /dev/console
open and pinning the filesystem.

This is actually more effective than automatically mounting
devtmpfs on /dev because it removes removes the occasionally
problematic assumption that /dev/console exists from the boot
code.

With this patch I was able to throw busybox on my /boot partition
(which has no /dev directory) and boot into userspace without
problems.

The only possible negative consequence I can think of is that
someone out there deliberately used did not use a character device
that is major 5 minor 2 for /dev/console.  Does anyone know of a
situation in which that could make sense?

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 init/do_mounts_initrd.c |    4 ----
 init/main.c             |   11 ++++++-----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 614241b..2b10853 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -30,11 +30,7 @@ static int __init do_linuxrc(void * shell)
 	extern char * envp_init[];
 
 	sys_close(old_fd);sys_close(root_fd);
-	sys_close(0);sys_close(1);sys_close(2);
 	sys_setsid();
-	(void) sys_open("/dev/console",O_RDWR,0);
-	(void) sys_dup(0);
-	(void) sys_dup(0);
 	return kernel_execve(shell, argv, envp_init);
 }
 
diff --git a/init/main.c b/init/main.c
index 67e40fc..9ba505f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -806,11 +806,6 @@ static noinline int init_post(void)
 	system_state = SYSTEM_RUNNING;
 	numa_default_policy();
 
-	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
-		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
-
-	(void) sys_dup(0);
-	(void) sys_dup(0);
 
 	current->signal->flags |= SIGNAL_UNKILLABLE;
 
@@ -864,6 +859,12 @@ static int __init kernel_init(void * unused)
 
 	do_basic_setup();
 
+	/* Open the /dev/console on the rootfs, this should never fail */
+	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
+		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
+
+	(void) sys_dup(0);
+	(void) sys_dup(0);
 	/*
 	 * check if there is an early userspace init.  If yes, let it do all
 	 * the work
-- 
1.6.5.2.143.g8cc62

