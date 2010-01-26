Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580Ab0AZJDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab0AZJDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 04:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845Ab0AZJDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 04:03:07 -0500
Received: from mail.windriver.com ([147.11.1.11]:37594 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab0AZJDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 04:03:01 -0500
Message-ID: <4B5EB223.60307@windriver.com>
Date: Tue, 26 Jan 2010 17:13:07 +0800
From: Hui Zhu <hui.zhu@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Sam Ravnborg <sam@ravnborg.org>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
       teawater@gmail.com
Subject: Re: [PATCH] markup_oops.pl: add options to improve cross-sompilation
 	environments
References: <4B5E5D4F.50803@windriver.com>	 <2375c9f91001251905p6ed99405m3915ac56e230605f@mail.gmail.com>	 <4B5E9BE9.2030702@windriver.com> <2375c9f91001252353u52f437b0t7ddd643a57047e1c@mail.gmail.com>
In-Reply-To: <2375c9f91001252353u52f437b0t7ddd643a57047e1c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 Jan 2010 09:02:06.0576 (UTC) FILETIME=[3C1B5F00:01CA9E66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Américo,

Thanks for your mail.

Américo Wang:
> 
> 
> "module" should be enough to express the meaning, I think.
> 
> 
>> +       'help|h'                => \&usage,
>> +);
>> +my $vmlinux_name = $ARGV[$#ARGV];
>> if (!defined($vmlinux_name)) {
>>        my $kerver = `uname -r`;
>>        chomp($kerver);
>> @@ -23,6 +34,7 @@ if (!defined($vmlinux_name)) {
>>        print "No vmlinux specified, assuming $vmlinux_name\n";
>> }
>> my $filename = $vmlinux_name;
>> +
> 
> 
> Adding this empty line probably is not what you really want.
> 
>> #
>> # Step 1: Parse the oops to find the EIP value
>> #
> 
> {snip}
> 

About this part, the code before "Parse the oops to find the EIP value" is for "Get options".
I change this part to:
 my $filename = $vmlinux_name;
-#
-# Step 1: Parse the oops to find the EIP value
-#
+
+# Parse the oops to find the EIP value

What do you think about it?

And I changed the other part according to your mail.

Best regards,
Hui

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
 scripts/markup_oops.pl |   49 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 13 deletions(-)

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
+	'cross-compile|c=s'	=> \$cross_compile,
+	'module|m=s'	=> \$modulefile,
+	'help|h'		=> \&usage,
+);
+my $vmlinux_name = $ARGV[$#ARGV];
 if (!defined($vmlinux_name)) {
 	my $kerver = `uname -r`;
 	chomp($kerver);
@@ -23,9 +34,8 @@ if (!defined($vmlinux_name)) {
 	print "No vmlinux specified, assuming $vmlinux_name\n";
 }
 my $filename = $vmlinux_name;
-#
-# Step 1: Parse the oops to find the EIP value
-#
+
+# Parse the oops to find the EIP value
 
 my $target = "0";
 my $function;
@@ -177,26 +187,26 @@ my $decodestart = Math::BigInt->from_hex
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
@@ -212,7 +222,7 @@ sub InRange {
 	my ($address, $target) = @_;
 	my $ad = "0x".$address;
 	my $ta = "0x".$target;
-	my $delta = hex($ad) - hex($ta);
+	my $delta = Math::BigInt->from_hex($ad) - Math::BigInt->from_hex($ta);
 
 	if (($delta > -4096) && ($delta < 4096)) {
 		return 1;
@@ -225,7 +235,7 @@ sub InRange {
 # first, parse the input into the lines array, but to keep size down,
 # we only do this for 4Kb around the sweet spot
 
-open(FILE, "objdump -dS --adjust-vma=$vmaoffset --start-address=$decodestart --stop-address=$decodestop $filename |") || die "Cannot start objdump";
+open(FILE, $cross_compile."objdump -dS --adjust-vma=$vmaoffset --start-address=$decodestart --stop-address=$decodestop $filename |") || die "Cannot start objdump";
 
 while (<FILE>) {
 	my $line = $_;
@@ -344,3 +354,16 @@ while ($i < $finish) {
 	$i = $i +1;
 }
 
+sub usage {
+	print <<EOT;
+Usage:
+  dmesg | perl $0 [OPTION] [VMLINUX]
+
+OPTION:
+  -c, --cross-compile CROSS_COMPILE	Specify the prefix used for toolchain.
+  -m, --module MODULE_DIRNAME		Specify the module directory name.
+  -h, --help				Help.
+EOT
+	exit;
+}
+
