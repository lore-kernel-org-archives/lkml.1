Return-Path: <linux-kernel-owner+w=401wt.eu-S934039AbXCTTUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934039AbXCTTUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 15:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934041AbXCTTUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 15:20:39 -0400
Received: from mylar.outflux.net ([69.93.193.226]:33386 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934039AbXCTTUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 15:20:38 -0400
Date: Tue, 20 Mar 2007 12:20:16 -0700
From: Kees Cook <kees@outflux.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070320192016.GC22797@outflux.net>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <20070320103151.f65c81b6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320103151.f65c81b6.randy.dunlap@oracle.com>
Organization: Outflux
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 10:31:51AM -0700, Randy Dunlap wrote:
>   LD      .tmp_vmlinux1
> kernel/built-in.o:(.data+0xfc0): undefined reference to `maps_protect'
> make: *** [.tmp_vmlinux1] Error 1
> 
> with CONFIG_PROC_FS=n

Gah!  Apologies.  This should fix it, but I can't test it since I can't 
get 2.6.21-rc4-mm1 to compile (with or without this fix):

  GEN     .version
init/.missing_syscalls.h.cmd:2: *** missing separator.  Stop.
make: *** [.tmp_vmlinux1] Error 2


Signed-off-by: Kees Cook <kees@outflux.net>
---
diff -uNrp linux-2.6.21-rc4-mm1/kernel/sysctl.c linux-2.6.21-rc4-mm1-kees/kernel/sysctl.c
--- linux-2.6.21-rc4-mm1/kernel/sysctl.c	2007-03-20 10:45:06.000000000 -0700
+++ linux-2.6.21-rc4-mm1-kees/kernel/sysctl.c	2007-03-20 11:36:06.000000000 -0700
@@ -77,9 +77,12 @@ extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
-extern int maps_protect;
 extern int print_fatal_signals;
 
+#ifdef CONFIG_PROC_FS
+extern int maps_protect;
+#endif
+
 #if defined(CONFIG_ADAPTIVE_READAHEAD)
 extern int readahead_ratio;
 extern int readahead_hit_rate;
@@ -619,6 +622,7 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_PROC_FS
 	{
 		.ctl_name       = CTL_UNNUMBERED,
 		.procname       = "maps_protect",
@@ -627,6 +631,7 @@ static ctl_table kern_table[] = {
 		.mode           = 0644,
 		.proc_handler   = &proc_dointvec,
 	},
+#endif
 
 	{ .ctl_name = 0 }
 };




-- 
Kees Cook                                            @outflux.net
