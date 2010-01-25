Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752Ab0AYOg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab0AYOg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734Ab0AYOg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:36:27 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:40955 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0AYOg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:36:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=rZHb43WI3CLCP6A+7iwnslh+VR+4hC6xzcRFp7sSdCiOgxkl4JTj45ovq+Nvqlvrpt
         VhxucoqpTwSA8XYyuu5W0FtZZfoczkb2nz/9X2XXmFnTJtJONkX7vUxhQfAxs0TGkdIq
         xH/gfjAITve0viAZ4s2pVP9ueXFvNgrg+DMeU=
Message-ID: <4B5DAC64.3080901@gmail.com>
Date: Mon, 25 Jan 2010 22:36:20 +0800
From: Hui Zhu <teawater@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       =?GB2312?B?Ik96YW4g77+Bf4F/Z2xheWFuIg==?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
       teawater@gmail.com
Subject: [PATCH] markup_oops.pl: add options to improve cross-sompilation
 environments
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Ozan ÔøÅÅglayan <ozan@pardus.org.tr>
Cc: Matthew Wilcox <willy@linux.intel.com>

---
 scripts/markup_oops.pl |   71 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 61 insertions(+), 10 deletions(-)

--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -15,8 +15,46 @@ use Math::BigInt;
 # 	Arjan van de Ven <arjan@linux.intel.com>


-my $vmlinux_name = $ARGV[0];
-if (!defined($vmlinux_name)) {
+my $cross_compile = "";
+my $vmlinux_name = "";
+my $modulefile = "";
+
+# Get options
+my $option = 0;
+for (my $i = 0; $i <= $#ARGV; $i++) {
+	if ($option == 0) {
+		if ($ARGV[$i] eq "-c") {
+			$option = 1;
+		}
+		elsif ($ARGV[$i] eq "-m") {
+			$option = 2;
+		}
+		elsif ($ARGV[$i] eq "-h") {
+			usage();
+			exit;
+		}
+		elsif ($i == $#ARGV) {
+			$vmlinux_name = $ARGV[$i];
+		}
+		else {
+			usage();
+			exit;
+		}
+	}
+	elsif ($option == 1) {
+		$cross_compile = $ARGV[$i];
+		$option = 0;
+	}
+	elsif ($option == 2) {
+		$modulefile = $ARGV[$i];
+		$option = 0;
+	}
+}
+
+if ($vmlinux_name ne "") {
+	$vmlinux_name = $ARGV[$#ARGV];
+}
+else {
 	my $kerver = `uname -r`;
 	chomp($kerver);
 	$vmlinux_name = "/lib/modules/$kerver/build/vmlinux";
@@ -177,26 +215,27 @@ my $decodestart = Math::BigInt->from_hex
 my $decodestop = Math::BigInt->from_hex("0x$target") + 8192;
 if ($target eq "0") {
 	print "No oops found!\n";
-	print "Usage: \n";
-	print "    dmesg | perl scripts/markup_oops.pl vmlinux\n";
+	usage();
 	exit;
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
@@ -212,7 +251,7 @@ sub InRange {
 	my ($address, $target) = @_;
 	my $ad = "0x".$address;
 	my $ta = "0x".$target;
-	my $delta = hex($ad) - hex($ta);
+	my $delta = Math::BigInt->from_hex($ad) - Math::BigInt->from_hex($ta);

 	if (($delta > -4096) && ($delta < 4096)) {
 		return 1;
@@ -225,7 +264,7 @@ sub InRange {
 # first, parse the input into the lines array, but to keep size down,
 # we only do this for 4Kb around the sweet spot

-open(FILE, "objdump -dS --adjust-vma=$vmaoffset --start-address=$decodestart --stop-address=$decodestop $filename |") || die "Cannot start objdump";
+open(FILE, $cross_compile."objdump -dS --adjust-vma=$vmaoffset --start-address=$decodestart --stop-address=$decodestop $filename |") || die "Cannot start objdump";

 while (<FILE>) {
 	my $line = $_;
@@ -344,3 +383,15 @@ while ($i < $finish) {
 	$i = $i +1;
 }

+sub usage {
+    print <<EOT;
+Usage:
+  dmesg | perl $0 [OPTION] [VMLINUX]
+
+OPTION:
+  -c CROSS_COMPILE	Specify the prefix used for toolchain.
+  -m MODULE_DIRNAME	Specify the module directory name.
+  -h			Help
+EOT
+}
+

