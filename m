Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYANXS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYANXS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 18:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYANXSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 18:18:49 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:34500 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbYANXSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 18:18:48 -0500
Date: Mon, 14 Jan 2008 15:18:31 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [PATCH] scripts: minor decodecode update
Message-Id: <20080114151831.a5ff7d7a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Remove the tmp file when exiting.  Noticed by Arjan van de Ven.
Catch mktemp failure and exit with message.
Trap kill or other signals and exit cleanly.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/decodecode |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- linux-2.6.24-rc7.orig/scripts/decodecode
+++ linux-2.6.24-rc7/scripts/decodecode
@@ -6,7 +6,19 @@
 # e.g., to decode an i386 oops on an x86_64 system, use:
 # AFLAGS=--32 decodecode < 386.oops
 
-T=`mktemp`
+cleanup() {
+	rm -f $T $T.s $T.o
+	exit 1
+}
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+trap cleanup EXIT
+
+T=`mktemp` || die "cannot create temp file"
 code=
 
 while read i ; do
@@ -20,6 +32,7 @@ esac
 done
 
 if [ -z "$code" ]; then
+	rm $T
 	exit
 fi
 
@@ -48,4 +61,4 @@ echo -n "	.byte 0x" > $T.s
 echo $code >> $T.s
 as $AFLAGS -o $T.o $T.s
 objdump -S $T.o
-rm $T.o $T.s
+rm $T $T.s $T.o
