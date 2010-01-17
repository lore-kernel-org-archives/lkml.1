Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636Ab0AQNiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0AQNiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 08:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555Ab0AQNit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 08:38:49 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:49292 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab0AQNis convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 08:38:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=pO9qkaOW7bxigYtrf59dsMeG6YqwueihwviYcMOY7rtAG+XK86ne1/eiy6I3y/weYE
         sgpYkC5dJu2SYHXpA0tE7g2ih9Jcs8k3utpg5Rb/HJaQTWkpKX0eYqWGOkJdj+sY8g6H
         tvxHGkO4YK834KeOlbVk3i8yBHrePqGByccXU=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Sun, 17 Jan 2010 21:38:28 +0800
Message-ID: <daef60381001170538o5b3b0b17l72923261b76d521@mail.gmail.com>
Subject: [PATCH] Add options to markup_oops.pl to make it support 
	cross-compiler environment better
To: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       =?ISO-8859-1?Q?Ozan_=C7aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The markup_oops.pl have 2 troubles to support cross-compiler environment:
1.  It use objdump directly.
2.  It use modinfo to get the message of module.

This patch add 2 options to markup_oops.pl:
1. -c CROSS_COMPILE	Specify the prefix used for toolchain.
2. -m MODULE_DIRNAME	Specify the module directory name.

After this patch, parse the x8664 oops in x86, we can:
cat amd64m | perl ~/kernel/tmp/m.pl -c
/home/teawater/kernel/bin/x8664- -m ./e.ko vmlinux

Thanks,
Hui

Signed-off-by: Hui Zhu <teawater@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Ozan Çaglayan <ozan@pardus.org.tr>
Cc: Matthew Wilcox <willy@linux.intel.com>

---
 scripts/markup_oops.pl |   67 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 59 insertions(+), 8 deletions(-)

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
@@ -177,22 +215,23 @@ my $decodestart = Math::BigInt->from_hex
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
+	open(FILE, $cross_compile."objdump -dS $filename |") || die "Cannot
start objdump";
 	while (<FILE>) {
 		if ($_ =~ /^([0-9a-f]+) \<$function\>\:/) {
 			my $fu = $1;
@@ -225,7 +264,7 @@ sub InRange {
 # first, parse the input into the lines array, but to keep size down,
 # we only do this for 4Kb around the sweet spot

-open(FILE, "objdump -dS --adjust-vma=$vmaoffset
--start-address=$decodestart --stop-address=$decodestop $filename |")
|| die "Cannot start objdump";
+open(FILE, $cross_compile."objdump -dS --adjust-vma=$vmaoffset
--start-address=$decodestart --stop-address=$decodestop $filename |")
|| die "Cannot start objdump";

 while (<FILE>) {
 	my $line = $_;
@@ -345,3 +384,15 @@ while ($i < $finish) {
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
