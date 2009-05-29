Return-Path: <linux-kernel-owner+w=401wt.eu-S1761746AbZE2PF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761746AbZE2PF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760321AbZE2PFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:05:15 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:60678 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760195AbZE2PFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:05:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=unrhXlGN9Z5FZGRPKACBCwUTx+H8Xh3bQvLsdQ2xdt0Eor+d7QCdGnWV3c90hQKuh9
         zX+i3Nv9Ui5yyLlnGSQT+p2ydQqmbPZ/1ENB6sCDsrpioNA5kaC80oS+1Qj1ADwvdNQn
         VgAQGxisuibRG49Q7KCKreho24MHcCDOVdxHA=
From: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Wu Zhangjin <wuzj@lemote.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH v2 3/6] add an endian argument to scripts/recordmcount.pl
Date: Fri, 29 May 2009 23:04:50 +0800
Message-Id: <6f4f65069c0ace1f0cffd9ce152f226f09edad9b.1243604390.git.wuzj@lemote.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1243604390.git.wuzj@lemote.com>
References: <cover.1243604390.git.wuzj@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

mips architecture need this argument to handle big/little endian
differently.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 scripts/Makefile.build  |    1 +
 scripts/recordmcount.pl |   21 +++++++++++++++------
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 5c4b7a4..548d575 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -207,6 +207,7 @@ endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
 cmd_record_mcount = perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
+	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
 	"$(if $(CONFIG_64BIT),64,32)" \
 	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
 	"$(if $(part-of-module),1,0)" "$(@)";
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index a5d2ace..57a2b6a 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -100,13 +100,13 @@ $P =~ s@.*/@@g;
 
 my $V = '0.1';
 
-if ($#ARGV < 7) {
-	print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
+if ($#ARGV < 8) {
+	print "usage: $P arch endian bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
 	print "version: $V\n";
 	exit(1);
 }
 
-my ($arch, $bits, $objdump, $objcopy, $cc,
+my ($arch, $endian, $bits, $objdump, $objcopy, $cc,
     $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
 
 # This file refers to mcount and shouldn't be ftraced, so lets' ignore it
@@ -216,9 +216,18 @@ if ($arch eq "x86_64") {
 
 } elsif ($arch eq "mips") {
 	$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
-	$ld .= " -melf".$bits."btsmip";
+	$objdump .= " -Melf-trad".$endian."mips ";
 
-	$cc .= " -mno-abicalls -fno-pic ";
+	if ($endian eq "big") {
+		$endian = " -EB ";
+		$ld .= " -melf".$bits."btsmip";
+	} else {
+		$endian = " -EL ";
+		$ld .= " -melf".$bits."ltsmip";
+	}
+
+	$cc .= " -mno-abicalls -fno-pic -mabi=" . $bits . $endian;
+	$ld .= $endian;
 
     if ($bits == 64) {
 		$type = ".dword";
-- 
1.6.0.4

