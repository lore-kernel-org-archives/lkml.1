Return-Path: <linux-kernel-owner+w=401wt.eu-S1759467AbZDFVOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbZDFVOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759066AbZDFVMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:12:10 -0400
Received: from lazybastard.de ([212.112.238.170]:47893 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759036AbZDFVMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:12:09 -0400
Date: Mon, 6 Apr 2009 23:11:46 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthieu CASTET <matthieu.castet@parrot.com>, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, Tarmigan Casebolt <tarmigan@gmail.com>
Subject: [PATCH][Checkstack] Don't censor output
Message-ID: <20090406211146.GA10231@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For reasons that neither Arnd nor I can remember, the s390 port of
checkstack happened to ignore stack frames below 300 and above 10000
bytes.  Later on the same effect - arguably a bug - was copied into the
arm, ia64, mips and sh64 ports.

Fixing it also makes the regular expressions shorter and simpler.

Signed-off-by: Jörn Engel <joern@logfs.org>
---

 scripts/checkstack.pl |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- debuggerhead/scripts/checkstack.pl~checkstack	2008-03-05 12:14:05.000000000 +0100
+++ debuggerhead/scripts/checkstack.pl	2008-11-04 20:38:08.000000000 +0100
@@ -38,7 +38,7 @@ my (@stack, $re, $x, $xs);
 	$xs	= "[0-9a-f ]";	# hex character or space
 	if ($arch eq 'arm') {
 		#c0008ffc:	e24dd064	sub	sp, sp, #100	; 0x64
-		$re = qr/.*sub.*sp, sp, #(([0-9]{2}|[3-9])[0-9]{2})/o;
+		$re = qr/.*sub.*sp, sp, #([0-9]{1,8})/o;
 	} elsif ($arch eq 'avr32') {
 		#8000008a:       20 1d           sub sp,4
 		#80000ca8:       fa cd 05 b0     sub sp,sp,1456
@@ -51,17 +51,17 @@ my (@stack, $re, $x, $xs);
 		$re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%rsp$/o;
 	} elsif ($arch eq 'ia64') {
 		#e0000000044011fc:       01 0f fc 8c     adds r12=-384,r12
-		$re = qr/.*adds.*r12=-(([0-9]{2}|[3-9])[0-9]{2}),r12/o;
+		$re = qr/.*adds.*r12=-([0-9]{1,8}),r12/o;
 	} elsif ($arch eq 'm68k') {
 		#    2b6c:       4e56 fb70       linkw %fp,#-1168
 		#  1df770:       defc ffe4       addaw #-28,%sp
 		$re = qr/.*(?:linkw %fp,|addaw )#-([0-9]{1,4})(?:,%sp)?$/o;
 	} elsif ($arch eq 'mips64') {
 		#8800402c:       67bdfff0        daddiu  sp,sp,-16
-		$re = qr/.*daddiu.*sp,sp,-(([0-9]{2}|[3-9])[0-9]{2})/o;
+		$re = qr/.*daddiu.*sp,sp,-([0-9]{1,8})/o;
 	} elsif ($arch eq 'mips') {
 		#88003254:       27bdffe0        addiu   sp,sp,-32
-		$re = qr/.*addiu.*sp,sp,-(([0-9]{2}|[3-9])[0-9]{2})/o;
+		$re = qr/.*addiu.*sp,sp,-([0-9]{1,8})/o;
 	} elsif ($arch eq 'parisc' || $arch eq 'parisc64') {
 		$re = qr/.*ldo ($x{1,8})\(sp\),sp/o;
 	} elsif ($arch eq 'ppc') {
@@ -74,13 +74,13 @@ my (@stack, $re, $x, $xs);
 		$re = qr/.*st[dw]u.*r1,-($x{1,8})\(r1\)/o;
 	} elsif ($arch =~ /^s390x?$/) {
 		#   11160:       a7 fb ff 60             aghi   %r15,-160
-		$re = qr/.*ag?hi.*\%r15,-(([0-9]{2}|[3-9])[0-9]{2})/o;
+		$re = qr/.*ag?hi.*\%r15,-([0-9]{1,8})/o;
 	} elsif ($arch =~ /^sh64$/) {
 		#XXX: we only check for the immediate case presently,
 		#     though we will want to check for the movi/sub
 		#     pair for larger users. -- PFM.
 		#a00048e0:       d4fc40f0        addi.l  r15,-240,r15
-		$re = qr/.*addi\.l.*r15,-(([0-9]{2}|[3-9])[0-9]{2}),r15/o;
+		$re = qr/.*addi\.l.*r15,-([0-9]{1,8}),r15/o;
 	} elsif ($arch =~ /^blackfin$/) {
 		#   0:   00 e8 38 01     LINK 0x4e0;
 		$re = qr/.*[[:space:]]LINK[[:space:]]*(0x$x{1,8})/o;

