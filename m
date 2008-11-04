Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbYKDT7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbYKDT7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYKDT7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:59:06 -0500
Received: from lazybastard.de ([212.112.238.170]:58243 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYKDT7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:59:03 -0500
Date: Tue, 4 Nov 2008 20:58:55 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [Patch][Checkstack] Do not hide small stackframes
Message-ID: <20081104195855.GD16036@logfs.org>
References: <49107304.2060006@parrot.com> <20081104173524.GB16036@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081104173524.GB16036@logfs.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 November 2008 18:35:24 +0100, Jörn Engel wrote:
> On Tue, 4 November 2008 17:06:28 +0100, Matthieu CASTET wrote:
> > 
> > I wonder why the arm version of checkstack only catch stack size >= 300
> > and < 10000 [1].
> > Why doesn't it use ".*sub.*sp, sp, #([0-9]{1,8})" to catch all stack usage ?
> 
> Looks like a bug.  And it further looks like Holger just copied what
> everyone else did at the time.  And the one who started this strange
> pattern was: Arnd.
> 
> Arnd, did you have a good reason for choosing the pattern?

Assuming you didn't, the patch below should print all(*) stackframes
for all architectures.

(*) Stack frames below 100 bytes are ignored, by virtue of
		next if ($size < 100);
    This is imo preferrable as it is architecture-independent and easier
    to spot.  The fact that noone noticed the 300 byte effect for five
    years (or thereabout) speaks volumes.

Jörn

-- 
You ain't got no problem, Jules. I'm on the motherfucker. Go back in
there, chill them niggers out and wait for the Wolf, who should be
coming directly.
-- Marsellus Wallace

The regex for s390 - and several other architectures that copied from
s390 - silently ignored stack frames below 300 and above 10000 bytes.

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
