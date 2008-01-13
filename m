Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYAMSgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYAMSgn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 13:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbYAMSfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 13:35:04 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49204 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753336AbYAMSe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 13:34:56 -0500
Message-Id: <20080113183453.973425000@sgi.com>
User-Agent: quilt/0.46-1
Date: Sun, 13 Jan 2008 10:34:53 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/10] x86: Reduce memory and intra-node effects with large count NR_CPUs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset addresses the kernel bloat that occurs when NR_CPUS is increased.
The memory numbers below are with NR_CPUS = 1024 which I've been testing (4 and
32 real processors, the rest "possible" using the additional_cpus start option.)
These changes are all specific to the x86 architecture, non-arch specific
changes will follow.

Based on 2.6.24-rc6-mm1

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
---

The following columns are using the default x86_64 config with no modules.
32cpus is the default NR_CPUS, 1kcpus-before has NR_CPUS = 1024, and
1kcpus-after is after applying this patch.

As noticeable below there's still plenty of room for improvement... ;-)

32cpus			  1kcpus-before		    1kcpus-after
       228 .altinstr_repl 	  +0 .altinstr_repl 	    +0 .altinstr_repl
      1219 .altinstructio 	  +0 .altinstructio 	    +0 .altinstructio
    717512 .bss		    +1542784 .bss	       -147456 .bss
     61374 .comment	  	  +0 .comment	    	    +0 .comment
	16 .con_initcall. 	  +0 .con_initcall. 	    +0 .con_initcall.
    425256 .data	      +20224 .data	    	 -1024 .data
    178688 .data.cachelin  +12898304 .data.cachelin 	    +0 .data.cachelin
      8192 .data.init_tas 	  +0 .data.init_tas 	    +0 .data.init_tas
      4096 .data.page_ali 	  +0 .data.page_ali 	    +0 .data.page_ali
     27008 .data.percpu	     +128768 .data.percpu   	  +128 .data.percpu
     43904 .data.read_mos   +8707872 .data.read_mos 	 -4096 .data.read_mos
	 4 .data_nosave	  	  +0 .data_nosave   	    +0 .data_nosave
      5141 .exit.text	  	  +9 .exit.text	    	    -1 .exit.text
    138480 .init.data	  	+992 .init.data	    	 +3616 .init.data
       133 .init.ramfs	  	  +0 .init.ramfs    	    +1 .init.ramfs
      3192 .init.setup	  	  +0 .init.setup    	    +0 .init.setup
    159754 .init.text	  	+891 .init.text	    	   +13 .init.text
      2288 .initcall.init 	  +0 .initcall.init 	    +0 .initcall.init
	 8 .jiffies	  	  +0 .jiffies	    	    +0 .jiffies
      4512 .pci_fixup	  	  +0 .pci_fixup	    	    +0 .pci_fixup
   1314438 .rodata	       +1312 .rodata	    	  -552 .rodata
     36552 .smp_locks	  	+256 .smp_locks	    	    +0 .smp_locks
   3971848 .text	      +12992 .text	    	 +1781 .text
      3368 .vdso	  	  +0 .vdso	    	    +0 .vdso
	 4 .vgetcpu_mode  	  +0 .vgetcpu_mode  	    +0 .vgetcpu_mode
       218 .vsyscall_0	  	  +0 .vsyscall_0    	    +0 .vsyscall_0
	52 .vsyscall_1	  	  +0 .vsyscall_1    	    +0 .vsyscall_1
	91 .vsyscall_2	  	  +0 .vsyscall_2    	    +0 .vsyscall_2
	 8 .vsyscall_3	  	  +0 .vsyscall_3    	    +0 .vsyscall_3
	54 .vsyscall_fn	  	  +0 .vsyscall_fn   	    +0 .vsyscall_fn
	80 .vsyscall_gtod 	  +0 .vsyscall_gtod 	    +0 .vsyscall_gtod
     39480 __bug_table	  	  +0 __bug_table    	    +0 __bug_table
     16320 __ex_table	  	  +0 __ex_table	    	    +0 __ex_table
      9160 __param	  	  +0 __param	    	    +0 __param
   7172678 Total	   +23314404 Total	       -147590 Total

-- 
