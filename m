Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbYE2Hc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbYE2Hc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 03:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYE2HcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 03:32:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38963 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbYE2HcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 03:32:19 -0400
Date: Thu, 29 May 2008 09:31:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 10 of 12] xen: implement save/restore
Message-ID: <20080529073150.GA19744@elte.hu>
References: <patchbomb.1211550067@localhost> <9e8d06e5ae8024829836.1211550077@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e8d06e5ae8024829836.1211550077@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> This patch implements Xen save/restore and migration.

-tip testing found the following build breakage:

  drivers/built-in.o: In function `xen_suspend':
  manage.c:(.text+0x4390f): undefined reference to `xen_console_resume'

with this config:

  http://redhat.com/~mingo/misc/config-Thu_May_29_09_23_16_CEST_2008.bad

i have bisected it down to:

|  commit 0e91398f2a5d4eb6b07df8115917d0d1cf3e9b58
|  Author: Jeremy Fitzhardinge <jeremy@goop.org>
|  Date:   Mon May 26 23:31:27 2008 +0100
|
|      xen: implement save/restore

the problem is that drivers/xen/manage.c is built unconditionally if 
CONFIG_XEN is enabled and makes use of xen_suspend(), but 
drivers/char/hvc_xen.c, where the xen_suspend() method is implemented, 
is only build if CONFIG_HVC_XEN=y as well.

i have solved this by providing a NOP implementation for xen_suspend() 
in the !CONFIG_HVC_XEN case.

	Ingo

---
 include/xen/hvc-console.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/include/xen/hvc-console.h
===================================================================
--- linux.orig/include/xen/hvc-console.h
+++ linux/include/xen/hvc-console.h
@@ -3,7 +3,11 @@
 
 extern struct console xenboot_console;
 
+#ifdef CONFIG_HVC_XEN
 void xen_console_resume(void);
+#else
+static inline void xen_console_resume(void) { }
+#endif
 
 void xen_raw_console_write(const char *str);
 void xen_raw_printk(const char *fmt, ...);
