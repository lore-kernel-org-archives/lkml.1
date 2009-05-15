Return-Path: <linux-kernel-owner+w=401wt.eu-S1762521AbZEOPR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762521AbZEOPR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 11:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbZEOPRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 11:17:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057AbZEOPRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 11:17:17 -0400
Date: Fri, 15 May 2009 08:16:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jason Wessel <jason.wessel@windriver.com>
cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 2/3] kgdb,i386: use address that SP register points to
 in the exception frame
In-Reply-To: <1242393479-19351-3-git-send-email-jason.wessel@windriver.com>
Message-ID: <alpine.LFD.2.01.0905150814180.3343@localhost.localdomain>
References: <1242393479-19351-1-git-send-email-jason.wessel@windriver.com> <1242393479-19351-2-git-send-email-jason.wessel@windriver.com> <1242393479-19351-3-git-send-email-jason.wessel@windriver.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 May 2009, Jason Wessel wrote:
>
> The treatment of the SP register is different on x86_64 and i386.
> This is a regression fix that lived outside the mainline kernel from
> 2.6.27 to now.  The regression was a result of the original merge
> consolidation of the i386 and x86_64 archs to x86.
> 
> The incorrectly reported SP on i386 prevented stack tracebacks from
> working correctly in gdb.

Is this only ever used for kernel register state?

Because in the _general_ case, the code should likely be something like

	if (user_mode_vm(regs)) {
		gdb_regs[GDB_SS] = regs->ss;
		gdb_regs[GDB_SP] = regs->sp;
	} else {
		gdb_regs[GDB_SS] = __KERNEL_DS;
		gdb_regs[GDB_SP] = (unsigned long)&regs->sp
	}

if the 'regs' contents can ever point to user mode state.

		Linus
