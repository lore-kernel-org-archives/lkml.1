Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYJ2RAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYJ2RAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 13:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYJ2RAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 13:00:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:43551 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbYJ2RAV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 13:00:21 -0400
Date: Wed, 29 Oct 2008 10:00:45 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: rdunlap@xenotime.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scripts: improve the decodecode script
Message-ID: <20081029100045.04b208f7@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 80bf813c2bdc3538d823bb59c2611b40673e395a Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 29 Oct 2008 09:57:07 -0700
Subject: [PATCH] scripts: improve the decodecode script

kerneloops.org has been using an improved "decodecode" script,
specifically it has a special marker that shows which line
in the assembly the oops happened at, like this:

  20:	83 e0 03             	and    $0x3,%eax
  23:	09 d8                	or     %ebx,%eax
  25:	85 db                	test   %ebx,%ebx
  27:	89 02                	mov    %eax,(%edx)
  29:	74 0f                	je     0x3a
  2b:*	3b 73 04             	cmp    0x4(%ebx),%esi     <-- trapping instruction
  2e:	75 05                	jne    0x35
  30:	89 53 04             	mov    %edx,0x4(%ebx)
  33:	eb 07                	jmp    0x3c
  35:	89 53 08             	mov    %edx,0x8(%ebx)

this patch updates the kernel copy to also have this functionality.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 scripts/decodecode |   32 ++++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/scripts/decodecode b/scripts/decodecode
index 235d393..dd9bf17 100755
--- a/scripts/decodecode
+++ b/scripts/decodecode
@@ -7,7 +7,7 @@
 # AFLAGS=--32 decodecode < 386.oops
 
 cleanup() {
-	rm -f $T $T.s $T.o
+	rm -f $T $T.s $T.o $T.oo $T.aa  $T.aaa
 	exit 1
 }
 
@@ -44,21 +44,33 @@ if [ $marker -eq 0 ]; then
 	marker=`expr index "$code" "\("`
 fi
 
+touch $T.oo
 if [ $marker -ne 0 ]; then
-	beforemark=`echo "$code" | cut -c-$((${marker} - 1))`
+	echo All code >> $T.oo
+	echo ======== >> $T.oo
+	beforemark=`echo "$code"`
 	echo -n "	.byte 0x" > $T.s
-	echo $beforemark | sed -e 's/ /,0x/g' >> $T.s
-	as $AFLAGS -o $T.o $T.s
-	objdump -S $T.o
-	rm $T.o $T.s
+	echo $beforemark | sed -e 's/ /,0x/g' | sed -e 's/<//g' | sed -e 's/>//g' >> $T.s
+	as $AFLAGS -o $T.o $T.s &> /dev/null
+	objdump -S $T.o | grep -v "/tmp" | grep -v "Disassembly" | grep -v "\.text" | grep -v "^$" &> $T.ooo
+	cat $T.ooo >> $T.oo
+	rm -f $T.o $T.s  $T.ooo
 
 # and fix code at-and-after marker
 	code=`echo "$code" | cut -c$((${marker} + 1))-`
 fi
-
+echo Code starting with the faulting instruction  > $T.aa
+echo =========================================== >> $T.aa
 code=`echo $code | sed -e 's/ [<(]/ /;s/[>)] / /;s/ /,0x/g'`
 echo -n "	.byte 0x" > $T.s
 echo $code >> $T.s
-as $AFLAGS -o $T.o $T.s
-objdump -S $T.o
-rm $T $T.s $T.o
+as $AFLAGS -o $T.o $T.s &> /dev/null
+objdump -S $T.o | grep -v "Disassembly" | grep -v "/tmp" | grep -v "\.text" | grep -v "^$" &> $T.aaa
+cat $T.aaa >> $T.aa
+
+faultline=`cat $T.aaa | head -1 | cut -d":" -f2`
+
+cat $T.oo | sed -e "s/\($faultline\)/\*\1     <-- trapping instruction/g"
+echo
+cat $T.aa
+rm -f $T.o $T.s $T $T.oo $T.aa  $T.aaa[5~
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
