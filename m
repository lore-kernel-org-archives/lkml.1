Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbXHVPud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbXHVPud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbXHVPuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:50:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38216 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbXHVPuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:50:22 -0400
Date: Wed, 22 Aug 2007 08:50:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [BUG] 2.6.23-rc3-mm1 - kernel BUG at net/core/skbuff.c:95!
Message-Id: <20070822085002.8a116f72.akpm@linux-foundation.org>
In-Reply-To: <46CC33EC.1040803@linux.vnet.ibm.com>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<46CC33EC.1040803@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 18:32:36 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> Following Kernel Bug was raised when i tried compiling and booting ppc64 
> machine
> with 2.6.23-rc3-mm1 kernel.
> 
> =================================================================
> 
> Freeing initrd memory: 908k freed
> 
> sysctl table check failed: /kernel .1 Writable sysctl directory
> 
> skb_over_panic: text:c0000000002bf840 len:139 put:29 head:c00000000ffe7400 data:c00000000ffe7400 tail:0x8b end:0x80 dev:<NULL>
> 
> ------------[ cut here ]------------
> 
> kernel BUG at net/core/skbuff.c:95!
> 
> Oops: Exception in kernel mode, sig: 5 [#1]
> 
> SMP NR_CPUS=128 NUMA pSeries
> 
> Modules linked in:
> 
> NIP: c0000000003fd7c4 LR: c0000000003fd7c0 CTR: 80000000000f97dc
> 
> REGS: c0000000027f3850 TRAP: 0700   Not tainted  (2.6.23-rc3-mm1-autokern1)
> 
> MSR: 8000000000029032 <EE,ME,IR,DR>  CR: 24288024  XER: 00000010
> 
> TASK = c000000009fc0000[1] 'swapper' THREAD: c0000000027f0000 CPU: 0
> 
> GPR00: c0000000003fd7c0 c0000000027f3ad0 c000000000737710 0000000000000082 
> 
> GPR04: 0000000000000001 0000000000000001 0000000000000000 c00000000062bb3c 
> 
> GPR08: 0000000000000000 c00000000067b2e0 0000000000002100 c00000000077b110 
> 
> GPR12: 0000000000004000 c000000000649f00 0000000000000000 0000000000000000 
> 
> GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
> 
> GPR20: 0000000000000000 c00000000802a0c0 c00000000052ea30 c0000000005392a8 
> 
> GPR24: c000000009f6b908 c0000000006a4000 c0000000026e2000 0000000000000020 
> 
> GPR28: c00000000ffe746e 0000000000000004 c0000000006f5340 c000000009f6a900 
> 
> NIP [c0000000003fd7c4] .skb_over_panic+0x50/0x58
> 
> LR [c0000000003fd7c0] .skb_over_panic+0x4c/0x58
> 
> Call Trace:
> 
> [c0000000027f3ad0] [c0000000003fd7c0] .skb_over_panic+0x4c/0x58 (unreliable)
> 
> [c0000000027f3b60] [c0000000002bf848] .kobject_uevent_env+0x4f8/0x528
> 
> [c0000000027f3c80] [c00000000032512c] .device_add+0x2bc/0x730
> 
> [c0000000027f3d50] [c000000000022330] .vio_register_device_node+0x1a4/0x274
> 
> [c0000000027f3e00] [c0000000005d34a8] .vio_bus_init+0xa0/0xec
> 
> [c0000000027f3e80] [c0000000005c8c6c] .kernel_init+0x20c/0x4b8
> 
> [c0000000027f3f90] [c0000000000267b0] .kernel_thread+0x4c/0x68
> 

gargh, sorry, that's probably due to my screwed up attempt to fix Kay's
screwed up
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch.

Kay sent an update patch but it didn't arrive in time.

Greg, if you haven't yet merged that, please do so asap?

So what _should_ this:

--- a/arch/powerpc/kernel/vio.c~fix-4-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct
+++ a/arch/powerpc/kernel/vio.c
@@ -373,7 +373,7 @@ static int vio_hotplug(struct device *de
 	dn = dev->archdata.of_node;
 	if (!dn)
 		return -ENODEV;
-	cp = of_get_property(dn, "compatible", &length);
+	cp = of_get_property(dn, "compatible", &env->buflen);
 	if (!cp)
 		return -ENODEV;
 
_

have done?
