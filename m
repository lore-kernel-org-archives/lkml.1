Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYJXP0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYJXP0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 11:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYJXP0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 11:26:21 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:56940 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbYJXP0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 11:26:20 -0400
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27.3 usbcore] Move __module_param_call(nousb) toimmediately after declaration of nousb.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200810240158.m9O1w2PX032608@www262.sakura.ne.jp>
	<20081024041917.GA16594@kroah.com>
In-Reply-To: <20081024041917.GA16594@kroah.com>
Message-Id: <200810250026.EGB05240.HJtQFOMSOVOFFL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 25 Oct 2008 00:26:15 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I succeeded to produce this problem with 2.6.26 .
Thus, at least, it is not a new bug introduced in 2.6.27 .

Greg KH wrote:
> This really sounds like a compiler bug somewhere, reordering this
> shouldn't "fix" this issue.

I think so too.

> Is 3.3.5 still supported by the Debian team?

I think Security Support for Debian Sarge terminated on March 31st 2008.

> I know the minimum gcc version is 3.2 for the kernel, so it's
> strange that no one else sees this.

Thus, it is likely that nobody is using gcc (GCC) 3.3.5 (Debian 1:3.3.5-13).

> Can you duplicate this in a stand-alone test module?

Here is the patch for 2.6.26.7 and 2.6.27.3 .
But... please check this patch carefully. It seems that something is wrong.

----------------------------------------
---
 drivers/usb/Makefile    |    2 ++
 drivers/usb/paramtest.c |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

--- linux-2.6.26.7.orig/drivers/usb/Makefile
+++ linux-2.6.26.7/drivers/usb/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the kernel USB device drivers.
 #
 
+obj-y                           += paramtest.o
+
 # Object files in subdirectories
 
 obj-$(CONFIG_USB)		+= core/
--- /dev/null
+++ linux-2.6.26.7/drivers/usb/paramtest.c
@@ -0,0 +1,38 @@
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+
+static int param1;
+module_param(param1, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(param1, "param1");
+
+static int param2;
+module_param (param2, bool, S_IRUGO);
+MODULE_PARM_DESC (param2, "param2");
+
+static int param3;
+module_param(param3, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(param3, "param3");
+
+static int param4;
+module_param(param4, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(param4, "param4");
+
+static int param5;
+__module_param_call("", param5, param_set_bool, param_get_bool, &param5, 0444);
+
+static int param6;
+module_param_named(paramtest, param6, int, 0644);
+MODULE_PARM_DESC(paramtest, "param6");
+
+static int __init paramtest_init(void)
+{
+	return 0;
+}
+
+static void __exit paramtest_exit(void)
+{
+}
+
+subsys_initcall(paramtest_init);
+module_exit(paramtest_exit);
+MODULE_LICENSE("GPL");
----------------------------------------

Did I make a mistake in the above patch?
I tested after applying the above patch, and all results are wrong.

----------------------------------------
# cat /proc/version
Linux version 2.6.27.3 (root@tomoyo) (gcc version 4.1.2 20071124 (Red Hat 4.1.2-42)) #2 SMP Fri Oct 24 23:45:52 JST 2008
# ls -ail /sys/module/paramtest/parameters/
total 0
197 drwxr-xr-x 2 root root    0 Oct 24 23:49 .
196 drwxr-xr-x 3 root root    0 Oct 24 23:49 ..
199 -r--r--r-- 1 root root 4096 Oct 24 23:49 amtest.param4
202 -r--r--r-- 1 root root 4096 Oct 24 23:49 param2
201 -rw-r--r-- 1 root root 4096 Oct 24 23:49 param3
200 -rw-r--r-- 1 root root 4096 Oct 24 23:49 param4
198 -rw-r--r-- 1 root root 4096 Oct 24 23:49 paramtest
----------
# cat /proc/version
Linux version 2.6.26.7 (root@tomoyo) (gcc version 4.1.2 20071124 (Red Hat 4.1.2-42)) #2 SMP Fri Oct 24 23:47:07 JST 2008
# ls -ail /sys/module/paramtest/parameters/
total 0
197 drwxr-xr-x 2 root root    0 Oct 24 23:52 .
196 drwxr-xr-x 3 root root    0 Oct 24 23:52 ..
199 -r--r--r-- 1 root root 4096 Oct 24 23:52 amtest.param4
202 -r--r--r-- 1 root root 4096 Oct 24 23:52 param2
201 -rw-r--r-- 1 root root 4096 Oct 24 23:52 param3
200 -rw-r--r-- 1 root root 4096 Oct 24 23:52 param4
198 -rw-r--r-- 1 root root 4096 Oct 24 23:52 paramtest
----------
# cat /proc/version
Linux version 2.6.27.3 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #2 SMP Fri Oct 24 22:12:09 JST 2008
tomoyo:~# ls -ail /sys/module/paramtest/parameters/
total 0
197 drwxr-xr-x  2 root root    0 Oct 24 22:14 .
196 drwxr-xr-x  3 root root    0 Oct 24 22:14 ..
202 -r--r--r--  1 root root 4096 Oct 24 22:14 amtest.paramtest
198 -rw-r--r--  1 root root 4096 Oct 24 22:14 param1
199 -r--r--r--  1 root root 4096 Oct 24 22:14 param2
200 -rw-r--r--  1 root root 4096 Oct 24 22:14 param3
201 -rw-r--r--  1 root root 4096 Oct 24 22:14 param4
----------
# cat /proc/version
Linux version 2.6.26.7 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #2 SMP Fri Oct 24 22:10:11 JST 2008
tomoyo:~# ls -ail /sys/module/paramtest/parameters/
total 0
197 drwxr-xr-x  2 root root    0 Oct 24 22:16 .
196 drwxr-xr-x  3 root root    0 Oct 24 22:16 ..
202 -r--r--r--  1 root root 4096 Oct 24 22:16 amtest.paramtest
198 -rw-r--r--  1 root root 4096 Oct 24 22:16 param1
199 -r--r--r--  1 root root 4096 Oct 24 22:16 param2
200 -rw-r--r--  1 root root 4096 Oct 24 22:16 param3
201 -rw-r--r--  1 root root 4096 Oct 24 22:16 param4
----------------------------------------

However, applying the below patch after the above patch
prevents this problem from appearing.

----------------------------------------
---
 drivers/usb/paramtest.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.26.7.orig/drivers/usb/paramtest.c
+++ linux-2.6.26.7/drivers/usb/paramtest.c
@@ -18,12 +18,13 @@ module_param(param4, bool, S_IRUGO | S_I
 MODULE_PARM_DESC(param4, "param4");
 
 static int param5;
-__module_param_call("", param5, param_set_bool, param_get_bool, &param5, 0444);
 
 static int param6;
 module_param_named(paramtest, param6, int, 0644);
 MODULE_PARM_DESC(paramtest, "param6");
 
+__module_param_call("", param5, param_set_bool, param_get_bool, &param5, 0444);
+
 static int __init paramtest_init(void)
 {
 	return 0;
----------------------------------------

----------------------------------------
# cat /proc/version
Linux version 2.6.27.3 (root@tomoyo) (gcc version 4.1.2 20071124 (Red Hat 4.1.2-42)) #3 SMP Fri Oct 24 23:55:21 JST 2008
# ls -ail /sys/module/paramtest/parameters/
total 0
197 drwxr-xr-x 2 root root    0 Oct 25 00:00 .
196 drwxr-xr-x 3 root root    0 Oct 25 00:00 ..
202 -rw-r--r-- 1 root root 4096 Oct 25 00:00 param1
201 -r--r--r-- 1 root root 4096 Oct 25 00:00 param2
200 -rw-r--r-- 1 root root 4096 Oct 25 00:00 param3
199 -rw-r--r-- 1 root root 4096 Oct 25 00:00 param4
198 -rw-r--r-- 1 root root 4096 Oct 25 00:00 paramtest
----------
# cat /proc/version
Linux version 2.6.26.7 (root@tomoyo) (gcc version 4.1.2 20071124 (Red Hat 4.1.2-42)) #3 SMP Fri Oct 24 23:56:17 JST 2008
# ls -ail /sys/module/paramtest/parameters/
total 0
197 drwxr-xr-x 2 root root    0 Oct 25 00:01 .
196 drwxr-xr-x 3 root root    0 Oct 25 00:01 ..
202 -rw-r--r-- 1 root root 4096 Oct 25 00:01 param1
201 -r--r--r-- 1 root root 4096 Oct 25 00:01 param2
200 -rw-r--r-- 1 root root 4096 Oct 25 00:01 param3
199 -rw-r--r-- 1 root root 4096 Oct 25 00:01 param4
198 -rw-r--r-- 1 root root 4096 Oct 25 00:01 paramtest
----------
# cat /proc/version
Linux version 2.6.27.3 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #3 SMP Fri Oct 24 22:18:06 JST 2008
tomoyo:~# ls -ail /sys/module/paramtest/parameters/
total 0
197 drwxr-xr-x  2 root root    0 Oct 24 22:21 .
196 drwxr-xr-x  3 root root    0 Oct 24 22:21 ..
198 -rw-r--r--  1 root root 4096 Oct 24 22:21 param1
199 -r--r--r--  1 root root 4096 Oct 24 22:21 param2
200 -rw-r--r--  1 root root 4096 Oct 24 22:21 param3
201 -rw-r--r--  1 root root 4096 Oct 24 22:21 param4
202 -rw-r--r--  1 root root 4096 Oct 24 22:21 paramtest
----------
# cat /proc/version
Linux version 2.6.26.7 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #3 SMP Fri Oct 24 22:19:26 JST 2008
tomoyo:~# ls -ail /sys/module/paramtest/parameters/
total 0
197 drwxr-xr-x  2 root root    0 Oct 24 22:24 .
196 drwxr-xr-x  3 root root    0 Oct 24 22:24 ..
198 -rw-r--r--  1 root root 4096 Oct 24 22:24 param1
199 -r--r--r--  1 root root 4096 Oct 24 22:24 param2
200 -rw-r--r--  1 root root 4096 Oct 24 22:24 param3
201 -rw-r--r--  1 root root 4096 Oct 24 22:24 param4
202 -rw-r--r--  1 root root 4096 Oct 24 22:24 paramtest
----------------------------------------

Well, I'm getting more and more confused.
It may be gcc3's bug, it may not be gcc's bug.

Regards.
