Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbYGRJUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbYGRJUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbYGRJUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:20:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37253
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753698AbYGRJUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:20:36 -0400
Date: Fri, 18 Jul 2008 02:20:35 -0700 (PDT)
Message-Id: <20080718.022035.208722773.davem@davemloft.net>
To: roland@redhat.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] tracehook
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>
Date: Thu, 17 Jul 2008 00:25:41 -0700 (PDT)

> I have done some arch work and will submit this to the arch maintainers
> after the generic tracehook series settles in.  For now, that work is
> available in my GIT repositories, and in patch and mbox-of-patches form
> at http://people.redhat.com/roland/utrace/2.6-current/

Thanks for doing this work.

I took a quick look at the sparc64 tracehook support and only spotted
one issue.

You'll need special handling for 32-bit compat tasks when copying the
arguments in.  You can't just use the full 64-bit values because they
get 32-bit zero extended by the 32-bit syscall entry code, and this
doesn't propagate into the pt_regs copies.

See arch/sparc64/kernel/syscalls.S:linux_sparc_syscall32

So at a minimum, when _TIF_32BIT is set, you'll need to "u32" cast
the regs->u_regs[] values before assigning them into the unsigned long
array slots.

Actually, it's more complicated than that.  We have to sign extend
arguments in some cases, and this is performed by a class of stubs
in arch/sparc64/kernel/sys32.S which then revector to the real
system call handler.

I don't know how you want to handle those cases.  Should the tracehook
user know that it's a 32-bit task, what system call it is, and therefore
do the appropriate sign extensions?  That doesn't sound right.

So likely we have to properly sign extend those things here in the
asm/syscall.h handlers.

If you look at arch/sparc64/kernel/sys32.S it uses macros and then a
list of cases that could be slightly modified such that they could be
used to build argument sign extension tables.  Simply change the
explicit register name arguments to pure numbers (ie. %o0 becomes
plain 0) and adjust the assembler macros accordingly.

Then, in a C file somewhere, you set these macro defines differently
then feed the list of instantiations through them and build the table.

The other arch's with compat support will have this same exact issue.

