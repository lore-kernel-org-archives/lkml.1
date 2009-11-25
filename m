Return-Path: <linux-kernel-owner+w=401wt.eu-S1750860AbZKYFVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750860AbZKYFVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 00:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZKYFVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 00:21:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50948 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbZKYFVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 00:21:40 -0500
Date: Wed, 25 Nov 2009 16:21:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Nelson Elhage <nelhage@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the rr tree with the arm tree
Message-Id: <20091125162143.f3ecd684.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
arch/arm/kernel/vmlinux.lds.S between commit
78d7530ac338e458fa513527ee7bb4278d0d8017 ("ARM: Clean up linker script
using new linker script macros") from the arm tree and commit
0a5e2c8918d0945f6384e104050c5234057455df ("ARM: use unified discard
definition in linker script") from the rr tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/kernel/vmlinux.lds.S
index 71151bd,ec511d4..0000000
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@@ -58,18 -77,13 +58,18 @@@ SECTION
  #endif
  	}
  
 +	PERCPU(PAGE_SIZE)
 +
 +#ifndef CONFIG_XIP_KERNEL
 +	. = ALIGN(PAGE_SIZE);
 +	__init_end = .;
 +#endif
 +
- 	/DISCARD/ : {			/* Exit code and data		*/
- 		EXIT_TEXT
- 		EXIT_DATA
- 		*(.exitcall.exit)
- 		*(.discard)
+ 	/*
+ 	 * unwind exit sections must be discarded before the rest of the
+ 	 * unwind sections get included.
+ 	 */
+ 	/DISCARD/ : {
  		*(.ARM.exidx.exit.text)
  		*(.ARM.extab.exit.text)
  #ifndef CONFIG_HOTPLUG_CPU
@@@ -233,11 -256,24 +233,14 @@@
  	}
  #endif
  
 -	.bss : {
 -		__bss_start = .;	/* BSS				*/
 -		*(.bss)
 -		*(COMMON)
 -		__bss_stop = .;
 -		_end = .;
 -	}
 -					/* Stabs debugging sections.	*/
 -	.stab 0 : { *(.stab) }
 -	.stabstr 0 : { *(.stabstr) }
 -	.stab.excl 0 : { *(.stab.excl) }
 -	.stab.exclstr 0 : { *(.stab.exclstr) }
 -	.stab.index 0 : { *(.stab.index) }
 -	.stab.indexstr 0 : { *(.stab.indexstr) }
 +	BSS_SECTION(0, 0, 0)
 +	_end = .;
 +
 +	STABS_DEBUG
  	.comment 0 : { *(.comment) }
+ 
+ 	/* Default discards */
+ 	DISCARDS
  }
  
  /*
