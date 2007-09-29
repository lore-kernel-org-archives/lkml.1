Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbXI2GGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbXI2GGu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 02:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbXI2GGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 02:06:42 -0400
Received: from gw.goop.org ([64.81.55.164]:34290 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbXI2GGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 02:06:42 -0400
Message-ID: <46FDEB6D.6000403@goop.org>
Date: Fri, 28 Sep 2007 23:06:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: William Cattey <wdc@MIT.EDU>
CC: Andi Kleen <andi@firstfloor.org>, Chuck Anderson <cra@WPI.EDU>,
       linux-kernel@vger.kernel.org
Subject: Re: vm86.c audit_syscall_exit() call trashes registers
References: <20070814183119.GC17694@angus.ind.WPI.EDU> <p73r6m5n90l.fsf@bingen.suse.de> <78642229-39DD-4956-9385-5A3F960BFEEF@mit.edu> <20070814212858.GB23308@one.firstfloor.org> <07759638-DE7C-4341-A642-D611A897614F@MIT.EDU> <20070814214622.GE23308@one.firstfloor.org> <6655DD8B-D9C6-495D-9E22-2FDF6B375C9D@MIT.EDU> <20070814221927.GH23308@one.firstfloor.org> <9D5ACA40-5F33-4F49-8255-D51F554889E7@MIT.EDU> <46FDA325.8000602@goop.org> <7CB783C7-8EC7-4AA3-B825-B23595373229@MIT.EDU>
In-Reply-To: <7CB783C7-8EC7-4AA3-B825-B23595373229@MIT.EDU>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Cattey wrote:
> Your fix seems to have remedied a problem we are having with EDID
> fetches through vm86.c.  At the present moment, we're trying to
> understand your cleanup so as to back port it to an earlier rev of the
> kernel (2.6.18).
>
> 3 questions for you:
>
> 1. Are we correct in understanding that your cleanup only touched
> vm86.c and vm86.h?
>
> 2. Do you remember your changes well enough from back when you made
> them in December 2006 to be able to point out the changes solely made
> to the audit calls?
>
> 3. Does correct operation of vm86.c in the 2.6 kernel require all of
> your changes, or just the subset that affects the audit calls?

It was only a small part of the patch.  I think it was basically this
hunk (hand-edited, so this won't apply directly):

@@ -306,19 +334,18 @@ static void do_sys_vm86(struct kernel_vm
        tsk->thread.screen_bitmap = info->screen_bitmap;
        if (info->flags & VM86_SCREEN_BITMAP)
                mark_screen_rdonly(tsk->mm);
        __asm__ __volatile__("xorl %eax,%eax; movl %eax,%fs; movl %eax,%gs\n\t");
-       __asm__ __volatile__("movl %%eax, %0\n" :"=r"(eax));
 
        /*call audit_syscall_exit since we do not exit via the normal paths */
        if (unlikely(current->audit_context))
-               audit_syscall_exit(AUDITSC_RESULT(eax), eax);
+               audit_syscall_exit(AUDITSC_RESULT(0), 0);
 

 

This is certainly a bogus piece of code, and it could result in more or
less random values of eax being passed to audit_syscall_exit().    But I
don't know if it will have any bearing on your EDID problem; the rest of
the patch is related to the introduction of using %gs as the base for
the per-processor data area, and shouldn't cause any functional change
to sys_vm86(), but its possible I fixed some other bug in the process.

    J
