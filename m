Return-Path: <linux-kernel-owner+w=401wt.eu-S1759467AbZE0KID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbZE0KID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 06:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbZE0KHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 06:07:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46014 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844AbZE0KHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 06:07:53 -0400
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86: MCE: Fix for mce_panic_timeout
From: Andi Kleen <andi@firstfloor.org>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
	<23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
	<347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
	<3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>
	<34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com>
	<c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com>
	<37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com>
	<10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com>
	<a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com>
	<abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com>
	<b55d8c3d2842ee10f4b06f17cc2658f81b4f7b
	4e.1243381848.git.ak@linux.intel.com>
	<7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com>
	<0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com
	> <4A1CC21A.10301@jp.fujitsu.com>
Date: Wed, 27 May 2009 12:07:50 +0200
In-Reply-To: <4A1CC21A.10301@jp.fujitsu.com> (Hidetoshi Seto's message of "Wed, 27 May 2009 13:31:22 +0900")
Message-ID: <874ov6oo3t.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:

> This fixes:

Thanks I had already fixed it on my own.

Updated patch appended.
>
>  - In case of panic_timeout > 0 and mce_bootlog == 0.
>    System should reboot after panic, but it doesn't on mce panic because
>    current mce code overwrite panic_timeout to 0.

Nope, with bootlog==0 it should _not_ automatically reboot on panic.
Automatic rebooting makes mainly sense with boot logging, otherwise
you will likely lose the information. Or at least the kernel 
cannot know if you lose information or not so it has to err on 
the safe side.

I changed it now to only override with panic_timeout == 0,
as in the user didn't set anything,
that's probably the most sensible semantics anyways.

-Andi

---

x86: MCE: Default to panic timeout for machine checks v3

Fatal machine checks can be logged to disk after boot, but only if
the system did a warm reboot. That's unfortunately difficult with the
default panic behaviour, which waits forever and the admin has to
press the power button because modern systems usually miss a reset button.
This clears the machine checks in the registers and make
it impossible to log them.

This patch changes the default for machine check panic to always
reboot after 30s. Then the mce can be successfully logged after
reboot.

I believe this will improve machine check experience for any 
system running the X server.

This is dependent on successfull boot logging of MCEs. This currently
only works on Intel systems, on AMD there are quite a lot of systems
around which leave junk in the machine check registers after boot,
so it's disabled here. These systems will continue to default
to endless waiting panic.

v2: Only force panic timeout when it's shorter (H.Seto)
v3: Only panic when there is no earlier timeout or it's not zero
(based on comment H.Seto)

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce.c	2009-05-27 11:59:03.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce.c	2009-05-27 12:01:07.000000000 +0200
@@ -82,6 +82,7 @@
 static int			rip_msr;
 static int			mce_bootlog = -1;
 static int			monarch_timeout = -1;
+static int			mce_panic_timeout;
 
 static char			trigger[128];
 static char			*trigger_argv[2] = { trigger, NULL };
@@ -203,6 +204,8 @@
 	local_irq_enable();
 	while (timeout-- > 0)
 		udelay(1);
+	if (panic_timeout == 0)
+		panic_timeout = mce_panic_timeout;
 	panic("Panicing machine check CPU died");
 }
 
@@ -240,6 +243,8 @@
 		printk(KERN_EMERG "Some CPUs didn't answer in synchronization\n");
 	if (exp)
 		printk(KERN_EMERG "Machine check: %s\n", exp);
+	if (panic_timeout == 0)
+		panic_timeout = mce_panic_timeout;
 	panic(msg);
 }
 
@@ -1100,6 +1105,8 @@
 	}
 	if (monarch_timeout < 0)
 		monarch_timeout = 0;
+	if (mce_bootlog != 0)
+		mce_panic_timeout = 30;
 }
 
 static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)


-- 
ak@linux.intel.com -- Speaking for myself only.
