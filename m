Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbYGDU24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbYGDU24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 16:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYGDU2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 16:28:48 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:60882 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbYGDU2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 16:28:47 -0400
Date: Fri, 4 Jul 2008 21:29:13 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Zan Lynx <zlynx@acm.org>
cc: Ryan Hope <rmh3093@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
In-Reply-To: <486E4FD8.4010102@acm.org>
Message-ID: <Pine.LNX.4.64.0807042112130.16912@blonde.site>
References: <48f7fe350807032326l1d68c94l531e44c09693b989@mail.gmail.com>
 <486E4FD8.4010102@acm.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2008, Zan Lynx wrote:
> Ryan Hope wrote:
> > I have tested this with 2.6.26-rc5-mm3 and with 2.6.26-rc8 w/ the
> > get_user_pages_fast patches from -rc5-mm3... Xorg 1.4.99.* will start
> > to load but hangs at a black screen. At this point, I can not switch
> > to another tty. When I try pressing ctrl+alt+del the kernel ooopses
> > and the caps lock led starts to blink. This happens using the nv,
> > radeon and radeonhd drivers (the nv was tested on another box
> > obviously). I have also tried to unselect HAVE_GET_USER_PAGES_FAST in
> > my kernel config but this does not help. I can not figure out where or
> > what the bug is. I can provide any other info you guys need to figure
> > this out. Let me know what I can do.
> 
> I think that I've seen this too on 2.6.26-rc8 on my laptop.  It's 64-bit

Your attachment tells us it's actually 2.6.26-rc8-mm1, less of a worry.

> AMD-64 single core (although I run a SMP-alternatives kernel on it) and I was
> using the nv driver.
> 
> The symptoms are the same.  Everything was working great until I started X.  I
> SSH'd in and got the dmesg after X locked up.  The full dmesg and config are
> attached because Thunderbird is a very stupid program and won't let me paste
> without wrapping.
> 
> Here is a bit of what I got though.
> 
> [  269.224276] BUG: unable to handle kernel paging request at ffffe20003480000
> [  269.224291] IP: [<ffffffff80297e30>] copy_page_range+0x520/0x760
> [  269.224306] PGD 1102067 PUD 1103067 PMD 0
> [  269.224315] Oops: 0000 [1] SMP
> 
> [  269.224473] Call Trace:
> [  269.224495]  [<ffffffff80239a9b>] dup_mm+0x26b/0x3c0
> [  269.224507]  [<ffffffff8023a84c>] copy_process+0xc2c/0x1210
> [  269.224518]  [<ffffffff8023aea3>] do_fork+0x73/0x310
> [  269.224526]  [<ffffffff8024719e>] sys_rt_sigaction+0x8e/0xd0
> [  269.224536]  [<ffffffff8020c2db>] system_call_after_swapgs+0x7b/0x80
> [  269.224542]  [<ffffffff8020c5d7>] ptregscall_common+0x67/0xb0

Useful info, thank you; even more useful was the Code line in your attachment

> [  269.224557] Code: 00 00 48 b9 00 00 00 00 00 e2 ff ff 48 21 d8 48 c1 e8 0c 48 8d 14 c5 00 00 00 00 48 c1 e0 06 48 29 d0 48 01 c1 0f 84 10 ff ff ff <48> 8b 01 48 89 ca f6 c4 40 74 04 48 8b 51 10 90 ff 42 08 90 ff 

which is enough to identify the oops as in copy_one_pte's get_page(page).
Here's a patch I think we need, which I'm hoping will fix both your
crashes - please let us know - thanks a lot.

Stop mprotect's pte_modify from wiping out the x86 pte_special bit, which
caused oops thereafter when vm_normal_page thought X's abnormal was normal.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Fix to 2.6.26-rc8-mm1 x86-implement-pte_special.patch
Perhaps something similar needed for powerpc?  Nick will know.

 include/asm-x86/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.26-rc8-mm1/include/asm-x86/pgtable.h	2008-07-03 11:34:55.000000000 +0100
+++ linux/include/asm-x86/pgtable.h	2008-07-04 20:58:36.000000000 +0100
@@ -57,7 +57,7 @@
 
 /* Set of bits not changed in pte_modify */
 #define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_PCD | _PAGE_PWT |		\
-			 _PAGE_ACCESSED | _PAGE_DIRTY)
+			 _PAGE_SPECIAL | _PAGE_ACCESSED | _PAGE_DIRTY)
 
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
 #define _PAGE_CACHE_WB		(0)
