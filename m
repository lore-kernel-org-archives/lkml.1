Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbZDOGtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbZDOGtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZDOGt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:49:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:6819 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbZDOGt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:49:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,191,1239001200"; 
   d="scan'208";a="506568541"
Subject: Re: 2.6.30-rc2 hangs in get_measured_perf on tigerton
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <1239775283.2567.846.camel@ymzhang>
References: <1239775283.2567.846.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 Apr 2009 14:49:57 +0800
Message-Id: <1239778197.2567.849.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 14:01 +0800, Zhang, Yanmin wrote:
> My machine hanged with kernel 2.6.30-rc2 when script read
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor.
> 
> opps happens in get_measured_perf:
> 
>         cur.aperf.whole = readin.aperf.whole -
>                                 per_cpu(drv_data, cpu)->saved_aperf;
> 
> Because ﻿per_cpu(drv_data, cpu)=NULL.
> 
> So function get_measured_perf should check if (﻿per_cpu(drv_data, cpu)==NULL)
> and return 0 if it's NULL.
> 
> Other functions have such checking.
How about below patch? I tested it on my tigerton machine.

---

--- linux-2.6.30-rc2/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c	2009-04-15 02:24:38.000000000 -0400
+++ linux-2.6.30-rc2_cpufreqbug/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c	2009-04-15 02:31:37.000000000 -0400
@@ -277,6 +277,9 @@ static unsigned int get_measured_perf(st
 	unsigned int perf_percent;
 	unsigned int retval;
 
+	if (unlikely(per_cpu(drv_data, cpu) == NULL))
+		return 0;
+
 	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &readin, 1))
 		return 0;
 

> 
> yanmin
> 
> 
> 
> --------------sys log------------------
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
> IP: [<ffffffff8021af75>] get_measured_perf+0x4a/0xf9
> PGD a7dd88067 PUD a7ccf5067 PMD 0 
> Oops: 0000 [#1] SMP 
> last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> CPU 0 
> Modules linked in: video output
> Pid: 2091, comm: kondemand/0 Not tainted 2.6.30-rc2 #1 MP Server
> RIP: 0010:[<ffffffff8021af75>]  [<ffffffff8021af75>] get_measured_perf+0x4a/0xf9
> RSP: 0018:ffff880a7d56de20  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 00000046241a42b6 RCX: ffff88004d219000
> RDX: 000000000000b660 RSI: 0000000000000020 RDI: 0000000000000001
> RBP: ffff880a7f052000 R08: 00000046241a42b6 R09: ffffffff807639f0
> R10: 00000000ffffffea R11: ffffffff802207f4 R12: ffff880a7f052000
> R13: ffff88004d20e460 R14: 0000000000ddd5a6 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff88004d200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000020 CR3: 0000000a7f1bf000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kondemand/0 (pid: 2091, threadinfo ffff880a7d56c000, task ffff880a7d4d18c0)
> Stack:
>  ffff880a7f052078 ffffffff803efd54 00000046241a42b6 000000462ffa9e95
>  0000000000000001 0000000000000001 00000000ffffffea ffffffff8064f41a
>  0000000000000012 0000000000000012 ffff880a7f052000 ffffffff80650547
> Call Trace:
>  [<ffffffff803efd54>] ? kobject_get+0x12/0x17
>  [<ffffffff8064f41a>] ? __cpufreq_driver_getavg+0x42/0x57
>  [<ffffffff80650547>] ? do_dbs_timer+0x147/0x272
>  [<ffffffff80650400>] ? do_dbs_timer+0x0/0x272
>  [<ffffffff802474ca>] ? worker_thread+0x15b/0x1f5
>  [<ffffffff8024a02c>] ? autoremove_wake_function+0x0/0x2e
>  [<ffffffff8024736f>] ? worker_thread+0x0/0x1f5
>  [<ffffffff80249f0d>] ? kthread+0x54/0x83
>  [<ffffffff8020c87a>] ? child_rip+0xa/0x20
>  [<ffffffff80249eb9>] ? kthread+0x0/0x83
>  [<ffffffff8020c870>] ? child_rip+0x0/0x20
> Code: 99 a6 03 00 31 c9 85 c0 0f 85 c3 00 00 00 89 df 4c 8b 44 24 10 48 c7 c2 60 b6 00 00 48 8b 0c fd e0 30 a5 80 4c 89 c3 48 8b 04 0a <48> 2b 58 20 48 8b 44 24 18 48 89 1c 24 48 8b 34 0a 48 2b 46 28 
> RIP  [<ffffffff8021af75>] get_measured_perf+0x4a/0xf9
>  RSP <ffff880a7d56de20>
> CR2: 0000000000000020
> ---[ end trace 2b8fac9a49e19ad4 ]---
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

