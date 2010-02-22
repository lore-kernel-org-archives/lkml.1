Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab0BVOlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 09:41:46 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:38554 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab0BVOlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 09:41:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=wq8PFmUI2CG743NxSjH2Zi3Rh03DAgmsQ4FZA4YOJbxaZXYS4hhg+IxQAWddJsmYWQ
         CvikWuXPJXuiLigs9n6ExoZoTk0Xqw2SbADi+SmuZtzMT5fI7BTuDIOhiAfHClJKao+y
         iVTn8F0miyjbFTdJtuUusPeWQblHYkEBPjroE=
Message-ID: <4B82979E.6030503@gmail.com>
Date: Mon, 22 Feb 2010 22:41:34 +0800
From: Hui Zhu <teawater@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
       gdb-patches ml <gdb-patches@sourceware.org>,
       Michal Marek <mmarek@suse.cz>
Subject: [PATCH 1/2] markup_oops.pl and GDB: markup_oops.pl: make it can show
 gdb command
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a new option "-g" to markup_oops.pl. When use it,
markup_oops.pl will just show the gdb command.

Signed-off-by: Hui Zhu <teawater@gmail.com>

---
 scripts/markup_oops.pl |  141 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 137 insertions(+), 4 deletions(-)

--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -19,11 +19,14 @@ use Getopt::Long;
 my $cross_compile = "";
 my $vmlinux_name = "";
 my $modulefile = "";
+my $show_gdb_cmd = 0;
+my @stack;
 
 # Get options
 Getopt::Long::GetOptions(
 	'cross-compile|c=s'	=> \$cross_compile,
 	'module|m=s'		=> \$modulefile,
+	'gdb|g!'		=> \$show_gdb_cmd,
 	'help|h'		=> \&usage,
 ) || usage ();
 my $vmlinux_name = $ARGV[0];
@@ -58,8 +61,21 @@ sub parse_x86_regs
 	if ($line =~ /ESI: ([0-9a-f]+) EDI: ([0-9a-f]+) EBP: ([0-9a-f]+) ESP: ([0-9a-f]+)/) {
 		$regs{"%esi"} = $1;
 		$regs{"%edi"} = $2;
+		$regs{"%ebp"} = $3;
 		$regs{"%esp"} = $4;
 	}
+	if ($line =~ / DS: ([0-9a-f]+) ES: ([0-9a-f]+) FS: ([0-9a-f]+) GS: ([0-9a-f]+) SS: ([0-9a-f]+)/) {
+		$regs{"%ds"} = $1;
+		$regs{"%es"} = $2;
+		$regs{"%fs"} = $3;
+		$regs{"%gs"} = $4;
+		$regs{"%ss"} = $5;
+	}
+	if ($line =~ /RSP: ([0-9a-f]+):([0-9a-f]+)  EFLAGS: ([0-9a-f]+)/) {
+		$regs{"%ss"} = $1;
+		$regs{"%esp"} = $2;
+		$regs{"%eflags"} = $3;
+	}
 	if ($line =~ /RAX: ([0-9a-f]+) RBX: ([0-9a-f]+) RCX: ([0-9a-f]+)/) {
 		$regs{"%eax"} = $1;
 		$regs{"%ebx"} = $2;
@@ -71,6 +87,7 @@ sub parse_x86_regs
 		$regs{"%edi"} = $3;
 	}
 	if ($line =~ /RBP: ([0-9a-f]+) R08: ([0-9a-f]+) R09: ([0-9a-f]+)/) {
+		$regs{"%ebp"} = $1;
 		$regs{"%r08"} = $2;
 		$regs{"%r09"} = $3;
 	}
@@ -84,6 +101,15 @@ sub parse_x86_regs
 		$regs{"%r14"} = $2;
 		$regs{"%r15"} = $3;
 	}
+	if ($line =~ /FS:  [0-9a-f]+\(([0-9a-f]+)\) GS:[0-9a-f]+\(([0-9a-f]+)\)/) {
+		$regs{"%fs"} = $1;
+		$regs{"%gs"} = $2;
+	}
+	if ($line =~ /CS:  ([0-9a-f]+) DS: ([0-9a-f]+) ES: ([0-9a-f]+)/) {
+		$regs{"%cs"} = $1;
+		$regs{"%ds"} = $2;
+		$regs{"%es"} = $3;
+	}
 }
 
 sub reg_name
@@ -155,14 +181,36 @@ sub process_x86_regs
 	return $str;
 }
 
+my $is_stack = 0;
+sub parse_x86_stack
+{
+	my ($line) = @_;
+
+	if ($line =~ s/^Stack: //) {
+		$is_stack = 1;
+	}
+
+	if ($is_stack && $line =~ /^ *[0-9a-f]+/) {
+		while ($line =~ s/([0-9a-f]+)//) {
+			$stack[$#stack + 1] = $1;
+		}
+	}
+	else {
+		$is_stack = 0;
+	}
+}
+
 # parse the oops
 while (<STDIN>) {
 	my $line = $_;
-	if ($line =~ /EIP: 0060:\[\<([a-z0-9]+)\>\]/) {
-		$target = $1;
+	if ($line =~ /EIP: ([0-9a-f]+):\[\<([a-z0-9]+)\>\] EFLAGS: ([0-9a-f]+)/) {
+		$regs{"%cs"} = $1;
+		$target = $2;
+		$regs{"%eflags"} = $3;
 	}
-	if ($line =~ /RIP: 0010:\[\<([a-z0-9]+)\>\]/) {
-		$target = $1;
+	if ($line =~ /RIP: ([0-9a-f]+):\[\<([a-z0-9]+)\>\]/) {
+		$regs{"%cs"} = $1;
+		$target = $2;
 	}
 	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+0x([0-9a-f]+)\/0x[a-f0-9]/) {
 		$function = $1;
@@ -181,6 +229,7 @@ while (<STDIN>) {
 		$module = $3;
 	}
 	parse_x86_regs($line);
+	parse_x86_stack($line);
 }
 
 my $decodestart = Math::BigInt->from_hex("0x$target") - Math::BigInt->from_hex("0x$func_offset");
@@ -212,6 +261,89 @@ if ($module ne "") {
 	close(FILE);
 }
 
+sub show_x86_regs
+{
+	if (defined($regs{"%r08"})) {
+		#64-bit
+		print "set \$rax=0x$regs{'%eax'}\n";
+		print "set \$rbx=0x$regs{'%ebx'}\n";
+		print "set \$rcx=0x$regs{'%ecx'}\n";
+		print "set \$rdx=0x$regs{'%edx'}\n";
+		print "set \$rsi=0x$regs{'%esi'}\n";
+		print "set \$rdi=0x$regs{'%edi'}\n";
+		print "set \$rsp=0x$regs{'%esp'}\n";
+		print "set \$rbp=0x$regs{'%ebp'}\n";
+		print "set \$r8=0x$regs{'%r08'}\n";
+		print "set \$r9=0x$regs{'%r09'}\n";
+		print "set \$r10=0x$regs{'%r10'}\n";
+		print "set \$r11=0x$regs{'%r11'}\n";
+		print "set \$r12=0x$regs{'%r12'}\n";
+		print "set \$r13=0x$regs{'%r13'}\n";
+		print "set \$r14=0x$regs{'%r14'}\n";
+		print "set \$r15=0x$regs{'%r15'}\n";
+		print "set \$rip=0x$target\n";
+		print "set \$eflags=0x$regs{'%eflags'}\n";
+		print "set \$cs=0x$regs{'%cs'}\n";
+		print "set \$ss=0x$regs{'%ss'}\n";
+		print "set \$ds=0x$regs{'%ds'}\n";
+		print "set \$es=0x$regs{'%es'}\n";
+		print "set \$fs=0x$regs{'%fs'}\n";
+		print "set \$gs=0x$regs{'%gs'}\n";
+	}
+	else {
+		#32-bit
+		print "set \$eax=0x$regs{'%eax'}\n" if (defined($regs{"%eax"}));
+		print "set \$ecx=0x$regs{'%ecx'}\n" if (defined($regs{"%ecx"}));
+		print "set \$edx=0x$regs{'%edx'}\n" if (defined($regs{"%edx"}));
+		print "set \$ebx=0x$regs{'%ebx'}\n" if (defined($regs{"%ebx"}));
+		print "set \$esp=0x$regs{'%esp'}\n" if (defined($regs{"%esp"}));
+		print "set \$ebp=0x$regs{'%ebp'}\n" if (defined($regs{"%ebp"}));
+		print "set \$esi=0x$regs{'%esi'}\n" if (defined($regs{"%esi"}));
+		print "set \$edi=0x$regs{'%edi'}\n" if (defined($regs{"%edi"}));
+		print "set \$cs=0x$regs{'%cs'}\n" if (defined($regs{"%cs"}));
+		print "set \$ss=0x$regs{'%ss'}\n" if (defined($regs{"%ss"}));
+		print "set \$ds=0x$regs{'%ds'}\n" if (defined($regs{"%ds"}));
+		print "set \$es=0x$regs{'%es'}\n" if (defined($regs{"%es"}));
+		print "set \$fs=0x$regs{'%fs'}\n" if (defined($regs{"%fs"}));
+		print "set \$gs=0x$regs{'%gs'}\n" if (defined($regs{"%gs"}));
+		print "flushregs\n";
+		print "set \$eip=0x$target\n" if (defined($target));
+		print "set \$eflags=0x$regs{'%eflags'}\n" if (defined($regs{"%eflags"}));
+	}
+}
+
+# Show gdb command if -g.
+if ($show_gdb_cmd) {
+	# Show the vmlinux load command.
+	print "file $vmlinux_name\n";
+
+	# Show the module load command if need.
+	if ($modulefile ne "") {
+		print "add-symbol-file $modulefile $vmaoffset\n";
+	}
+
+	# Show the target empty command.
+	print "target empty\n";
+
+	# Show the registers set commands.
+	show_x86_regs();
+
+	# Show the memory set commands.
+	my $stack_address = Math::BigInt->from_hex("0x".$regs{"%esp"});
+	foreach my $num(@stack) {
+		print 'set (*(uint'.(length ($num) * 4)."_t (*)) $stack_address) = 0x$num\n";
+		$stack_address += length ($num) / 2;
+	}
+
+	# Show "flushregs" command.
+	print "flushregs\n";
+
+	# Show "frame" command.
+	print "frame\n";
+
+	exit;
+}
+
 my $counter = 0;
 my $state   = 0;
 my $center  = -1;
@@ -363,6 +495,7 @@ Usage:
 OPTION:
   -c, --cross-compile CROSS_COMPILE	Specify the prefix used for toolchain.
   -m, --module MODULE_DIRNAME		Specify the module filename.
+  -g, --gdb				Show GDB command.
   -h, --help				Help.
 EOT
 	exit;

