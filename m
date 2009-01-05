Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbZAENQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbZAENQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:16:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbZAENPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:15:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54338 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbZAENPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:15:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Cheng Renquan (=?utf-8?q?=E7=A8=8B=E4=BB=BB=E5=85=A8?=)" 
	<crquan@gmail.com>
Subject: Re: KPROBE linking error (who's the maintainer of kernel/power/) ?
Date: Mon, 5 Jan 2009 14:16:03 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: "Arjan van de Ven" <arjan@linux.intel.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Matt Helsley" <matthltc@us.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       mhiramat@redhat.com, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@suse.cz>
References: <91b13c310901042312o44afa166t66b23e8ad10d104f@mail.gmail.com>
In-Reply-To: <91b13c310901042312o44afa166t66b23e8ad10d104f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901051416.04816.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 05 January 2009, Cheng Renquan (程任全) wrote:
> with this .config
> 
> CONFIG_CGROUPS=y
> CONFIG_CGROUP_FREEZER=y
> CONFIG_MODULES=y
> CONFIG_FREEZER=y
> CONFIG_PM=y
> CONFIG_PM_SLEEP=n
> 
> the kernel will end compiling with error:
> 
> kernel/built-in.o: In function `check_safety':
> /usr/src/linux-2.6.28/kernel/kprobes.c:126: undefined reference to
> `freeze_processes'
> /usr/src/linux-2.6.28/kernel/kprobes.c:139: undefined reference to
> `thaw_processes'
> /usr/src/linux-2.6.28/kernel/kprobes.c:139: undefined reference to
> `thaw_processes'
> make: *** [.tmp_vmlinux1] Error 1

So there is a bug, thanks for the report.

> By read kernel/kprobes.c, I found there maybe a bug:
> 
> 1. "check_safety" in "kernel/kprobes.c" call thaw_processes if both
> CONFIG_PREEMPT and CONFIG_PM defined,
> 2. "thaw_processes" function is implemented in "kernel/power/process.c",
> 3. but it is only used if CONFIG_FREEZER defined, from <linux/freezer.h>,
> 4. else (CONFIG_FREEZER undefined) it's a null macro defined in
> <linux/freezer.h>,
> 5. but process.o only get compile if CONFIG_PM_SLEEP defined, from
> "kernel/power/Makefile",
> 
> Now I'm confused on how to resolve this?

I'd make process.o depend on CONFIG_FREEZER (patch below).

> What's the relation of PM, PM_SLEEP, and FREEZER?

PM_SLEEP depends on PM and FREEZER is defined in kernel/Kconfig.freezer as

config FREEZER
        def_bool PM_SLEEP || CGROUP_FREEZER

> Which modification of the following will be better?
> 1. modify kernel/Kconfig, let KPROBES depends more?
> 2. modify kernel/kprobes.c, let the conditional compile depends more?
> 3. modify include/linux/freezer.h, move thaw_processes to include/linux/pm.h?
> 4. modify kernel/power/Makefile, let kernel/power/process.c compile on
> less condition?
> 
> Furthermore, there seems no entry for maintainers of "kernel/power/",
> who maintain that subdir please add your name to the MAINTAINERS file?
> I just grab some latest touchers of kernel/power/ and kernel/kprobes.c
> as the recipients here.

I'm one of the maintainers.

Thanks,
Rafael

---
Subject: PM: Fix freezer compilation if PM_SLEEP is unset
From: Rafael J. Wysocki <rjw@sisk.pl>

Freezer fails to compile if with the following configuration
settings:

CONFIG_CGROUPS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_MODULES=y
CONFIG_FREEZER=y
CONFIG_PM=y
CONFIG_PM_SLEEP=n

Fix this by making process.o compilation depend on CONFIG_FREEZER.

Reported-by: Cheng Renquan <crquan@gmail.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/power/Makefile
===================================================================
--- linux-2.6.orig/kernel/power/Makefile
+++ linux-2.6/kernel/power/Makefile
@@ -4,7 +4,8 @@ EXTRA_CFLAGS	+=	-DDEBUG
 endif
 
 obj-y				:= main.o
-obj-$(CONFIG_PM_SLEEP)		+= process.o console.o
+obj-$(CONFIG_PM_SLEEP)		+= console.o
+obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_HIBERNATION)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o


