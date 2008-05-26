Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYEZUiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYEZUiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 16:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYEZUiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 16:38:13 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:59370 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbYEZUiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 16:38:13 -0400
Date: Mon, 26 May 2008 22:38:10 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: m68k libc5 regression
Message-ID: <Pine.LNX.4.64.0805262226280.11902@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently I noticed a regression when running an old libc5 binary
(amiga-lilo) on m68k. It fails with the error message:

    Can't allocate memory

Strace shows that the offending part is:

    brk(0x80008e40)                         = 0x80009000

For older kernels, brk() behaved like:

    brk(0x80008e40)                         = 0x80008e40
    brk(0x80009000)                         = 0x80009000

Also our good old libc5 emergency ramdisk no longer works (init cannot
open /inittab).

At first I suspected CONFIG_COMPAT_BRK, but different values (0, 1, 2) of
/proc/sys/kernel/randomize_va_space don't seem to make any difference.

So I bisected it to:

commit 4cc6028d4040f95cdb590a87db478b42b8be0508
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Wed Feb 6 22:39:44 2008 +0100

    brk: check the lower bound properly
    
    There is a check in sys_brk(), that tries to make sure that we do not
    underflow the area that is dedicated to brk heap.
    
    The check is however wrong, as it assumes that brk area starts immediately
    after the end of the code (+bss), which is wrong for example in
    environments with randomized brk start. The proper way is to check whether
    the address is not below the start_brk address.
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/mm/mmap.c b/mm/mmap.c
index bb4c963..ad6e4ea 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -245,7 +245,7 @@ asmlinkage unsigned long sys_brk(unsigned long brk)
 
 	down_write(&mm->mmap_sem);
 
-	if (brk < mm->end_code)
+	if (brk < mm->start_brk)
 		goto out;
 
 	/*

Reverting this change on current mainline fixes both libc5 amiga-lilo and the
libc5 emergency ramdisk. The value of /proc/sys/kernel/randomize_va_space still
doesn't matter.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
