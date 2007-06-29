Return-Path: <linux-kernel-owner+w=401wt.eu-S933511AbXF2RU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511AbXF2RU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 13:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXF2RUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 13:20:47 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:52238 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbXF2RUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 13:20:46 -0400
Date: Fri, 29 Jun 2007 10:21:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] scripts/decodecode: add AFLAGS
Message-Id: <20070629102108.c4b823bf.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add AFLAGS=options environment variable for the 'as' command.
This enables us to generate code for something other than the host
system architecture.  E.g., on an x86_64 system:

AFLAGS=--32 scripts/decodecode < i386.oops
generates code for i386 (and then objdump uses the object file's
arch. to disassemble it).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/decodecode |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- linux-2622-rc6mm1.orig/scripts/decodecode
+++ linux-2622-rc6mm1/scripts/decodecode
@@ -1,6 +1,10 @@
 #!/bin/sh
 # Disassemble the Code: line in Linux oopses
 # usage: decodecode < oops.file
+#
+# options: set env. variable AFLAGS=options to pass options to "as";
+# e.g., to decode an i386 oops on an x86_64 system, use:
+# AFLAGS=--32 decodecode < 386.oops
 
 T=`mktemp`
 code=
@@ -31,7 +35,7 @@ if [ $marker -ne 0 ]; then
 	beforemark=`echo "$code" | cut -c-$((${marker} - 1))`
 	echo -n "	.byte 0x" > $T.s
 	echo $beforemark | sed -e 's/ /,0x/g' >> $T.s
-	as -o $T.o $T.s
+	as $AFLAGS -o $T.o $T.s
 	objdump -S $T.o
 	rm $T.o $T.s
 
@@ -42,6 +46,6 @@ fi
 code=`echo $code | sed -e 's/ [<(]/ /;s/[>)] / /;s/ /,0x/g'`
 echo -n "	.byte 0x" > $T.s
 echo $code >> $T.s
-as -o $T.o $T.s
+as $AFLAGS -o $T.o $T.s
 objdump -S $T.o
 rm $T.o $T.s
