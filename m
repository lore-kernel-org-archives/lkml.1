Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbXL2Q3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbXL2Q3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 11:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbXL2Q3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 11:29:36 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:42048 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbXL2Q3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 11:29:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FABIFdkdMROHU/2dsb2JhbACBV6l/
Date: Sat, 29 Dec 2007 11:29:32 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org
Subject: [2.6.24 patch] Fix blackfin HARDWARE_PM support
Message-ID: <20071229162932.GC12262@Krystal>
References: <20071228185643.GB4738@stusta.de> <20071228192320.GI6780@does.not.exist> <20071228192855.GA23157@Krystal> <200712290114.46694.rgetz@blackfin.uclinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200712290114.46694.rgetz@blackfin.uclinux.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:26:10 up 55 days, 21:31,  4 users,  load average: 0.21, 0.43,
	0.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Robin, can you check if this patch does what is currently intended with
HARDWARE_PM please ? This involves testing with CONFIG_OPROFILE y/m/n.)

This patch restores the blackfin Hardware Performance Monitor Profiling
support that was killed by
commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.

Since there seems to be no good reason to behave differently from other
architectures, it now automatically selects the hardware performance counters
whenever the profiling is activated.

mach-common/irqpanic.c: pm_overflow
calls pm_overflow_handler which is in oprofile/op_model_bf533.c. I doubt that
setting HARDWARE_PM as "m" will work at all, since the pm_overflow_handler
should be in the core kernel image because it is called by irqpanic.c.

Therefore, I change HARDWARE_PM from a tristate to a bool.

The whole arch/$(ARCH)/oprofile/ is built depending on CONFIG_OPROFILE. Since
part of the HARDWARE_PM support files sits in this directory, it makes sense to
also depend on OPROFILE, not only PROFILING. Since OPROFILE already depends on
PROFILING, it is correct to only depend on OPROFILE only.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Adrian Bunk <adrian.bunk@movial.fi>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: bryan.wu@analog.com
CC: Robin Getz <rgetz@blackfin.uclinux.org>
---
 arch/blackfin/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6-lttng/arch/blackfin/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/blackfin/Kconfig	2007-12-29 11:00:05.000000000 -0500
+++ linux-2.6-lttng/arch/blackfin/Kconfig	2007-12-29 11:25:39.000000000 -0500
@@ -65,6 +65,10 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config HARDWARE_PM
+	def_bool y
+	depends on OPROFILE
+
 source "init/Kconfig"
 source "kernel/Kconfig.preempt"
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
