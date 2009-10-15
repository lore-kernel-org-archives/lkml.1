Return-Path: <linux-kernel-owner+w=401wt.eu-S1762176AbZJOLYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762176AbZJOLYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 07:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756973AbZJOLYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 07:24:06 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:32800 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756809AbZJOLYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 07:24:04 -0400
Subject: Re: Leaks in trace reported by kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4AD6EF65.6080602@cn.fujitsu.com>
References: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
	 <4AD6EF65.6080602@cn.fujitsu.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 15 Oct 2009 12:22:58 +0100
Message-Id: <1255605778.10164.49.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2009 11:22:59.0193 (UTC) FILETIME=[D9B61E90:01CA4D89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-15 at 17:46 +0800, Li Zefan wrote:
> Zdenek Kabelac wrote:
> > I've noticed your latest patch for memory leak in filter setting
> > (8ad807318fcd...) - but even with this patch - kmemleak seems to still
> > report  lots  (~900) of following leaks - note - they come only from
> > i915 and kvm module - so I'm not sure if these two modules are doing
> > something wrong or the problem is in trace code.
> > 
> > It looks like whole directory is somehow forgotten.
> > 
> 
> Fortunately those are false-positives:
> 
>  # modprobe i915
>  # echo scan > /debug/kmemleak
>  # cat /debug/kmemleak
>  (lots of "leaks")
>  # rmmod i915
>  # echo scan > /debug/kmemleak
>  # cat /debug/kmemleak
>  (no leaks)
> 
> All the memory allocated when loading the module is
> freed in trace_module_remove_events() at module unload.
> 
> But I haven't looked into how to suppress those false-postives.
> I'd like to, but I'm going to leave my office and won't be
> back until 26th..

It is probably caused by the fact that kmemleak doesn't scan the
mod->trace_events data in a module (the _ftrace_events section). It only
scans those sections beginning with .data and .bss in a module. Maybe we
should add "_ftrace_events" as well or just prefix it with ".data".

Something like below may fix this (untested):

diff --git a/kernel/module.c b/kernel/module.c
index 8b7d880..1449691 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2383,6 +2383,9 @@ static noinline struct module *load_module(void __user *umod,
 					 "_ftrace_events",
 					 sizeof(*mod->trace_events),
 					 &mod->num_trace_events);
+	kmemleak_scan_area(mod->module_core, mod->trace_events,
+			   sizeof(*mod->trace_events) * mod->num_trace_events,
+			   GFP_KERNEL);
 #endif
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 	/* sechdrs[0].sh_size is always zero */


-- 
Catalin

