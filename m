Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbZAGPbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbZAGPbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZAGPa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:30:56 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:39045 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZAGPaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:30:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YCBObb6LS9jERaSaTx28LIwgaajbcNAENXoC+eUOae4HbRp7mrZR+pdzdBWwvefmIw
         NAzNPtJuME6d7f3XETJ6cWu0ncLD/QKyvYAKMO8Nv5L9kTAVHXPELgmKEoWJ3MwZ/3XZ
         ryMjTu/a0o+/zbugoh3YbAMKs3bB6aUqV08Ls=
Message-ID: <c62985530901070730j7515a106x2a56a6d8a14fbbc5@mail.gmail.com>
Date: Wed, 7 Jan 2009 16:30:52 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] stop_machine/cpu hotplug: fix disable_nonboot_cpus
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org, "Jeff Chua" <jeff.chua.linux@gmail.com>
In-Reply-To: <20090107151946.GA25560@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4963F368.7080909@gmail.com>
	 <84144f020901062248j5d406656wb21130d914c7749d@mail.gmail.com>
	 <84144f020901070030k6fb888f6n84255078e4885d28@mail.gmail.com>
	 <20090107091534.GA4633@osiris.boeblingen.de.ibm.com>
	 <1231319946.14720.7.camel@penberg-laptop>
	 <b6a2187b0901070336u1cb0bc94i1e47a68d8ea671c@mail.gmail.com>
	 <20090107122728.GB4633@osiris.boeblingen.de.ibm.com>
	 <b6a2187b0901070551r5bb86dbfye96c2c92e7b78087@mail.gmail.com>
	 <20090107151946.GA25560@osiris.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/7 Heiko Carstens <heiko.carstens@de.ibm.com>:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>
> disable_nonboot_cpus calls _cpu_down. But _cpu_down requires that the
> caller already created the stop_machine workqueue (like cpu_down does).
> Otherwise a call to stop_machine will lead to accesses to random memory
> regions.
>
> When introducing this new interface (9ea09af3bd3090e8349ca2899ca2011bd94cda85
> "stop_machine: introduce stop_machine_create/destroy") I missed the second
> call site of _cpu_down.
> So add the missing stop_machine_create/destroy calls to disable_nonboot_cpus
> as well.
>
> Fixes suspend-to-ram/disk and also this bug:
>
> [  286.547348] BUG: unable to handle kernel paging request at 6b6b6b6b
> [  286.548940] IP: [<c0150ca4>] __stop_machine+0x88/0xe3
> [  286.550598] Oops: 0002 [#1] SMP
> [  286.560580] Pid: 3273, comm: halt Not tainted (2.6.28-06127-g238c6d5
> [  286.560580] EIP: is at __stop_machine+0x88/0xe3
> [  286.560580] Process halt (pid: 3273, ti=f1a28000 task=f4530f30
> [  286.560580] Call Trace:
> [  286.560580]  [<c03d04e4>] ? _cpu_down+0x10f/0x234
> [  286.560580]  [<c012a57e>] ? disable_nonboot_cpus+0x58/0xdc
> [  286.560580]  [<c01360c0>] ? kernel_poweroff+0x22/0x39
> [  286.560580]  [<c0136301>] ? sys_reboot+0xde/0x14c
> [  286.560580]  [<c01331b2>] ? complete_signal+0x179/0x191
> [  286.560580]  [<c0133396>] ? send_signal+0x1cc/0x1e1
> [  286.560580]  [<c03de418>] ? _spin_unlock_irqrestore+0x2d/0x3c
> [  286.560580]  [<c0133b65>] ? group_send_signal_info+0x58/0x61
> [  286.560580]  [<c0133b9e>] ? kill_pid_info+0x30/0x3a
> [  286.560580]  [<c0133d49>] ? sys_kill+0x75/0x13a
> [  286.560580]  [<c01a06cb>] ? mntput_no_expire+ox1f/0x101
> [  286.560580]  [<c019b3b3>] ? dput+0x1e/0x105
> [  286.560580]  [<c018ef87>] ?  __fput+0x150/0x158
> [  286.560580]  [<c0157abf>] ? audit_syscall_entry+0x137/0x159
> [  286.560580]  [<c010329f>] ? sysenter_do_call+0x12/0x34
>
> Reported-by: "Justin P. Mattock" <justinmattock@gmail.com>
> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  kernel/cpu.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/kernel/cpu.c
> ===================================================================
> --- linux-2.6.orig/kernel/cpu.c
> +++ linux-2.6/kernel/cpu.c
> @@ -379,8 +379,11 @@ static cpumask_var_t frozen_cpus;
>
>  int disable_nonboot_cpus(void)
>  {
> -       int cpu, first_cpu, error = 0;
> +       int cpu, first_cpu, error;
>
> +       error = stop_machine_create();
> +       if (error)
> +               return error;
>        cpu_maps_update_begin();
>        first_cpu = cpumask_first(cpu_online_mask);
>        /* We take down all of the non-boot CPUs in one shot to avoid races
> @@ -409,6 +412,7 @@ int disable_nonboot_cpus(void)
>                printk(KERN_ERR "Non-boot CPUs are not disabled\n");
>        }
>        cpu_maps_update_done();
> +       stop_machine_destroy();
>        return error;
>  }
>


That should explain why suspend to disk failed on my box yesterday on
the processors stage...
Thanks!
