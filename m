Return-Path: <linux-kernel-owner+w=401wt.eu-S1422953AbXCBGTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422953AbXCBGTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 01:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422957AbXCBGS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 01:18:59 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44747 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422953AbXCBGS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 01:18:58 -0500
Date: Thu, 1 Mar 2007 22:15:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] <linux/sysdev.h> needs to include <linux/module.h>
Message-Id: <20070301221541.9e48bbc3.akpm@linux-foundation.org>
In-Reply-To: <20070224122211.GA17040@linux-mips.org>
References: <20070224122211.GA17040@linux-mips.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Feb 2007 12:22:11 +0000 Ralf Baechle <ralf@linux-mips.org> wrote:

> sysdev.h uses THIS_MODULE so should include <linux/module.h>.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> 
> diff --git a/include/linux/sysdev.h b/include/linux/sysdev.h
> index 389ccf8..e699ab2 100644
> --- a/include/linux/sysdev.h
> +++ b/include/linux/sysdev.h
> @@ -22,6 +22,7 @@
>  #define _SYSDEV_H_
>  
>  #include <linux/kobject.h>
> +#include <linux/module.h>
>  #include <linux/pm.h>
>  


You can't just make changes like this without a lot of compile testing, I'm
afraid.

This causes a recursive inclusion and sched.h blows up:

In file included from include/linux/utsname.h:35,
                 from include/asm/elf.h:12,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:15,
                 from include/linux/sysdev.h:25,
                 from kernel/time/clocksource.c:28:
include/linux/sched.h:1648: warning: 'struct sysdev_class' declared inside parameter list
include/linux/sched.h:1648: warning: its scope is only this definition or declaration, which is probably not what you want


I think we can fix that by moving the declarations into cpu.h and getting
that unpleasant include out of sched.h.

Of course, this will probably make other things blow up and additional
sysdev.h includes will now be needed.  We'll see..





diff -puN include/linux/cpu.h~linux-sysdevh-needs-to-include-linux-moduleh-up-fix include/linux/cpu.h
--- a/include/linux/cpu.h~linux-sysdevh-needs-to-include-linux-moduleh-up-fix
+++ a/include/linux/cpu.h
@@ -41,6 +41,9 @@ extern void cpu_remove_sysdev_attr(struc
 extern int cpu_add_sysdev_attr_group(struct attribute_group *attrs);
 extern void cpu_remove_sysdev_attr_group(struct attribute_group *attrs);
 
+extern struct sysdev_attribute attr_sched_mc_power_savings;
+extern struct sysdev_attribute attr_sched_smt_power_savings;
+extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls);
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
diff -puN include/linux/sched.h~linux-sysdevh-needs-to-include-linux-moduleh-up-fix include/linux/sched.h
--- a/include/linux/sched.h~linux-sysdevh-needs-to-include-linux-moduleh-up-fix
+++ a/include/linux/sched.h
@@ -1642,10 +1642,7 @@ static inline void arch_pick_mmap_layout
 extern long sched_setaffinity(pid_t pid, cpumask_t new_mask);
 extern long sched_getaffinity(pid_t pid, cpumask_t *mask);
 
-#include <linux/sysdev.h>
 extern int sched_mc_power_savings, sched_smt_power_savings;
-extern struct sysdev_attribute attr_sched_mc_power_savings, attr_sched_smt_power_savings;
-extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls);
 
 extern void normalize_rt_tasks(void);
 
_

