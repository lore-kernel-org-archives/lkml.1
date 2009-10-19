Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbZJSDsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbZJSDsa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 23:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbZJSDs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 23:48:29 -0400
Received: from ozlabs.org ([203.10.76.45]:40773 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbZJSDs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 23:48:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Jones <davej@redhat.com>
Subject: Re: Fwd: [Bug 14340] New: speedstep-ich driver not working in 2.6.31
Date: Mon, 19 Oct 2009 14:18:21 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Dominik Brodowski <linux@brodo.de>, dave.mueller@gmx.ch,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20091007201108.GA16813@redhat.com>
In-Reply-To: <20091007201108.GA16813@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910191418.23238.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009 06:41:08 am Dave Jones wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=14340
> 
>            Summary: speedstep-ich driver not working in 2.6.31
>            Product: Power Management
>            Version: 2.5
>     Kernel Version: 2.6.31
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: cpufreq
>         AssignedTo: cpufreq@vger.kernel.org
>         ReportedBy: dave.mueller@gmx.ch
>         Regression: Yes
> 
> 
> It looks like commit 394122ab144dae4b276d74644a2f11c44a60ac5c broke the
> speedstep-ich driver.

Indeed.  And the patch in that bug report works, but is suboptimal: we no
longer need the struct at all.  You may want to apply that to -stable and
this to -linus.

Subject: speedstep-ich: fix error caused by 394122ab144dae4b276d74644a2f11c44a60ac5c

"[CPUFREQ] cpumask: avoid playing with cpus_allowed in speedstep-ich.c"
changed the code to mistakenly pass the current cpu as the "processor"
argument of speedstep_get_frequency(), whereas it should be the type of
the processor.

(Based on patch by dave.mueller@gmx.ch, compile-tested only)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Jones <davej@redhat.com>
To: Dominik Brodowski <linux@brodo.de>
Cc: dave.mueller@gmx.ch

diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
index 6911e91..3ae5a7a 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -232,28 +232,23 @@ static unsigned int speedstep_detect_chipset(void)
 	return 0;
 }
 
-struct get_freq_data {
-	unsigned int speed;
-	unsigned int processor;
-};
-
-static void get_freq_data(void *_data)
+static void get_freq_data(void *_speed)
 {
-	struct get_freq_data *data = _data;
+	unsigned int *speed = _speed;
 
-	data->speed = speedstep_get_frequency(data->processor);
+	*speed = speedstep_get_frequency(speedstep_processor);
 }
 
 static unsigned int speedstep_get(unsigned int cpu)
 {
-	struct get_freq_data data = { .processor = cpu };
+	unsigned int speed;
 
 	/* You're supposed to ensure CPU is online. */
-	if (smp_call_function_single(cpu, get_freq_data, &data, 1) != 0)
+	if (smp_call_function_single(cpu, get_freq_data, &speed, 1) != 0)
 		BUG();
 
-	dprintk("detected %u kHz as current frequency\n", data.speed);
-	return data.speed;
+	dprintk("detected %u kHz as current frequency\n", speed);
+	return speed;
 }
 
 /**
