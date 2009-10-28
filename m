Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbZJ1HE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbZJ1HE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbZJ1HE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:04:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57069 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557AbZJ1HE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:04:56 -0400
Date: Wed, 28 Oct 2009 18:04:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: linux-next: manual merge of the tip tree with the kgdb tree
Message-Id: <20091028180454.488609b7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/kernel/kgdb.c between commit
1cde88814e04c3b2bbe60e20c0927a0b4e1748ab ("kgdb,i386: Fix corner case
access to sp with NMI watch dog exception") from the kgdb tree and commit
5ca6c0ca5dbf105d7b0ffdae2289519982189730 ("x86: use kernel_stack_pointer
() in kgdb.c") from the tip tree.

I fixed it up (see below) but would like people to check as I am not sure
of the fix.  I can carry this as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/kgdb.c
index e9afae9,3310d84..0000000
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@@ -85,15 -85,9 +85,15 @@@ void pt_regs_to_gdb_regs(unsigned long 
  	gdb_regs[GDB_DS]	= regs->ds;
  	gdb_regs[GDB_ES]	= regs->es;
  	gdb_regs[GDB_CS]	= regs->cs;
 -	gdb_regs[GDB_SS]	= __KERNEL_DS;
  	gdb_regs[GDB_FS]	= 0xFFFF;
  	gdb_regs[GDB_GS]	= 0xFFFF;
 +	if (user_mode_vm(regs)) {
 +		gdb_regs[GDB_SS] = regs->ss;
 +		gdb_regs[GDB_SP] = regs->sp;
 +	} else {
 +		gdb_regs[GDB_SS] = __KERNEL_DS;
- 		gdb_regs[GDB_SP] = (unsigned long)&regs->sp;
++		gdb_regs[GDB_SP] = kernel_stack_pointer(regs);
 +	}
  #else
  	gdb_regs[GDB_R8]	= regs->r8;
  	gdb_regs[GDB_R9]	= regs->r9;
@@@ -106,8 -100,8 +106,8 @@@
  	gdb_regs32[GDB_PS]	= regs->flags;
  	gdb_regs32[GDB_CS]	= regs->cs;
  	gdb_regs32[GDB_SS]	= regs->ss;
- 	gdb_regs[GDB_SP]	= regs->sp;
 -#endif
+ 	gdb_regs[GDB_SP]	= kernel_stack_pointer(regs);
 +#endif
  }
  
  /**
