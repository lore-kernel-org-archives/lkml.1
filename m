Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbZDHHBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbZDHHBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbZDHHBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:01:13 -0400
Received: from ozlabs.org ([203.10.76.45]:34557 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbZDHHBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:01:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Regression in 2.6.30-rc1 since commit acae0515 - wireless broken
Date: Wed, 8 Apr 2009 16:31:08 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       wireless <linux-wireless@vger.kernel.org>
References: <49DC2DF5.3010603@lwfinger.net> <49DC31EA.8050208@linux.intel.com>
In-Reply-To: <49DC31EA.8050208@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904081631.09150.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 April 2009 14:41:06 Arjan van de Ven wrote:
> Larry Finger wrote:
> > The most recent pulls of the Linux-2.6 git tree has broken wireless. The problem
> > was bisected with commit acae05156551fd7528fbb616271e672789388e3c, entitled
> > "module: create a request_module_nowait()", indicated as the faulty change. This
> > is seen with driver b43 on my system, and 2 reports for driver iwlagn:
> > http://marc.info/?l=linux-wireless&m=123916157630571&w=2 and
> > http://marc.info/?l=linux-wireless&m=123913015021457&w=2.
> > 
> > For b43, the logged error messages are:
> 
> rusty... I still suspect your "int to bool" conversion stuff ;-)

One way to find out.  Here's the reversion:

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -29,12 +29,10 @@
 #ifdef CONFIG_MODULES
 /* modprobe exit status on success, -ve on error.  Return value
  * usually useless though. */
-extern int __request_module(bool wait, const char *name, ...) \
-	__attribute__((format(printf, 2, 3)));
-#define request_module(mod...) __request_module(true, mod)
-#define request_module_nowait(mod...) __request_module(false, mod)
-#define try_then_request_module(x, mod...) \
-	((x) ?: (__request_module(false, mod), (x)))
+extern int __request_module(int wait, const char *name, ...) __attribute__ ((format (printf, 2, 3)));
+#define request_module(mod...) __request_module(1, mod)
+#define request_module_nowait(mod...) __request_module(0, mod)
+#define try_then_request_module(x, mod...) ((x) ?: (__request_module(0, mod), (x)))
 #else
 static inline int request_module(const char *name, ...) { return -ENOSYS; }
 static inline int request_module_nowait(const char *name, ...) { return -ENOSYS; }
diff --git a/kernel/kmod.c b/kernel/kmod.c
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -64,7 +64,8 @@ char modprobe_path[KMOD_PATH_LEN] = "/sb
  * If module auto-loading support is disabled then this function
  * becomes a no-operation.
  */
-int __request_module(bool wait, const char *fmt, ...)
+
+int __request_module(int wait, const char *fmt, ...)
 {
 	va_list args;
 	char module_name[MODULE_NAME_LEN];
