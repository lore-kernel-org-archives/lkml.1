Return-Path: <linux-kernel-owner+w=401wt.eu-S1750754Ab0AZH1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750754Ab0AZH1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 02:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537Ab0AZH1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 02:27:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:53695 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab0AZH1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 02:27:37 -0500
Message-ID: <4B5E9BE9.2030702@windriver.com>
Date: Tue, 26 Jan 2010 15:38:17 +0800
From: Hui Zhu <hui.zhu@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Sam Ravnborg <sam@ravnborg.org>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
CC: teawater@gmail.com
Subject: Re: [PATCH] markup_oops.pl: add options to improve cross-sompilation
 	environments
References: <4B5E5D4F.50803@windriver.com> <2375c9f91001251905p6ed99405m3915ac56e230605f@mail.gmail.com>
In-Reply-To: <2375c9f91001251905p6ed99405m3915ac56e230605f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 Jan 2010 07:27:16.0471 (UTC) FILETIME=[FC8A4070:01CA9E58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang:
> On Tue, Jan 26, 2010 at 11:11 AM, Hui Zhu <hui.zhu@windriver.com> wrote:
>> Sorry guys, the prev mail still have some format trouble.  I send a new mail
>> for it.
>> +}
>> +
>> +if ($vmlinux_name ne "") {
>> +       $vmlinux_name = $ARGV[$#ARGV];
>> +}
> 
> Why not using the Perl module 'Getopt' to do this?
> 
Hi Américo,

Thanks for remind me about it.  The following patch use Getopt.

The markup_oops.pl have 3 troubles to support cross-compiler environment:
1.  It use objdump directly.
2.  It use modinfo to get the message of module.
3.  It use hex function that cannot support 64-bit number in 32-bit arch.

This patch add 3 options to markup_oops.pl:
1. -c CROSS_COMPILE	Specify the prefix used for toolchain.
2. -m MODULE_DIRNAME	Specify the module directory name.
3. Change hex function to Math::BigInt->from_hex.

After this patch, parse the x8664 oops in x86, we can:
cat amd64m | perl ~/kernel/tmp/m.pl -c /home/teawater/kernel/bin/x8664- -m ./e.ko vmlinux

Thanks,
Hui

Signed-off-by: Hui Zhu <teawater@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: ozan@pardus.org.tr
Cc: Matthew Wilcox <willy@linux.intel.com>

---
scripts/markup_oops.pl |   45 +++++++++++++++++++++++++++++++++++----------
1 file changed, 35 insertions(+), 10 deletions(-)

--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -2,6 +2,7 @@

use File::Basename;
use Math::BigInt;
+use Getopt::Long;

# Copyright 2008, Intel Corporation
#
@@ -15,7 +16,17 @@ use Math::BigInt;
# 	Arjan van de Ven <arjan@linux.intel.com>


-my $vmlinux_name = $ARGV[0];
+my $cross_compile = "";
+my $vmlinux_name = "";
+my $modulefile = "";
+
+# Get options
+Getopt::Long::GetOptions(
+	'cross_compile|c=s'	=> \$cross_compile,
+	'modulefile|m=s'	=> \$modulefile,
+	'help|h'		=> \&usage,
+);
+my $vmlinux_name = $ARGV[$#ARGV];
if (!defined($vmlinux_name)) {
	my $kerver = `uname -r`;
	chomp($kerver);
@@ -23,6 +34,7 @@ if (!defined($vmlinux_name)) {
	print "No vmlinux specified, assuming $vmlinux_name\n";
}
my $filename = $vmlinux_name;
+
#
# Step 1: Parse the oops to find the EIP value
#
@@ -177,26 +189,26 @@ my $decodestart = Math::BigInt->from_hex
my $decodestop = Math::BigInt->from_hex("0x$target") + 8192;
if ($target eq "0") {
	print "No oops found!\n";
-	print "Usage: \n";
-	print "    dmesg | perl scripts/markup_oops.pl vmlinux\n";
-	exit;
+	usage();
}

# if it's a module, we need to find the .ko file and calculate a load offset
if ($module ne "") {
-	my $modulefile = `modinfo $module | grep '^filename:' | awk '{ print \$2 }'`;
-	chomp($modulefile);
+	if ($modulefile eq "") {
+		my $modulefile = `modinfo $module | grep '^filename:' | awk '{ print \$2 }'`;
+		chomp($modulefile);
+	}
	$filename = $modulefile;
	if ($filename eq "") {
		print "Module .ko file for $module not found. Aborting\n";
		exit;
	}
	# ok so we found the module, now we need to calculate the vma offset
-	open(FILE, "objdump -dS $filename |") || die "Cannot start objdump";
+	open(FILE, $cross_compile."objdump -dS $filename |") || die "Cannot start objdump";
	while (<FILE>) {
		if ($_ =~ /^([0-9a-f]+) \<$function\>\:/) {
			my $fu = $1;
-			$vmaoffset = hex($target) - hex($fu) - hex($func_offset);
+			$vmaoffset = Math::BigInt->from_hex("0x$target") - Math::BigInt->from_hex("0x$fu") - Math::BigInt->from_hex("0x$func_offset");
		}
	}
	close(FILE);
@@ -212,7 +224,7 @@ sub InRange {
	my ($address, $target) = @_;
	my $ad = "0x".$address;
	my $ta = "0x".$target;
-	my $delta = hex($ad) - hex($ta);
+	my $delta = Math::BigInt->from_hex($ad) - Math::BigInt->from_hex($ta);

	if (($delta > -4096) && ($delta < 4096)) {
		return 1;
@@ -225,7 +237,7 @@ sub InRange {
# first, parse the input into the lines array, but to keep size down,
# we only do this for 4Kb around the sweet spot

-open(FILE, "objdump -dS --adjust-vma=$vmaoffset --start-address=$decodestart --stop-address=$decodestop $filename |") || die "Cannot start objdump";
+open(FILE, $cross_compile."objdump -dS --adjust-vma=$vmaoffset --start-address=$decodestart --stop-address=$decodestop $filename |") || die "Cannot start objdump";

while (<FILE>) {
	my $line = $_;
@@ -344,3 +356,16 @@ while ($i < $finish) {
	$i = $i +1;
}

+sub usage {
+	print <<EOT;
+Usage:
+  dmesg | perl $0 [OPTION] [VMLINUX]
+
+OPTION:
+  -c, -cross_compile CROSS_COMPILE	Specify the prefix used for toolchain.
+  -m, -modulefile MODULE_DIRNAME	Specify the module directory name.
+  -h, -help				Help.
+EOT
+	exit;
+}
+

