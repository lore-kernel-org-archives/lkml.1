Return-Path: <linux-kernel-owner+w=401wt.eu-S1751606AbZIRFRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbZIRFRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 01:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbZIRFRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 01:17:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36335
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927AbZIRFRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 01:17:49 -0400
Date: Thu, 17 Sep 2009 22:18:07 -0700 (PDT)
Message-Id: <20090917.221807.208354411.davem@davemloft.net>
To: tj@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: sparc64 pcpu failures...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tejun, I just started seeing the following on sparc64:

[   56.422005] WARNING: at mm/vmalloc.c:1991 pcpu_get_vm_areas+0x1b4/0x5fc()
[   56.430881] Modules linked in: ipv6(+) snd_ali5451(+) snd_ac97_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc ac97_bus tg3 libphy
[   56.450490] Call Trace:
[   56.460021]  [00000000004d769c] pcpu_get_vm_areas+0x1b4/0x5fc
[   56.469645]  [00000000004ea5d8] pcpu_alloc+0x204/0x878
[   56.479212]  [00000000006d6a10] snmp_mib_init+0x3c/0x68
[   56.488813]  [0000000010184324] ipv6_add_dev+0x174/0x390 [ipv6]
[   56.498383]  [00000000101c44e0] addrconf_init+0x4c/0x16c [ipv6]
[   56.507913]  [00000000101c42fc] inet6_init+0x1cc/0x34c [ipv6]
[   56.517450]  [0000000000426acc] do_one_initcall+0x44/0x154
[   56.526975]  [0000000000490f7c] SyS_init_module+0xbc/0x1f4
[   56.536466]  [0000000000406214] linux_sparc_syscall32+0x34/0x40
[   56.545943] ---[ end trace 557118e4f3ad7a51 ]---
[   56.609093] NET: Unregistered protocol family 10
[   56.872235] NET: Registered protocol family 10

Might this be a result of:

commit bcb2107fdbecef3de55d597d23453747af81ba88
Author: Tejun Heo <tj@kernel.org>
Date:   Fri Aug 14 15:00:53 2009 +0900

    sparc64: use embedding percpu first chunk allocator
    
    sparc64 currently allocates a large page for each cpu and partially
    remap them into vmalloc area much like what lpage first chunk
    allocator did.  As a 4M page is used for each cpu, this results in
    very large unit size and also adds TLB pressure due to the double
    mapping of pages in the first chunk.
    
    This patch converts sparc64 to use the embedding percpu first chunk
    allocator which now knows how to handle NUMA configurations.  This
    simplifies the code a lot, doesn't incur any extra TLB pressure and
    results in better utilization of address space.
    
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Acked-by: David S. Miller <davem@davemloft.net>

Do you think?
