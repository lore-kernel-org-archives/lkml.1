Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab0BQHU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 02:20:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50626 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0BQHU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 02:20:57 -0500
Date: Wed, 17 Feb 2010 08:20:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, gorcunov@gmail.com,
       aris@redhat.com, paulus@samba.org
Subject: Re: [PATCH 2/2] nmi_watchdog: properly configure for software events
Message-ID: <20100217072040.GA24587@elte.hu>
References: <1266357745-26671-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266357745-26671-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> Paul Mackerras brought up a good point that when fallbacking to
> software events, I may have been lucky in my configuration.
> 
> Modified the code to explicit provide a new configuration for
> software events.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  kernel/nmi_watchdog.c |   23 ++++++++++++++++++-----
>  1 files changed, 18 insertions(+), 5 deletions(-)

Applied, thanks Don!

btw., a few minor code cleanliness nits:

> 
> diff --git a/kernel/nmi_watchdog.c b/kernel/nmi_watchdog.c
> index 633b230..3c75cbf 100644
> --- a/kernel/nmi_watchdog.c
> +++ b/kernel/nmi_watchdog.c
> @@ -61,7 +61,7 @@ static int __init setup_nmi_watchdog(char *str)
>  }
>  __setup("nmi_watchdog=", setup_nmi_watchdog);
>  
> -struct perf_event_attr wd_attr = {
> +struct perf_event_attr wd_hw_attr = {
>  	.type = PERF_TYPE_HARDWARE,
>  	.config = PERF_COUNT_HW_CPU_CYCLES,
>  	.size = sizeof(struct perf_event_attr),
> @@ -69,6 +69,14 @@ struct perf_event_attr wd_attr = {
>  	.disabled = 1,
>  };
>  
> +struct perf_event_attr wd_sw_attr = {
> +	.type = PERF_TYPE_SOFTWARE,
> +	.config = PERF_COUNT_SW_CPU_CLOCK,
> +	.size = sizeof(struct perf_event_attr),
> +	.pinned = 1,
> +	.disabled = 1,
> +};

Please use the vertically aligned initializer style we are using in arch/x86 
and in the perf code as well:

struct perf_event_attr wd_sw_attr = {
	.type			= PERF_TYPE_SOFTWARE,
	.config			= PERF_COUNT_SW_CPU_CLOCK,
	.size			= sizeof(struct perf_event_attr),
	.pinned			= 1,
	.disabled		= 1,
};

Plus see below the errors and warnings that scripts/checkpatch -f 
kernel/nmi_watchdog.c found. Most of those (except the col 80 warnings which 
you should ignore) should be fixed i suspect.

Thanks,

	Ingo

ERROR: code indent should use tabs where possible
#53: FILE: nmi_watchdog.c:53:
+        if (!strncmp(str, "panic", 5)) {$

ERROR: code indent should use tabs where possible
#54: FILE: nmi_watchdog.c:54:
+                panic_on_timeout = 1;$

ERROR: code indent should use tabs where possible
#55: FILE: nmi_watchdog.c:55:
+                str = strchr(str, ',');$

ERROR: code indent should use tabs where possible
#56: FILE: nmi_watchdog.c:56:
+                if (!str)$

ERROR: code indent should use tabs where possible
#57: FILE: nmi_watchdog.c:57:
+                        return 1;$

ERROR: code indent should use tabs where possible
#58: FILE: nmi_watchdog.c:58:
+                ++str;$

ERROR: code indent should use tabs where possible
#59: FILE: nmi_watchdog.c:59:
+        }$

ERROR: code indent should use tabs where possible
#60: FILE: nmi_watchdog.c:60:
+        return 1;$

CHECK: __setup appears un-documented -- check Documentation/kernel-parameters.txt
#62: FILE: nmi_watchdog.c:62:
+__setup("nmi_watchdog=", setup_nmi_watchdog);

ERROR: space required after that ',' (ctx:VxV)
#98: FILE: nmi_watchdog.c:98:
+		per_cpu(alert_counter,cpu) += 1;
 		                     ^

ERROR: space required after that ',' (ctx:VxV)
#99: FILE: nmi_watchdog.c:99:
+		if (per_cpu(alert_counter,cpu) == 5) {
 		                         ^

WARNING: braces {} are not necessary for any arm of this statement
#100: FILE: nmi_watchdog.c:100:
+			if (panic_on_timeout) {
[...]
+			} else {
[...]

WARNING: line over 80 characters
#101: FILE: nmi_watchdog.c:101:
+				panic("NMI Watchdog detected LOCKUP on cpu %d", cpu);

WARNING: line over 80 characters
#103: FILE: nmi_watchdog.c:103:
+				WARN(1, "NMI Watchdog detected LOCKUP on cpu %d", cpu);

ERROR: space required after that ',' (ctx:VxV)
#107: FILE: nmi_watchdog.c:107:
+		per_cpu(alert_counter,cpu) = 0;
 		                     ^

WARNING: line over 80 characters
#126: FILE: nmi_watchdog.c:126:
+		event = perf_event_create_kernel_counter(wd_attr, cpu, -1, wd_overflow);

WARNING: line over 80 characters
#128: FILE: nmi_watchdog.c:128:
+			/* hardware doesn't exist or not supported, fallback to software events */

WARNING: printk() should include KERN_ facility level
#129: FILE: nmi_watchdog.c:129:
+			printk("nmi_watchdog: hardware not available, trying software events\n");

WARNING: line over 80 characters
#132: FILE: nmi_watchdog.c:132:
+			event = perf_event_create_kernel_counter(wd_attr, cpu, -1, wd_overflow);

WARNING: line over 80 characters
#134: FILE: nmi_watchdog.c:134:
+				printk(KERN_ERR "nmi watchdog failed to create perf event on %i: %p\n", cpu, event);

WARNING: printk() should include KERN_ facility level
#185: FILE: nmi_watchdog.c:185:
+				printk("NMI watchdog failed configuration, "

CHECK: __setup appears un-documented -- check Documentation/kernel-parameters.txt
#238: FILE: nmi_watchdog.c:238:
+__setup("nonmi_watchdog", nonmi_watchdog_setup);

total: 11 errors, 9 warnings, 2 checks, 258 lines checked

kernel/nmi_watchdog.c has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
