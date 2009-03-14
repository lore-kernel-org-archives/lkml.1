Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbZCNBYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbZCNBYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZCNBT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:19:56 -0400
Received: from kroah.org ([198.145.64.141]:34843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752770AbZCNBTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:19:54 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:33 2009
Message-Id: <20090314011033.285021056@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:09:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Nick Piggin <npiggin@suse.de>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [patch 013/114] mm: fix lazy vmap purging (use-after-free error)
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=mm-fix-lazy-vmap-purging.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vegard Nossum <vegard.nossum@gmail.com>

commit cbb766766f3f2f6d9326c561b1020590642c6e39 upstream.

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
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -476,6 +476,7 @@ static void __purge_vmap_area_lazy(unsig
 	static DEFINE_SPINLOCK(purge_lock);
 	LIST_HEAD(valist);
 	struct vmap_area *va;
+	struct vmap_area *n_va;
 	int nr = 0;
 
 	/*
@@ -515,7 +516,7 @@ static void __purge_vmap_area_lazy(unsig
 
 	if (nr) {
 		spin_lock(&vmap_area_lock);
-		list_for_each_entry(va, &valist, purge_list)
+		list_for_each_entry_safe(va, n_va, &valist, purge_list)
 			__free_vmap_area(va);
 		spin_unlock(&vmap_area_lock);
 	}


