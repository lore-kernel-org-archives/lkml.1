Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbYLTOfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbYLTOfE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYLTOad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:30:33 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:56413 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbYLTOaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:30:11 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 14/26] scripts: improve the decodecode script
Date: Sat, 20 Dec 2008 15:31:25 +0100
Message-Id: <1229783497-19550-14-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081220142518.GA19390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

kerneloops.org has been using an improved "decodecode" script,
specifically it has a special marker that shows which line in the assembly
the oops happened at, like this:

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
Reviewed-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/decodecode |   32 ++++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/scripts/decodecode b/scripts/decodecode
index 235d393..4b00647 100755
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
+cleanup
-- 
1.6.0.2.GIT

