Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbZJPOMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbZJPOMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 10:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759144AbZJPOMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 10:12:34 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:38515 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758982AbZJPOMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 10:12:34 -0400
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Leaks in trace reported by kmemleak
References: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
	<4AD6EF65.6080602@cn.fujitsu.com>
	<1255605778.10164.49.camel@pc1117.cambridge.arm.com>
	<c4e36d110910160045y52d80450g1d803dd2090a2bd8@mail.gmail.com>
	<1255690674.3008.24.camel@pc1117.cambridge.arm.com>
	<c4e36d110910160632y4448475dp1ae66dfc01ff8448@mail.gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 16 Oct 2009 15:11:23 +0100
In-Reply-To: <c4e36d110910160632y4448475dp1ae66dfc01ff8448@mail.gmail.com> (Zdenek Kabelac's message of "Fri\, 16 Oct 2009 15\:32\:59 +0200")
Message-ID: <tnxbpk7a0ok.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Oct 2009 14:11:24.0915 (UTC) FILETIME=[8B9AAC30:01CA4E6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
> Yes -same - though I forget to mention that log contained these two
> extra messages:
> (got lost in other debug stuff :( )...
>
> So it could be the parameters in your first patch were not correct ?
>
> [drm] Initialized drm 1.1.0 20060810
> kmemleak: Scan area larger than object 0xffffffffa033b000

Ah, I forgot that kmemleak_scan_area takes an offset inside an object
rather than an absolute address. Something like below (I should
actually change this prototype of this function, it doesn't need to be
so complex):

diff --git a/kernel/module.c b/kernel/module.c
index 8b7d880..8cc4406 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2383,6 +2383,10 @@ static noinline struct module *load_module(void __user *umod,
 					 "_ftrace_events",
 					 sizeof(*mod->trace_events),
 					 &mod->num_trace_events);
+	kmemleak_scan_area(mod->module_core, (unsigned long)mod->trace_events -
+			   (unsigned long)mod->module_core,
+			   sizeof(*mod->trace_events) * mod->num_trace_events,
+			   GFP_KERNEL);
 #endif
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 	/* sechdrs[0].sh_size is always zero */

> BTW - it's kind of ugly - that module removal destroys stack trace -
> it would be nice to see some hook for module unload - to eventually
> create a permanent stack trace for this occasion??

Kmemleak only uses whatever stacktrace mechanism is available in the
kernel. Resolving the symbol names when objects are allocated would
slow it down and it takes up more space in the traces. I don't have a
proper solution.

-- 
Catalin
