Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbYAORrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbYAORrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbYAORrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:47:10 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:49705 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbYAORrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:47:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HACCAjEdMROHU/2dsb2JhbACBV6oh
Date: Tue, 15 Jan 2008 12:42:02 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <adrian.bunk@movial.fi>,
       Randy Dunlap <randy.dunlap@oracle.com>, bryan.wu@analog.com,
       Robin Getz <rgetz@blackfin.uclinux.org>
Cc: linux-kernel@vger.kernel.org
Subject: Fix Blackfin HARDWARE_PM support
Message-ID: <20080115174202.GD8375@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:40:18 up 72 days, 22:45,  6 users,  load average: 0.52, 0.54,
	0.59
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Thanks to Adrian Bunk for finding this bug and providing an initial
patch.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>
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
