Return-Path: <linux-kernel-owner+w=401wt.eu-S1751675AbXJUVgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbXJUVgB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 17:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbXJUVfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 17:35:54 -0400
Received: from mailout1.informatik.tu-muenchen.de ([131.159.0.12]:52227 "EHLO
	mailout1.informatik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbXJUVfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 17:35:53 -0400
X-Greylist: delayed 630 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Oct 2007 17:35:53 EDT
Message-ID: <471BC3C2.2050602@in.tum.de>
Date: Sun, 21 Oct 2007 23:25:22 +0200
From: Michael Weiss <weissm@in.tum.de>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Problem running a task in ring 2 on x86
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=F4B35426;
	url=http://home.in.tum.de/~weissm/Michael_Weiss_weissm@in.tum.de_(0xF4B35426)_pub.asc
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to get a process to ring level 2 on IA-32 architecture.
Therefore I have patched the modify_ldt syscall in ldt.c to generate a
new ldt entry with rpl 2 (patch below).

Now my problem is how to get the code segment with rpl2, located in
the ldt at index 0,
loaded by a syscall, so that the application is running in ring 2
after return of that syscall.

Under kernel 2.0.x the following seemed to do this, if ptr is a
pointer to a userstack allocated with malloc:

asmlinkage int sys_set_rpl(long ptr) {

   struct pt_regs *regs = (struct pt_regs *)&ptr;

   regs->cs = 0x6;  /* first entry of ldt with rpl2 */
   regs->ss = 0xE;  /* 2. entry of ldt with rpl2 */
   current->tss.ss2 = 0xE;
   current->tss.esp2 = ptr;

   return(0);

}

Now there is no tss per task and no hw context switch in the newer
kernels this isn't working in 2.6.

So if any of you have an idea to get a solution for that problem I
were very pleased.
I need this for an memory protection implementation in my bachelor thesis.


Thanks,
Michael

Here's the patch for modify_ldt:

diff -ru /usr/src/linux-2.6.22.5/arch/i386/kernel/ldt.c
arch/i386/kernel/ldt.c
--- /usr/src/linux-2.6.22.5/arch/i386/kernel/ldt.c      2007-08-23
01:23:54.000000000 +0200
+++ arch/i386/kernel/ldt.c      2007-10-21 22:29:12.000000000 +0200
@@ -172,7 +172,7 @@
        return err;
 }

-static int write_ldt(void __user * ptr, unsigned long bytecount, int
oldmode)
+static int write_ldt_mod(void __user * ptr, unsigned long bytecount,
int oldmode, int rpl)
 {
        struct mm_struct * mm = current->mm;
        __u32 entry_1, entry_2;
@@ -214,6 +214,11 @@

        entry_1 = LDT_entry_a(&ldt_info);
        entry_2 = LDT_entry_b(&ldt_info);
+
+       /* modify the rpl from 3 to 2 */
+       if (rpl == 2)
+               entry_2 &= ~(1 << 14);
+
        if (oldmode)
                entry_2 &= ~(1 << 20);

@@ -228,6 +233,10 @@
        return error;
 }

+static int write_ldt(void __user * ptr, unsigned long bytecount, int
oldmode) {
+       return write_ldt_mod(ptr, bytecount, oldmode, 3);
+}
+
 asmlinkage int sys_modify_ldt(int func, void __user *ptr, unsigned
long bytecount)
 {
        int ret = -ENOSYS;
@@ -245,6 +254,10 @@
        case 0x11:
                ret = write_ldt(ptr, bytecount, 0);
                break;
+       /* create new ldt entry with rpl 2 */
+       case 4:
+               ret = write_ldt_mod(ptr, bytecount, 0, 2);
+               break;
        }
        return ret;
 }

