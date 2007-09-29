Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbXI2GJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbXI2GJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 02:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbXI2GJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 02:09:39 -0400
Received: from gw.goop.org ([64.81.55.164]:58727 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbXI2GJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 02:09:37 -0400
Message-ID: <46FDEC1F.7080809@goop.org>
Date: Fri, 28 Sep 2007 23:09:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: William Cattey <wdc@MIT.EDU>
CC: Andi Kleen <andi@firstfloor.org>, Chuck Anderson <cra@WPI.EDU>,
       linux-kernel@vger.kernel.org
Subject: Re: vm86.c audit_syscall_exit() call trashes registers
References: <20070814183119.GC17694@angus.ind.WPI.EDU> <p73r6m5n90l.fsf@bingen.suse.de> <78642229-39DD-4956-9385-5A3F960BFEEF@mit.edu> <20070814212858.GB23308@one.firstfloor.org> <07759638-DE7C-4341-A642-D611A897614F@MIT.EDU> <20070814214622.GE23308@one.firstfloor.org> <6655DD8B-D9C6-495D-9E22-2FDF6B375C9D@MIT.EDU> <20070814221927.GH23308@one.firstfloor.org> <9D5ACA40-5F33-4F49-8255-D51F554889E7@MIT.EDU> <46FDA325.8000602@goop.org> <7CB783C7-8EC7-4AA3-B825-B23595373229@MIT.EDU> <46FDEB6D.6000403@goop.org>
In-Reply-To: <46FDEB6D.6000403@goop.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> @@ -306,19 +334,18 @@ static void do_sys_vm86(struct kernel_vm
>         tsk->thread.screen_bitmap = info->screen_bitmap;
>         if (info->flags & VM86_SCREEN_BITMAP)
>                 mark_screen_rdonly(tsk->mm);
>         __asm__ __volatile__("xorl %eax,%eax; movl %eax,%fs; movl %eax,%gs\n\t");
>   

Oh, this line is also clearly bogus, since it clobbers %eax without
telling the compiler.  The minimal change would be something like:

	asm volatile("mov %0, %%fs; mov %0, %%gs" : : "r" (0));


    J
