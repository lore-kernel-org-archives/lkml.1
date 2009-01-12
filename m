Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbZALKBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbZALKBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZALKBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:01:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40781 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbZALKBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:01:12 -0500
Date: Mon, 12 Jan 2009 11:00:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Dieter Ries <clip2@gmx.de>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
Message-ID: <20090112100053.GA7905@elte.hu>
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu> <496A3F62.8090902@gmx.de> <496A4228.5090807@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496A4228.5090807@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Dieter Ries wrote:
> > Hi,
> > 
> > Ingo Molnar schrieb:
> >>>> * Dieter Ries <clip2@gmx.de> wrote:
> >>>>
> >>>>> Hi,
> >>>>>
> >>>>> I just pulled 2.6.29-rc1, ran oldconfig with defaults and built it.
> >>>>> When I try to boot it, that kind of works until init should start. Then
> >>>>> nothing happens. I tried with init=/bin/bash, which sometimes works, and
> >>>>> sometimes gets me a bash without the prompt flashing.
> >>>>>
> >>>>> I captured the output with netconsole, but I cannot see a problem there.
> >>>>> It is attached.
> >>>>>
> >>>>> My config is also attached.
> >>>>>
> >>>>> The machine:
> >>>>>
> >>>>> Lenovo Thinkpad T60
> >>>>> Core2Duo 2GHz
> >>>>>
> >>>>> Gentoo 64bit
> >>>>>
> >>>>>
> >>>>> What else should I provide for debugging that?
> >> Unless you can see some particular badness in the kernel messages 
> >> (something that changed to the last working version) that narrows it down 
> >> to some subsystem, i suspect this would have to be bisected ...
> > 
> > Bisected it:
> > 
> > ####################################################################
> > 7503bfbae89eba07b46441a5d1594647f6b8ab7d is first bad commit
> > commit 7503bfbae89eba07b46441a5d1594647f6b8ab7d
> > Author: Mike Travis <travis@sgi.com>
> > Date:   Sun Jan 4 05:18:09 2009 -0800
> > 
> > cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
> > 
> > Impact: use new cpumask API to reduce stack usage
> > 
> > Replace the saving of current->cpus_allowed and set_cpus_allowed_ptr()
> > with a work_on_cpu function for drv_read() and drv_write().
> > 
> > Basically converts do_drv_{read,write} into "work_on_cpu" functions that
> > are now called by drv_read and drv_write.
> > 
> > Signed-off-by: Mike Travis <travis@sgi.com>
> > Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ####################################################################
> > 
> > I reverted that patch, which makes my machine boot again. So I guess
> > theres something wrong here. Please tell me which information you need
> > to fix the problem, I will help as I can.
> > 
> > 
> >> 	Ingo
> >>
> > 
> > cu
> > Dieter
> > 
> 
> Thanks for catching this.
> 
> The work_on_cpu approach seems to create more problems than it solves.  
> And testing it has proven difficult without the right combination of 
> hardware.
> 
> Could you send me the console log and config file?
> 
> Rusty - any ideas on how to avoid these clashes with the 
> get_online_cpus() call in work_on_cpu()?  Or something else to indicate 
> to lockdep that the circular lock dependency is ok (as you mentioned 
> before)?

I've queued up the revert below, please check the commit message whether 
you agree with the analysis.

Mike, could you also check any other patches where you add work_on_cpu() 
usage to make sure we dont have similar mishaps? work_on_cpu() seems 
completely unsuited for any sort of set_cpus_allowed() replacement ...

	Ingo

---------------->
>From e0b7a3bea054249b27ca3c843bf6eefcb509d1c2 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 12 Jan 2009 10:49:53 +0100
Subject: [PATCH] Revert "cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write"

This reverts commit 7503bfbae89eba07b46441a5d1594647f6b8ab7d.

Dieter Ries reported bootup soft-hangs and bisected it back to
this commit, and reverting this commit gave him a working system.

The commit introduces work_on_cpu() use into the cpufreq code,
but that is subtly problematic from a lock hierarchy POV: the
hotplug-cpu lock is an highlevel lock that is taken before
lowlevel locks, and in this codepath we are called with the
policy lock taken.

Dieter did not have lockdep enabled so we dont have a nice stack
trace proof for this, but using work_on_cpu() in such a lowlevel
place certainly looks wrong, so we revert the patch.

work_on_cpu() needs to be reworked to be more generally usable.

Reported-by: Dieter Ries <clip2@gmx.de>
Tested-by: Dieter Ries <clip2@gmx.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 06fcd8f..6f11e02 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -150,9 +150,8 @@ struct drv_cmd {
 	u32 val;
 };
 
-static long do_drv_read(void *_cmd)
+static void do_drv_read(struct drv_cmd *cmd)
 {
-	struct drv_cmd *cmd = _cmd;
 	u32 h;
 
 	switch (cmd->type) {
@@ -167,12 +166,10 @@ static long do_drv_read(void *_cmd)
 	default:
 		break;
 	}
-	return 0;
 }
 
-static long do_drv_write(void *_cmd)
+static void do_drv_write(struct drv_cmd *cmd)
 {
-	struct drv_cmd *cmd = _cmd;
 	u32 lo, hi;
 
 	switch (cmd->type) {
@@ -189,23 +186,30 @@ static long do_drv_write(void *_cmd)
 	default:
 		break;
 	}
-	return 0;
 }
 
 static void drv_read(struct drv_cmd *cmd)
 {
+	cpumask_t saved_mask = current->cpus_allowed;
 	cmd->val = 0;
 
-	work_on_cpu(cpumask_any(cmd->mask), do_drv_read, cmd);
+	set_cpus_allowed_ptr(current, cmd->mask);
+	do_drv_read(cmd);
+	set_cpus_allowed_ptr(current, &saved_mask);
 }
 
 static void drv_write(struct drv_cmd *cmd)
 {
+	cpumask_t saved_mask = current->cpus_allowed;
 	unsigned int i;
 
 	for_each_cpu(i, cmd->mask) {
-		work_on_cpu(i, do_drv_write, cmd);
+		set_cpus_allowed_ptr(current, cpumask_of(i));
+		do_drv_write(cmd);
 	}
+
+	set_cpus_allowed_ptr(current, &saved_mask);
+	return;
 }
 
 static u32 get_cur_val(const struct cpumask *mask)
@@ -231,15 +235,10 @@ static u32 get_cur_val(const struct cpumask *mask)
 		return 0;
 	}
 
-	if (unlikely(!alloc_cpumask_var(&cmd.mask, GFP_KERNEL)))
-		return 0;
-
 	cpumask_copy(cmd.mask, mask);
 
 	drv_read(&cmd);
 
-	free_cpumask_var(cmd.mask);
-
 	dprintk("get_cur_val = %u\n", cmd.val);
 
 	return cmd.val;
