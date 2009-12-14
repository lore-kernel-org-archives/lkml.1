Return-Path: <linux-kernel-owner+w=401wt.eu-S932894AbZLNXUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894AbZLNXUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932630AbZLNXUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:20:50 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39168 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932628AbZLNXUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:20:49 -0500
Date: Tue, 15 Dec 2009 10:20:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>, Li Hong <lihong.hi@gmail.com>,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: linux-next: manual merge of the mips tree with Linus' tree
Message-Id: <20091215102046.6fc8faa8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

Today's linux-next merge of the mips tree got a conflict in
scripts/recordmcount.pl between commits
e2d753fac5b3954a3b6001f98479f0435fe7c868 ("tracing: Correct the check for
number of arguments in recordmcount.pl") and
7d241ff0567b9503d79ee775c40927d09b509f83 ("microblaze: ftrace: Add
dynamic trace support") from Linus' tree and commits
84bc2d35f211a83e806711c94f78a227c4810848 ("MIPS: Tracing: Add an endian
argument to scripts/recordmcount.pl") and
b2b11a5cb24b8f234bc4746dc40722b01fa45a43 ("MIPS: Tracing: Add dynamic
function tracer support") from the mips tree.

These conflicts are now between Linus' tree and the mips tree so, Ralf,
you should be able to fix them up by merging with Linus' tree.

I have fixed them up (see below) (for the first pair of commits above, I
used the mips tree version) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc scripts/recordmcount.pl
index 9cf0a6f,d016c71..0000000
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@@ -295,9 -245,60 +295,63 @@@ if ($arch eq "x86_64") 
      $ld .= " -m elf64_sparc";
      $cc .= " -m64";
      $objcopy .= " -O elf64-sparc";
 +} elsif ($arch eq "microblaze") {
 +    # Microblaze calls '_mcount' instead of plain 'mcount'.
 +    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
+ 
+ } elsif ($arch eq "mips") {
+     # To enable module support, we need to enable the -mlong-calls option
+     # of gcc for module, after using this option, we can not get the real
+     # offset of the calling to _mcount, but the offset of the lui
+     # instruction or the addiu one. herein, we record the address of the
+     # first one, and then we can replace this instruction by a branch
+     # instruction to jump over the profiling function to filter the
+     # indicated functions, or swith back to the lui instruction to trace
+     # them, which means dynamic tracing.
+     #
+     #       c:	3c030000 	lui	v1,0x0
+     #			c: R_MIPS_HI16	_mcount
+     #			c: R_MIPS_NONE	*ABS*
+     #			c: R_MIPS_NONE	*ABS*
+     #      10:	64630000 	daddiu	v1,v1,0
+     #			10: R_MIPS_LO16	_mcount
+     #			10: R_MIPS_NONE	*ABS*
+     #			10: R_MIPS_NONE	*ABS*
+     #      14:	03e0082d 	move	at,ra
+     #      18:	0060f809 	jalr	v1
+     #
+     # for the kernel:
+     #
+     #     10:   03e0082d        move    at,ra
+     #	  14:   0c000000        jal     0 <loongson_halt>
+     #                    14: R_MIPS_26   _mcount
+     #                    14: R_MIPS_NONE *ABS*
+     #                    14: R_MIPS_NONE *ABS*
+     #	 18:   00020021        nop
+     if ($is_module eq "0") {
+ 	    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
+     } else {
+ 	    $mcount_regex = "^\\s*([0-9a-fA-F]+): R_MIPS_HI16\\s+_mcount\$";
+     }
+     $objdump .= " -Melf-trad".$endian."mips ";
+ 
+     if ($endian eq "big") {
+ 	    $endian = " -EB ";
+ 	    $ld .= " -melf".$bits."btsmip";
+     } else {
+ 	    $endian = " -EL ";
+ 	    $ld .= " -melf".$bits."ltsmip";
+     }
+ 
+     $cc .= " -mno-abicalls -fno-pic -mabi=" . $bits . $endian;
+     $ld .= $endian;
+ 
+     if ($bits == 64) {
+ 	    $function_regex =
+ 		"^([0-9a-fA-F]+)\\s+<(.|[^\$]L.*?|\$[^L].*?|[^\$][^L].*?)>:";
+ 	    $type = ".dword";
+     }
+ 
  } else {
      die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
  }
