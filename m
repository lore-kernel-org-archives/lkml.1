Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbYIXIaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbYIXIaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 04:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYIXIab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 04:30:31 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:12859 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbYIXIa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 04:30:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=NSU0kKAToHp5K1/5C5CHmOXhQ7fZs6jRuLg1fAwdj1yWxYhnYMAJPj/fc6OFMjqa9f
         WqXEusBIW26HS5/bHU2YFgYaYgzsB4JxS9gp5SZCeeasg3uT2Bawr6HNf/99glPNHmgu
         80YHXKII6bv0ejwZrsnzk9m9XJoCMRQFgsiZA=
Message-ID: <48DA0A09.5080709@gmail.com>
Date: Wed, 24 Sep 2008 10:36:09 +0100
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Patch -tip 0/4] Creation of the initcall tracer
References: <48D8C516.4090706@gmail.com> <20080923100034.GA23118@elte.hu> <20080923193106.GA21422@elte.hu>
In-Reply-To: <20080923193106.GA21422@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------080000080708080008000304"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080000080708080008000304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Ingo Molnar a écrit :
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> i've integrated tip/tracing/fastboot into tip/master and have started 
>> testing it. It passed the basic tests already so i've just pushed out 
>> the new tip/master. Please double-check that i have not messed up the 
>> rename or the integration somewhere.
> 
> FYI, -tip testing found a boot hang with CONFIG_BOOT_TRACER=y, on a 
> 32-bit T60 laptop. I've attached the config that provokes the hang. (you 
> need initcall_debug on the boot commandline)
> 
> The hang always happens after a specific initcall, shortly after tracing 
> is enabled. It just hangs indefinitely there, the last line displayed 
> was:
> 
>  [   0.004017] initcall ehci_hcd_init+0x0/0x80 returned 0 after 228 msecs
> 
> it should have printed this next:
> 
> [    0.808024] calling  ohci_hcd_mod_init+0x0/0x80 @ 10
> 
> but that line is never printed.
> 
> i've bisected the hang down to this specific commit:
> 
>  | 35df98dfe2b2503436a8cfda301657810df50a3a is first bad commit
>  | commit 35df98dfe2b2503436a8cfda301657810df50a3a
>  | Author: Frédéric Weisbecker <fweisbec@gmail.com>
>  | Date:   Tue Sep 23 11:38:18 2008 +0100
>  |
>  |     tracing/ftrace: launch boot tracing after pre-smp initcalls
> 
> An idea: maybe the boot tracer is interacting with the ftrace self-tests 
> somehow? CONFIG_FTRACE_SELFTEST=y is enabled.
> 
> another thing i noticed is that the sysprof tracer was initialized and 
> self-tested shortly before the hang occured. Might be unrelated.
> 
> the bisection log is:
> 
>  # bad:  [6522eab5] Merge branch 'x86/uv'
>  # good: [699b81f5] Merge branch 'x86/iommu'
>  # bad:  [8007aae9] timers: fix build error in !oneshot case
>  # good: [7f29b23d] Merge branch 'core/rcu'
>  # bad:  [a54f17e3] manual merge of tracing/fastboot
>  # good: [bcbbe946] tracing/ftrace: make tracing suitable to run the b
>  # good: [d7095e5a] Merge branch 'fastboot'
>  # bad:  [35df98df] tracing/ftrace: launch boot tracing after pre-smp
>  # good: [42aaa6be] tracing/ftrace: give an entry on the config for bo
> 
> 	Ingo
> 
Ingo Molnar a écrit :
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> i've integrated tip/tracing/fastboot into tip/master and have started 
>> testing it. It passed the basic tests already so i've just pushed out 
>> the new tip/master. Please double-check that i have not messed up the 
>> rename or the integration somewhere.
> 
> FYI, -tip testing found a boot hang with CONFIG_BOOT_TRACER=y, on a 
> 32-bit T60 laptop. I've attached the config that provokes the hang. (you 
> need initcall_debug on the boot commandline)
> 
> The hang always happens after a specific initcall, shortly after tracing 
> is enabled. It just hangs indefinitely there, the last line displayed 
> was:
> 
>  [   0.004017] initcall ehci_hcd_init+0x0/0x80 returned 0 after 228 msecs
> 
> it should have printed this next:
> 
> [    0.808024] calling  ohci_hcd_mod_init+0x0/0x80 @ 10
> 
> but that line is never printed.
> 
> i've bisected the hang down to this specific commit:
> 
>  | 35df98dfe2b2503436a8cfda301657810df50a3a is first bad commit
>  | commit 35df98dfe2b2503436a8cfda301657810df50a3a
>  | Author: Frédéric Weisbecker <fweisbec@gmail.com>
>  | Date:   Tue Sep 23 11:38:18 2008 +0100
>  |
>  |     tracing/ftrace: launch boot tracing after pre-smp initcalls
> 
> An idea: maybe the boot tracer is interacting with the ftrace self-tests 
> somehow? CONFIG_FTRACE_SELFTEST=y is enabled.
> 
> another thing i noticed is that the sysprof tracer was initialized and 
> self-tested shortly before the hang occured. Might be unrelated.
> 
> the bisection log is:
> 
>  # bad:  [6522eab5] Merge branch 'x86/uv'
>  # good: [699b81f5] Merge branch 'x86/iommu'
>  # bad:  [8007aae9] timers: fix build error in !oneshot case
>  # good: [7f29b23d] Merge branch 'core/rcu'
>  # bad:  [a54f17e3] manual merge of tracing/fastboot
>  # good: [bcbbe946] tracing/ftrace: make tracing suitable to run the b
>  # good: [d7095e5a] Merge branch 'fastboot'
>  # bad:  [35df98df] tracing/ftrace: launch boot tracing after pre-smp
>  # good: [42aaa6be] tracing/ftrace: give an entry on the config for bo
> 
> 	Ingo
> 

Hehe! I was preparing a patch because I saw last night that the self-tests were reseting and touching the ring-buffer during the initcall tracing.
And now I can see the results of this problem....

Following is a patch that should fix it.
Thanks for this report!
---
[Patch -tip] Disable tracers self-tests when boot tracer is selected

The tracing engine resets the ring buffer and the tracers touch it too during self-tests. These self-tests happen during tracers registering
and work against boot tracing which is logging initcalls.
We have to disable tracing self-tests if the boot-tracer is selected.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
---

--------------080000080708080008000304
Content-Type: text/plain;
 name="selftests.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="selftests.diff"

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 81a17ef..87c9282 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -126,7 +126,9 @@ config BOOT_TRACER
 	  the timings of the initcalls. Its aim is to be parsed by the
 	  /scripts/bootgraph.pl tool to produce pretty graphics about
 	  boot inefficiencies, giving a visual representation of the
-	  delays during initcalls.
+	  delays during initcalls. Note that tracers self tests can't
+	  be enabled if this tracer is selected since only one tracer
+	  should touch the tracing buffer at a time.
 
 config STACK_TRACER
 	bool "Trace max stack"
@@ -168,8 +170,7 @@ config FTRACE_SELFTEST
 
 config FTRACE_STARTUP_TEST
 	bool "Perform a startup test on ftrace"
-	depends on TRACING
-	depends on DEBUG_KERNEL
+	depends on TRACING && DEBUG_KERNEL && !BOOT_TRACER
 	select FTRACE_SELFTEST
 	help
 	  This option performs a series of startup tests on ftrace. On bootup

--------------080000080708080008000304--
