Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994Ab0AWAVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab0AWAVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849Ab0AWAUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:20:41 -0500
Received: from kroah.org ([198.145.64.141]:35107 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494Ab0AWATD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:19:03 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:13 2010
Message-Id: <20100123001113.527587963@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:10:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Yongseok Koh <yongseok.koh@samsung.com>, Nick Piggin <npiggin@suse.de>
Subject: [26/29] vmalloc: remove BUG_ON due to racy counting of VM_LAZY_FREE
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yongseok Koh <yongseok.koh@samsung.com>

commit 88f5004430babb836cfce886d5d54c82166f8ba4 upstream.

In free_unmap_area_noflush(), va->flags is marked as VM_LAZY_FREE first, and
then vmap_lazy_nr is increased atomically.

But, in __purge_vmap_area_lazy(), while traversing of vmap_are_list, nr
is counted by checking VM_LAZY_FREE is set to va->flags.  After counting
the variable nr, kernel reads vmap_lazy_nr atomically and checks a
BUG_ON condition whether nr is greater than vmap_lazy_nr to prevent
vmap_lazy_nr from being negative.

The problem is that, if interrupted right after marking VM_LAZY_FREE,
increment of vmap_lazy_nr can be delayed.  Consequently, BUG_ON
condition can be met because nr is counted more than vmap_lazy_nr.

It is highly probable when vmalloc/vfree are called frequently.  This
scenario have been verified by adding delay between marking VM_LAZY_FREE
and increasing vmap_lazy_nr in free_unmap_area_noflush().

Even the vmap_lazy_nr is for checking high watermark, it never be the
strict watermark.  Although the BUG_ON condition is to prevent
vmap_lazy_nr from being negative, vmap_lazy_nr is signed variable.  So,
it could go down to negative value temporarily.

Consequently, removing the BUG_ON condition is proper.

A possible BUG_ON message is like the below.

   kernel BUG at mm/vmalloc.c:517!
   invalid opcode: 0000 [#1] SMP
   EIP: 0060:[<c04824a4>] EFLAGS: 00010297 CPU: 3
   EIP is at __purge_vmap_area_lazy+0x144/0x150
   EAX: ee8a8818 EBX: c08e77d4 ECX: e7c7ae40 EDX: c08e77ec
   ESI: 000081fe EDI: e7c7ae60 EBP: e7c7ae64 ESP: e7c7ae3c
   DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
   Call Trace:
   [<c0482ad9>] free_unmap_vmap_area_noflush+0x69/0x70
   [<c0482b02>] remove_vm_area+0x22/0x70
   [<c0482c15>] __vunmap+0x45/0xe0
   [<c04831ec>] vmalloc+0x2c/0x30
   Code: 8d 59 e0 eb 04 66 90 89 cb 89 d0 e8 87 fe ff ff 8b 43 20 89 da 8d 48 e0 8d 43 20 3b 04 24 75 e7 fe 05 a8 a5 a3 c0 e9 78 ff ff ff <0f> 0b eb fe 90 8d b4 26 00 00 00 00 56 89 c6 b8 ac a5 a3 c0 31
   EIP: [<c04824a4>] __purge_vmap_area_lazy+0x144/0x150 SS:ESP 0068:e7c7ae3c

[ See also http://marc.info/?l=linux-kernel&m=126335856228090&w=2 ]

Signed-off-by: Yongseok Koh <yongseok.koh@samsung.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/vmalloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -555,10 +555,8 @@ static void __purge_vmap_area_lazy(unsig
 	}
 	rcu_read_unlock();
 
-	if (nr) {
-		BUG_ON(nr > atomic_read(&vmap_lazy_nr));
+	if (nr)
 		atomic_sub(nr, &vmap_lazy_nr);
-	}
 
 	if (nr || force_flush)
 		flush_tlb_kernel_range(*start, *end);


