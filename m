Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbXJKOk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbXJKOk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 10:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbXJKOkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 10:40:18 -0400
Received: from smtp19.orange.fr ([80.12.242.18]:6398 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbXJKOkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 10:40:16 -0400
X-ME-UUID: 20071011144014227.376B11C00090@mwinf1927.orange.fr
Date: Thu, 11 Oct 2007 16:36:10 +0200
From: Philippe Elie <phil.el@wanadoo.fr>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
       oprofile Mailing List <oprofile-list@lists.sourceforge.net>
Cc: Sami Farin <safari-kernel@safari.iki.fi>, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.22.6 + oprofile oops
Message-ID: <20071011143610.GA2881@zaniah>
References: <20070922112335.4wqatiewgeiottty@m.safari.iki.fi> <20070929170523.mepbfbdqwhnyrx3z@m.safari.iki.fi>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20070929170523.mepbfbdqwhnyrx3z@m.safari.iki.fi>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, 29 Sep 2007 at 20:05 +0000, Sami Farin wrote:

> > x86_64 SMP kernel v2.6.22.6 (not using callgraph).
> > sometimes oprofile works for a longer time... but not this time.
> > 
> > 2007-09-22 13:53:32.527237777 <1>[ 3372.390188] Unable to handle kernel NULL pointer dereference at 0000000000000650 RIP: 
> > 2007-09-22 13:53:32.527245948 <1>[ 3372.390195]  [<ffffffff80652f44>] _spin_lock+0x4/0x20
...
> 2007-09-22 13:53:32.527390314 <4>[ 3372.390457]  [<ffffffff80232b88>] get_task_mm+0x18/0x60

On the per cpu buffer writer side oprofile_add_sample() use profile_pc()
to get the eip, profile_pc() can return ~0lu, but an eip == ~0lu is a
magic value = ESCAPE_CODE. The per cpu reader side in buffer_sync.c use
this value to know that the associated data is a task pointer but here
the associated data is a counter number.

This has already been reported two years ago by Jesse Barnes on the same
sort of box, pentium D. This is not reproducible on a duo core nor I was
able to on a P4 box two years ago, I dunno why. Anyway profile_pc() is
broken() on both i386/x86_64, w/o frame pointer. For i386:

000000b0 <_spin_lock_bh>:
  b0:   53                      push   %ebx /* break profile_pc() */
  b1:   89 c3                   mov    %eax,%ebx

On x86_64 it's broken with or w/o frame pointer.

I understand the motivation to get the eip calling a spinlock function,
but that's a cheat and it has a price. Beside that, the trouble is also
on oprofile side, magic value are evil. This bug exists since at least
2.6.13.

Sami can you try the attached patch, the chunk in buffer_sync.c is
here only to avoid oopsing if another problem exists somewhere.


-- 
Phe

--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="oprof-fix-profile_pc-use.patch"

--- drivers/oprofile/cpu_buffer.c.orig	2007-10-03 21:36:08.000000000 +0200
+++ drivers/oprofile/cpu_buffer.c	2007-10-11 12:41:57.000000000 +0200
@@ -241,7 +241,7 @@
 void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 {
 	int is_kernel = !user_mode(regs);
-	unsigned long pc = profile_pc(regs);
+	unsigned long pc = instruction_pointer(regs);
 
 	oprofile_add_ext_sample(pc, regs, event, is_kernel);
 }
--- drivers/oprofile/buffer_sync.c.orig	2007-10-04 10:15:27.000000000 +0200
+++ drivers/oprofile/buffer_sync.c	2007-10-11 12:49:22.000000000 +0200
@@ -530,11 +530,30 @@
 				/* userspace context switch */
 				new = (struct task_struct *)s->event;
 
-				release_mm(oldmm);
-				mm = take_tasks_mm(new);
-				if (mm != oldmm)
-					cookie = get_exec_dcookie(mm);
-				add_user_ctx_switch(new, cookie);
+				/* Ugly, let says task pointer can't be
+				   in the last page nor in the first page */
+				if (s->event + 0x1000 > 0x2000) {
+					release_mm(oldmm);
+					mm = take_tasks_mm(new);
+					if (mm != oldmm)
+						cookie = get_exec_dcookie(mm);
+					add_user_ctx_switch(new, cookie);
+				} else {
+					static int show_it = 0;
+					if (show_it++ < 5) {
+						printk(KERN_INFO
+						       "oprofile: Invalid "
+						       "event %lu, head %lu, "
+						       "tail %lu, eip %lu, "
+						       "available %lu, i %u "
+						       "state %d %d\n",
+						       s->event,
+						       cpu_buf->head_pos,
+						       cpu_buf->tail_pos,
+						       s->eip, available, i,
+						       state, in_kernel);
+					}
+				}
 			}
 		} else {
 			if (state >= sb_bt_start &&

--6c2NcOVqGQ03X4Wi--

