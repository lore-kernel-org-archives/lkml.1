Return-Path: <linux-kernel-owner+w=401wt.eu-S1763347AbYBLQfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763347AbYBLQfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758244AbYBLQe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:34:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56207 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050AbYBLQe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:34:58 -0500
Date: Tue, 12 Feb 2008 18:10:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212171028.GC4191@one.firstfloor.org>
References: <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <47B19F67.5050105@windriver.com> <20080212143949.GA2258@one.firstfloor.org> <47B1AEC3.2080402@windriver.com> <20080212153612.GA2944@one.firstfloor.org> <47B1C76F.6070908@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B1C76F.6070908@windriver.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is more than a simple recursion check (which is already in the code)
> because there are some conditions we can recover from.  I'd rather not
> crash the system out if it can be recovered.

Ok I'm trying to understand the code as you describe it. As far 
as I can see (in kgdb-light-v10) it is:

+       addr = kgdb_arch_pc(ks->ex_vector, ks->linux_regs);
+       kgdb_deactivate_sw_breakpoints();
+
+       /*
+        * If the break point removed ok at the place exception
+        * occurred, try to recover and print a warning to the end
+        * user because the user planted a breakpoint in a place that
+        * KGDB needs in order to function.
+        */
+       if (kgdb_remove_sw_break(addr) == 0) {

and

+static int kgdb_remove_sw_break(unsigned long addr)
+{
+       int i;
+
+       for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+               if ((kgdb_break[i].state == BP_SET) &&
+                               (kgdb_break[i].bpt_addr == addr)) {
+                       kgdb_break[i].state = BP_REMOVED;
+                       return 0;
+               }
+       }
+       return -ENOENT;

correct? 

I don't think that code does what you describe at all. Are you
sure we're talking about the same thing? 

There is certainly no real protection against break points in
debugger code in there as far as I can see (except for the reentry
counter)

-Andi
