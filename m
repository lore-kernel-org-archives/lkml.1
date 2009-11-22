Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZKVXIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZKVXIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 18:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbZKVXIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 18:08:23 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50517 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbZKVXIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 18:08:22 -0500
Date: Mon, 23 Nov 2009 10:08:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>, Wu Zhangjin <wuzhangjin@gmail.com>
Subject: linux-next: manual merge of the mips tree with the microblaze tree
Message-Id: <20091123100825.ecd759ff.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

Today's linux-next merge of the mips tree got a conflict in
scripts/recordmcount.pl between commit
3e3bc9dd3155ae0fdccdbdfb26d97e15c7acc499 ("microblaze: ftrace: Add
dynamic trace support") from the microblaze tree and commit
421e89b8ce7594cf5df27d801c433dbb69184486 ("MIPS: Tracing: Add dynamic
function tracer support") from the mips tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.  Thanks for the heads up, Ralf.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc scripts/recordmcount.pl
index b30dabd,d016c71..0000000
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@@ -245,9 -245,60 +245,63 @@@ if ($arch eq "x86_64") 
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
