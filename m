Return-Path: <linux-kernel-owner+w=401wt.eu-S1762957AbZBYQBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762957AbZBYQBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762717AbZBYQBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:01:38 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:54857 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762683AbZBYQBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:01:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=O98OwkeP9j6D4lc99sFvfJ1MkI3FHuXCSDjiPCR/ORLP8PBthxhduOVe1Q2nDWV4ar
         V1z9TY/fGyjviOGaWwSH7WyKNN8CISCcdm/fhEjqyBLencnG1IY7d4khhWNxFehf5yOI
         6ly4TuSgPuGEe/V8mk4Dm7RuSDOjBoY4kwGYQ=
Date: Wed, 25 Feb 2009 17:01:30 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, stable@kernel.org,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: [PATCH][RESEND] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090225160130.GA10248@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This is similar to mm-fix-lazy-vmap-purging-use-after-free-error.patch in -mm,
but Nick Piggin wanted me to resend with his Acked-by.

Thanks,


Vegard


>From f90fae887ed82bc9369e9f95960e175fef3e5d97 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 20 Feb 2009 14:35:09 +0100
Subject: [PATCH] mm: fix lazy vmap purging (use-after-free error)

I just got this new warning from kmemcheck:

    WARNING: kmemcheck: Caught 32-bit read from freed memory (c7806a60)
    a06a80c7ecde70c1a04080c700000000a06709c1000000000000000000000000
     f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f
     ^

    Pid: 0, comm: swapper Not tainted (2.6.29-rc4 #230)
    EIP: 0060:[<c1096df7>] EFLAGS: 00000286 CPU: 0
    EIP is at __purge_vmap_area_lazy+0x117/0x140
    EAX: 00070f43 EBX: c7806a40 ECX: c1677080 EDX: 00027b66
    ESI: 00002001 EDI: c170df0c EBP: c170df00 ESP: c178830c
     DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
    CR0: 80050033 CR2: c7806b14 CR3: 01775000 CR4: 00000690
    DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
    DR6: 00004000 DR7: 00000000
     [<c1096f3e>] free_unmap_vmap_area_noflush+0x6e/0x70
     [<c1096f6a>] remove_vm_area+0x2a/0x70
     [<c1097025>] __vunmap+0x45/0xe0
     [<c10970de>] vunmap+0x1e/0x30
     [<c1008ba5>] text_poke+0x95/0x150
     [<c1008ca9>] alternatives_smp_unlock+0x49/0x60
     [<c171ef47>] alternative_instructions+0x11b/0x124
     [<c171f991>] check_bugs+0xbd/0xdc
     [<c17148c5>] start_kernel+0x2ed/0x360
     [<c171409e>] __init_begin+0x9e/0xa9
     [<ffffffff>] 0xffffffff

It happened here:

    $ addr2line -e vmlinux -i c1096df7
    mm/vmalloc.c:540

Code:

	list_for_each_entry(va, &valist, purge_list)
		__free_vmap_area(va);

It's this instruction:

    mov    0x20(%ebx),%edx

Which corresponds to a dereference of va->purge_list.next:

    (gdb) p ((struct vmap_area *) 0)->purge_list.next
    Cannot access memory at address 0x20

It seems that we should use "safe" list traversal here, as the element
is freed inside the loop. Please verify that this is the right fix.

Acked-by: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: <stable@kernel.org>         [2.6.28.x]
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 mm/vmalloc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 75f49d3..cda20b2 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -498,6 +498,7 @@ static void __purge_vmap_area_lazy(unsigned long *start, unsigned long *end,
 	static DEFINE_SPINLOCK(purge_lock);
 	LIST_HEAD(valist);
 	struct vmap_area *va;
+	struct vmap_area *n_va;
 	int nr = 0;
 
 	/*
@@ -537,7 +538,7 @@ static void __purge_vmap_area_lazy(unsigned long *start, unsigned long *end,
 
 	if (nr) {
 		spin_lock(&vmap_area_lock);
-		list_for_each_entry(va, &valist, purge_list)
+		list_for_each_entry_safe(va, n_va, &valist, purge_list)
 			__free_vmap_area(va);
 		spin_unlock(&vmap_area_lock);
 	}
-- 
1.6.0.6

