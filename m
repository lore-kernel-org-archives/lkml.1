Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbZALRxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbZALRxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZALRxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:53:10 -0500
Received: from relay1.sgi.com ([192.48.179.29]:59110 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752356AbZALRxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:53:09 -0500
Message-ID: <496B8382.9080808@sgi.com>
Date: Mon, 12 Jan 2009 09:53:06 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dieter Ries <clip2@gmx.de>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu> <496A3F62.8090902@gmx.de> <496A4228.5090807@sgi.com> <20090112100053.GA7905@elte.hu>
In-Reply-To: <20090112100053.GA7905@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
...
>> Rusty - any ideas on how to avoid these clashes with the 
>> get_online_cpus() call in work_on_cpu()?  Or something else to indicate 
>> to lockdep that the circular lock dependency is ok (as you mentioned 
>> before)?
> 
> I've queued up the revert below, please check the commit message whether 
> you agree with the analysis.
> 
> Mike, could you also check any other patches where you add work_on_cpu() 
> usage to make sure we dont have similar mishaps? work_on_cpu() seems 
> completely unsuited for any sort of set_cpus_allowed() replacement ...
> 
> 	Ingo

Yes, I'll do that now.  With the resume feature also calling these functions,
I'm even less comfortable with it.

Shall I resurrect the 2nd cpumask in the task struct from my original patches,
(and one that akpm also suggested more than a year ago)?

Basically, it looks like this:

--- linux-2.6-for-ingo.orig/include/linux/sched.h       2009-01-11 10:43:19.000000000 -0800
+++ linux-2.6-for-ingo/include/linux/sched.h    2009-01-12 09:45:02.871247038 -0800
@@ -1132,6 +1132,7 @@ struct task_struct {

        unsigned int policy;
        cpumask_t cpus_allowed;
+       cpumask_t save_cpus_allowed;

--- linux-2.6-for-ingo.orig/arch/x86/kernel/microcode_core.c    2009-01-12 09:05:36.000000000 -0800
+++ linux-2.6-for-ingo/arch/x86/kernel/microcode_core.c 2009-01-12 09:49:19.315276144 -0800
@@ -110,11 +110,10 @@ EXPORT_SYMBOL_GPL(ucode_cpu_info);
 #ifdef CONFIG_MICROCODE_OLD_INTERFACE
 static int do_microcode_update(const void __user *buf, size_t size)
 {
-       cpumask_t old;
        int error = 0;
        int cpu;

-       old = current->cpus_allowed;
+       cpumask_copy(&current->save_cpus_allowed, &current->cpus_allowed);

        for_each_online_cpu(cpu) {
                struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
@@ -122,7 +121,7 @@ static int do_microcode_update(const voi
                if (!uci->valid)
                        continue;

-               set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+               set_cpus_allowed_ptr(current, cpumask_of(cpu));
                error = microcode_ops->request_microcode_user(cpu, buf, size);
                if (error < 0)
                        goto out;
@@ -130,7 +129,7 @@ static int do_microcode_update(const voi
                        microcode_ops->apply_microcode(cpu);
        }
 out:
-       set_cpus_allowed_ptr(current, &old);
+       set_cpus_allowed_ptr(current, &current->save_cpus_allowed);
        return error;
 }

The primary concern is that there is only one temp, so I had also put in a warning
if it was already in use.  But the scope of where it's used is very short-lived,
so I don't know if a preempt_disable() is required, but it seems the safe thing
to do.

THanks,
MIke

