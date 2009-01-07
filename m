Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbZAGJP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbZAGJP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 04:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZAGJPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 04:15:39 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:63986 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbZAGJPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 04:15:37 -0500
Date: Wed, 7 Jan 2009 10:15:34 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [ 286.547348] BUG: unable to handle kernel paging request at
	6b6b6b6b
Message-ID: <20090107091534.GA4633@osiris.boeblingen.de.ibm.com>
References: <4963F368.7080909@gmail.com> <84144f020901062248j5d406656wb21130d914c7749d@mail.gmail.com> <84144f020901070030k6fb888f6n84255078e4885d28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020901070030k6fb888f6n84255078e4885d28@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 10:30:56AM +0200, Pekka Enberg wrote:
> On Wed, Jan 7, 2009 at 8:48 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > On Wed, Jan 7, 2009 at 2:12 AM, Justin P. Mattock
> > <justinmattock@gmail.com> wrote:
> >> With pulling git today I'm unable to shut the machine down completely.
> >> (the system just sits there with the message on the screen);
[...]
> >> [  286.547348] BUG: unable to handle kernel paging request at 6b6b6b6b
> >
> > That looks like use-after-free in __stop_machine() so lets cc Rusty.
> > If you want, you can convert the oops location into human-readable
> > form. Just search for "GDB" in Documentation/BUG-HUNTING for
> > instructions how to do that. And don't forget to send your .config.
[...]
> >> [  286.560580] EIP: is at __stop_machine+0x88/0xe3
> >> [  286.560580]  [<c03d04e4>] ? _cpu_down+0x10f/0x234
> >> [  286.560580]  [<c012a57e>] ? disable_nonboot_cpus+0x58/0xdc
> >> [  286.560580]  [<c01360c0>] ? kernel_poweroff+0x22/0x39
> >> [  286.560580]  [<c0136301>] ? sys_reboot+0xde/0x14c
> >> [  286.560580]  [<c01331b2>] ? complete_signal+0x179/0x191
> >> [  286.560580]  [<c0133396>] ? send_signal+0x1cc/0x1e1
> >> [  286.560580]  [<c03de418>] ? _spin_unlock_irqrestore+0x2d/0x3c
> >> [  286.560580]  [<c0133b65>] ? group_send_signal_info+0x58/0x61
> >> [  286.560580]  [<c0133b9e>] ? kill_pid_info+0x30/0x3a
> >> [  286.560580]  [<c0133d49>] ? sys_kill+0x75/0x13a
> >> [  286.560580]  [<c01a06cb>] ? mntput_no_expire+ox1f/0x101
> >> [  286.560580]  [<c019b3b3>] ? dput+0x1e/0x105
> >> [  286.560580]  [<c018ef87>] ?  __fput+0x150/0x158
> >> [  286.560580]  [<c0157abf>] ? audit_syscall_entry+0x137/0x159
> >> [  286.560580]  [<c010329f>] ? sysenter_do_call+0x12/0x34
[...]
> and offset of ->data is zero and WORK_DATA_INIT() expands to
> ATOMIC_LONG_INIT(0) so looks to me like 'sm_work' is used after it has
> been free'd. Perhaps stop_machine_destroy() was called before or in
> parallel to __stop_machine()? So lets cc Heiko as well.

I missed to convert disable_nonboot_cpus to stop_machine_create/destroy.
So it's a use before-even-allocated bug.

The patch below should hopefully fix it:

Subject: [PATCH] cpu hotplug: add stop_machine_create/destroy to disable_nonboot_cpus

From: Heiko Carstens <heiko.carstens@de.ibm.com>

disable_nonboot_cpus calls directly _cpu_down. _cpu_down however relies on
the in advanced created stop_machine kernel threads which should be created
by the caller (like cpu_down does).

So add the missing stop_machine_create/destroy calls to disable_nonboot_cpus
as well.

Fixes this bug:

[  286.547348] BUG: unable to handle kernel paging request at 6b6b6b6b
[  286.548940] IP: [<c0150ca4>] __stop_machine+0x88/0xe3
[  286.550598] Oops: 0002 [#1] SMP
[  286.560580] Pid: 3273, comm: halt Not tainted (2.6.28-06127-g238c6d5
[  286.560580] EIP: is at __stop_machine+0x88/0xe3
[  286.560580] Process halt (pid: 3273, ti=f1a28000 task=f4530f30
[  286.560580] Call Trace:
[  286.560580]  [<c03d04e4>] ? _cpu_down+0x10f/0x234
[  286.560580]  [<c012a57e>] ? disable_nonboot_cpus+0x58/0xdc
[  286.560580]  [<c01360c0>] ? kernel_poweroff+0x22/0x39
[  286.560580]  [<c0136301>] ? sys_reboot+0xde/0x14c
[  286.560580]  [<c01331b2>] ? complete_signal+0x179/0x191
[  286.560580]  [<c0133396>] ? send_signal+0x1cc/0x1e1
[  286.560580]  [<c03de418>] ? _spin_unlock_irqrestore+0x2d/0x3c
[  286.560580]  [<c0133b65>] ? group_send_signal_info+0x58/0x61
[  286.560580]  [<c0133b9e>] ? kill_pid_info+0x30/0x3a
[  286.560580]  [<c0133d49>] ? sys_kill+0x75/0x13a
[  286.560580]  [<c01a06cb>] ? mntput_no_expire+ox1f/0x101
[  286.560580]  [<c019b3b3>] ? dput+0x1e/0x105
[  286.560580]  [<c018ef87>] ?  __fput+0x150/0x158
[  286.560580]  [<c0157abf>] ? audit_syscall_entry+0x137/0x159
[  286.560580]  [<c010329f>] ? sysenter_do_call+0x12/0x34

Reported-by: "Justin P. Mattock" <justinmattock@gmail.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/cpu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -379,8 +379,11 @@ static cpumask_var_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
 {
-	int cpu, first_cpu, error = 0;
+	int cpu, first_cpu, error;
 
+	error = stop_machine_create();
+	if (error)
+		return error;
 	cpu_maps_update_begin();
 	first_cpu = cpumask_first(cpu_online_mask);
 	/* We take down all of the non-boot CPUs in one shot to avoid races
@@ -409,6 +412,7 @@ int disable_nonboot_cpus(void)
 		printk(KERN_ERR "Non-boot CPUs are not disabled\n");
 	}
 	cpu_maps_update_done();
+	stop_machine_destroy();
 	return error;
 }
 
