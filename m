Return-Path: <linux-kernel-owner+w=401wt.eu-S965220AbYEBXYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965220AbYEBXYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934333AbYEBXYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:24:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47703 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759571AbYEBXYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:24:08 -0400
Message-ID: <481BA272.6080905@zytor.com>
Date: Fri, 02 May 2008 16:23:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Carlos R. Mafra" <crmafra@ift.unesp.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/time.c: Silence gcc warning 'integer constant
 to large for long type'
References: <200805021858.m42Iw4Lj025952@tazenda.hos.anvin.org> <alpine.LFD.1.10.0805021407030.5994@woody.linux-foundation.org> <481B888F.3070302@zytor.com> <alpine.LFD.1.10.0805021515120.5994@woody.linux-foundation.org> <alpine.LFD.1.10.0805021528080.5994@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805021528080.5994@woody.linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------020309000603070007060806"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020309000603070007060806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> 
> Make the timeconst.h file just contain sane macros. No preprocessor games 
> etc. Just make it say
> 
> 	#define USEC_TO_HZ_MUL32 ..correct-value-here..
> 
> and not even generate macros with values that cannot be used (ie >64 
> bits).
> 

Updated git tree now available.  The timeconst patch (the only one that 
has changed) is attached.

git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-inttypes.git

	-hpa

--------------020309000603070007060806
Content-Type: text/x-patch;
 name="0024-Use-U64_C-instead-of-casts-in-kernel-time.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0024-Use-U64_C-instead-of-casts-in-kernel-time.c.patch"

From: H. Peter Anvin <hpa@zytor.com>
Subject: [PATCH 24/24] Make constants in kernel/timeconst.h fixed 64 bits
To: Linus Torvalds <torvalds@linux-foundation.org>,
    Andrew Morton <akpm@linux-foundation.org>,
    Tony Luck <tony.luck@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
    Linux Arch Mailing List <linux-arch@vger.kernel.org>,
    H. Peter Anvin <hpa@zytor.com>

Force constants in kernel/timeconst.h (except shift counts) to be 64 bits,
using U64_C() constructor macros, and eliminate constants that cannot
be represented at all in 64 bits.  This avoids warnings with some gcc
versions.

Drop generating 64-bit constants, since we have no real hope of
getting a full set (operation on 64-bit values requires a 128-bit
intermediate result, which gcc only supports on 64-bit platforms, and
only with libgcc support on some.)  Note that the use of these
constants does not depend on if we are on a 32- or 64-bit architecture.

This resolves Bugzilla 10153.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 kernel/time.c       |    8 ++++----
 kernel/timeconst.pl |   21 ++++++++++++++++-----
 2 files changed, 20 insertions(+), 9 deletions(-)

This is the corrected version of this patch.  My apologies.
The git repository has also been corrected:

git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-inttypes.git

Index: quilt.types/kernel/time.c
===================================================================
--- quilt.types.orig/kernel/time.c
+++ quilt.types/kernel/time.c
@@ -246,7 +246,7 @@ unsigned int inline jiffies_to_msecs(con
 	return (j + (HZ / MSEC_PER_SEC) - 1)/(HZ / MSEC_PER_SEC);
 #else
 # if BITS_PER_LONG == 32
-	return ((u64)HZ_TO_MSEC_MUL32 * j) >> HZ_TO_MSEC_SHR32;
+	return (HZ_TO_MSEC_MUL32 * j) >> HZ_TO_MSEC_SHR32;
 # else
 	return (j * HZ_TO_MSEC_NUM) / HZ_TO_MSEC_DEN;
 # endif
@@ -262,7 +262,7 @@ unsigned int inline jiffies_to_usecs(con
 	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
 #else
 # if BITS_PER_LONG == 32
-	return ((u64)HZ_TO_USEC_MUL32 * j) >> HZ_TO_USEC_SHR32;
+	return (HZ_TO_USEC_MUL32 * j) >> HZ_TO_USEC_SHR32;
 # else
 	return (j * HZ_TO_USEC_NUM) / HZ_TO_USEC_DEN;
 # endif
@@ -476,7 +476,7 @@ unsigned long msecs_to_jiffies(const uns
 	if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
 		return MAX_JIFFY_OFFSET;
 
-	return ((u64)MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
+	return (MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
 		>> MSEC_TO_HZ_SHR32;
 #endif
 }
@@ -491,7 +491,7 @@ unsigned long usecs_to_jiffies(const uns
 #elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
 	return u * (HZ / USEC_PER_SEC);
 #else
-	return ((u64)USEC_TO_HZ_MUL32 * u + USEC_TO_HZ_ADJ32)
+	return (USEC_TO_HZ_MUL32 * u + USEC_TO_HZ_ADJ32)
 		>> USEC_TO_HZ_SHR32;
 #endif
 }
Index: quilt.types/kernel/timeconst.pl
===================================================================
--- quilt.types.orig/kernel/timeconst.pl
+++ quilt.types/kernel/timeconst.pl
@@ -1,7 +1,7 @@
 #!/usr/bin/perl
 # -----------------------------------------------------------------------
 #
-#   Copyright 2007 rPath, Inc. - All Rights Reserved
+#   Copyright 2007-2008 rPath, Inc. - All Rights Reserved
 #
 #   This file is part of the Linux kernel, and is made available under
 #   the terms of the GNU General Public License version 2 or (at your
@@ -20,198 +20,138 @@
 %canned_values = (
 	24 => [
 		'0xa6aaaaab','0x2aaaaaa',26,
-		'0xa6aaaaaaaaaaaaab','0x2aaaaaaaaaaaaaa',58,
 		125,3,
 		'0xc49ba5e4','0x1fbe76c8b4',37,
-		'0xc49ba5e353f7ceda','0x1fbe76c8b439581062',69,
 		3,125,
 		'0xa2c2aaab','0xaaaa',16,
-		'0xa2c2aaaaaaaaaaab','0xaaaaaaaaaaaa',48,
 		125000,3,
 		'0xc9539b89','0x7fffbce4217d',47,
-		'0xc9539b8887229e91','0x7fffbce4217d2849cb25',79,
 		3,125000,
 	], 32 => [
 		'0xfa000000','0x6000000',27,
-		'0xfa00000000000000','0x600000000000000',59,
 		125,4,
 		'0x83126e98','0xfdf3b645a',36,
-		'0x83126e978d4fdf3c','0xfdf3b645a1cac0831',68,
 		4,125,
 		'0xf4240000','0x0',17,
-		'0xf424000000000000','0x0',49,
 		31250,1,
 		'0x8637bd06','0x3fff79c842fa',46,
-		'0x8637bd05af6c69b6','0x3fff79c842fa5093964a',78,
 		1,31250,
 	], 48 => [
 		'0xa6aaaaab','0x6aaaaaa',27,
-		'0xa6aaaaaaaaaaaaab','0x6aaaaaaaaaaaaaa',59,
 		125,6,
 		'0xc49ba5e4','0xfdf3b645a',36,
-		'0xc49ba5e353f7ceda','0xfdf3b645a1cac0831',68,
 		6,125,
 		'0xa2c2aaab','0x15555',17,
-		'0xa2c2aaaaaaaaaaab','0x1555555555555',49,
 		62500,3,
 		'0xc9539b89','0x3fffbce4217d',46,
-		'0xc9539b8887229e91','0x3fffbce4217d2849cb25',78,
 		3,62500,
 	], 64 => [
 		'0xfa000000','0xe000000',28,
-		'0xfa00000000000000','0xe00000000000000',60,
 		125,8,
 		'0x83126e98','0x7ef9db22d',35,
-		'0x83126e978d4fdf3c','0x7ef9db22d0e560418',67,
 		8,125,
 		'0xf4240000','0x0',18,
-		'0xf424000000000000','0x0',50,
 		15625,1,
 		'0x8637bd06','0x1fff79c842fa',45,
-		'0x8637bd05af6c69b6','0x1fff79c842fa5093964a',77,
 		1,15625,
 	], 100 => [
 		'0xa0000000','0x0',28,
-		'0xa000000000000000','0x0',60,
 		10,1,
 		'0xcccccccd','0x733333333',35,
-		'0xcccccccccccccccd','0x73333333333333333',67,
 		1,10,
 		'0x9c400000','0x0',18,
-		'0x9c40000000000000','0x0',50,
 		10000,1,
 		'0xd1b71759','0x1fff2e48e8a7',45,
-		'0xd1b71758e219652c','0x1fff2e48e8a71de69ad4',77,
 		1,10000,
 	], 122 => [
 		'0x8325c53f','0xfbcda3a',28,
-		'0x8325c53ef368eb05','0xfbcda3ac10c9714',60,
 		500,61,
 		'0xf9db22d1','0x7fbe76c8b',35,
-		'0xf9db22d0e560418a','0x7fbe76c8b43958106',67,
 		61,500,
 		'0x8012e2a0','0x3ef36',18,
-		'0x8012e29f79b47583','0x3ef368eb04325',50,
 		500000,61,
 		'0xffda4053','0x1ffffbce4217',45,
-		'0xffda4052d666a983','0x1ffffbce4217d2849cb2',77,
 		61,500000,
 	], 128 => [
 		'0xfa000000','0x1e000000',29,
-		'0xfa00000000000000','0x1e00000000000000',61,
 		125,16,
 		'0x83126e98','0x3f7ced916',34,
-		'0x83126e978d4fdf3c','0x3f7ced916872b020c',66,
 		16,125,
 		'0xf4240000','0x40000',19,
-		'0xf424000000000000','0x4000000000000',51,
 		15625,2,
 		'0x8637bd06','0xfffbce4217d',44,
-		'0x8637bd05af6c69b6','0xfffbce4217d2849cb25',76,
 		2,15625,
 	], 200 => [
 		'0xa0000000','0x0',29,
-		'0xa000000000000000','0x0',61,
 		5,1,
 		'0xcccccccd','0x333333333',34,
-		'0xcccccccccccccccd','0x33333333333333333',66,
 		1,5,
 		'0x9c400000','0x0',19,
-		'0x9c40000000000000','0x0',51,
 		5000,1,
 		'0xd1b71759','0xfff2e48e8a7',44,
-		'0xd1b71758e219652c','0xfff2e48e8a71de69ad4',76,
 		1,5000,
 	], 250 => [
 		'0x80000000','0x0',29,
-		'0x8000000000000000','0x0',61,
 		4,1,
 		'0x80000000','0x180000000',33,
-		'0x8000000000000000','0x18000000000000000',65,
 		1,4,
 		'0xfa000000','0x0',20,
-		'0xfa00000000000000','0x0',52,
 		4000,1,
 		'0x83126e98','0x7ff7ced9168',43,
-		'0x83126e978d4fdf3c','0x7ff7ced916872b020c4',75,
 		1,4000,
 	], 256 => [
 		'0xfa000000','0x3e000000',30,
-		'0xfa00000000000000','0x3e00000000000000',62,
 		125,32,
 		'0x83126e98','0x1fbe76c8b',33,
-		'0x83126e978d4fdf3c','0x1fbe76c8b43958106',65,
 		32,125,
 		'0xf4240000','0xc0000',20,
-		'0xf424000000000000','0xc000000000000',52,
 		15625,4,
 		'0x8637bd06','0x7ffde7210be',43,
-		'0x8637bd05af6c69b6','0x7ffde7210be9424e592',75,
 		4,15625,
 	], 300 => [
 		'0xd5555556','0x2aaaaaaa',30,
-		'0xd555555555555556','0x2aaaaaaaaaaaaaaa',62,
 		10,3,
 		'0x9999999a','0x1cccccccc',33,
-		'0x999999999999999a','0x1cccccccccccccccc',65,
 		3,10,
 		'0xd0555556','0xaaaaa',20,
-		'0xd055555555555556','0xaaaaaaaaaaaaa',52,
 		10000,3,
 		'0x9d495183','0x7ffcb923a29',43,
-		'0x9d495182a9930be1','0x7ffcb923a29c779a6b5',75,
 		3,10000,
 	], 512 => [
 		'0xfa000000','0x7e000000',31,
-		'0xfa00000000000000','0x7e00000000000000',63,
 		125,64,
 		'0x83126e98','0xfdf3b645',32,
-		'0x83126e978d4fdf3c','0xfdf3b645a1cac083',64,
 		64,125,
 		'0xf4240000','0x1c0000',21,
-		'0xf424000000000000','0x1c000000000000',53,
 		15625,8,
 		'0x8637bd06','0x3ffef39085f',42,
-		'0x8637bd05af6c69b6','0x3ffef39085f4a1272c9',74,
 		8,15625,
 	], 1000 => [
 		'0x80000000','0x0',31,
-		'0x8000000000000000','0x0',63,
 		1,1,
 		'0x80000000','0x0',31,
-		'0x8000000000000000','0x0',63,
 		1,1,
 		'0xfa000000','0x0',22,
-		'0xfa00000000000000','0x0',54,
 		1000,1,
 		'0x83126e98','0x1ff7ced9168',41,
-		'0x83126e978d4fdf3c','0x1ff7ced916872b020c4',73,
 		1,1000,
 	], 1024 => [
 		'0xfa000000','0xfe000000',32,
-		'0xfa00000000000000','0xfe00000000000000',64,
 		125,128,
 		'0x83126e98','0x7ef9db22',31,
-		'0x83126e978d4fdf3c','0x7ef9db22d0e56041',63,
 		128,125,
 		'0xf4240000','0x3c0000',22,
-		'0xf424000000000000','0x3c000000000000',54,
 		15625,16,
 		'0x8637bd06','0x1fff79c842f',41,
-		'0x8637bd05af6c69b6','0x1fff79c842fa5093964',73,
 		16,15625,
 	], 1200 => [
 		'0xd5555556','0xd5555555',32,
-		'0xd555555555555556','0xd555555555555555',64,
 		5,6,
 		'0x9999999a','0x66666666',31,
-		'0x999999999999999a','0x6666666666666666',63,
 		6,5,
 		'0xd0555556','0x2aaaaa',22,
-		'0xd055555555555556','0x2aaaaaaaaaaaaa',54,
 		2500,3,
 		'0x9d495183','0x1ffcb923a29',41,
-		'0x9d495182a9930be1','0x1ffcb923a29c779a6b5',73,
 		3,2500,
 	]
 );
@@ -264,6 +204,15 @@ sub fmuls($$$) {
 	return 0;
 }
 
+# Generate a hex value if the result fits in 64 bits;
+# otherwise skip.
+sub bignum_hex($) {
+	my($x) = @_;
+	my $s = $x->as_hex();
+
+	return (length($s) > 18) ? undef : $s;
+}
+
 # Provides mul, adj, and shr factors for a specific
 # (bit, time, hz) combination
 sub muladj($$$) {
@@ -271,7 +220,7 @@ sub muladj($$$) {
 	my $s = fmuls($b, $t, $hz);
 	my $m = fmul($s, $t, $hz);
 	my $a = fadj($s, $t, $hz);
-	return ($m->as_hex(), $a->as_hex(), $s);
+	return (bignum_hex($m), bignum_hex($a), $s);
 }
 
 # Provides numerator, denominator values
@@ -288,12 +237,10 @@ sub conversions($$) {
 
 	# HZ_TO_xx
 	push(@val, muladj(32, $t, $hz));
-	push(@val, muladj(64, $t, $hz));
 	push(@val, numden($t, $hz));
 
 	# xx_TO_HZ
 	push(@val, muladj(32, $hz, $t));
-	push(@val, muladj(64, $hz, $t));
 	push(@val, numden($hz, $t));
 
 	return @val;
@@ -318,6 +265,19 @@ sub compute_values($) {
 	return @val;
 }
 
+sub outputval($$)
+{
+	my($name, $val) = @_;
+	my $csuf;
+
+	if (defined($val)) {
+	    if ($name !~ /SHR/) {
+		$val = "U64_C($val)";
+	    }
+	    printf "#define %-23s %s\n", $name.$csuf, $val.$csuf;
+	}
+}
+
 sub output($@)
 {
 	my($hz, @val) = @_;
@@ -331,6 +291,7 @@ sub output($@)
 	print "\n";
 
 	print "#include <linux/param.h>\n";
+	print "#include <linux/types.h>\n";
 
 	print "\n";
 	print "#if HZ != $hz\n";
@@ -340,15 +301,13 @@ sub output($@)
 
 	foreach $pfx ('HZ_TO_MSEC','MSEC_TO_HZ',
 		      'HZ_TO_USEC','USEC_TO_HZ') {
-		foreach $bit (32, 64) {
+		foreach $bit (32) {
 			foreach $suf ('MUL', 'ADJ', 'SHR') {
-				printf "#define %-23s %s\n",
-					"${pfx}_$suf$bit", shift(@val);
+				outputval("${pfx}_$suf$bit", shift(@val));
 			}
 		}
 		foreach $suf ('NUM', 'DEN') {
-			printf "#define %-23s %s\n",
-				"${pfx}_$suf", shift(@val);
+			outputval("${pfx}_$suf", shift(@val));
 		}
 	}
 
@@ -356,6 +315,23 @@ sub output($@)
 	print "#endif /* KERNEL_TIMECONST_H */\n";
 }
 
+# Pretty-print Perl values
+sub perlvals(@) {
+	my $v;
+	my @l = ();
+
+	foreach $v (@_) {
+		if (!defined($v)) {
+			push(@l, 'undef');
+		} elsif ($v =~ /^0x/) {
+			push(@l, "\'".$v."\'");
+		} else {
+			push(@l, $v.'');
+		}
+	}
+	return join(',', @l);
+}
+
 ($hz) = @ARGV;
 
 # Use this to generate the %canned_values structure
@@ -373,15 +349,15 @@ if ($hz eq '--can') {
 		print "$pf$hz => [\n";
 		while (scalar(@values)) {
 			my $bit;
-			foreach $bit (32, 64) {
+			foreach $bit (32) {
 				my $m = shift(@values);
 				my $a = shift(@values);
 				my $s = shift(@values);
-				print "\t\t\'",$m,"\',\'",$a,"\',",$s,",\n";
+				print "\t\t", perlvals($m,$a,$s), ",\n";
 			}
 			my $n = shift(@values);
 			my $d = shift(@values);
-			print "\t\t",$n,',',$d,",\n";
+			print "\t\t", perlvals($n,$d), ",\n";
 		}
 		print "\t]";
 		$pf = ', ';

--------------020309000603070007060806--
