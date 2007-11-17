Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbXKQUvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbXKQUvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 15:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbXKQUv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 15:51:28 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55929 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbXKQUv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 15:51:27 -0500
Date: Sat, 17 Nov 2007 21:51:25 +0100
From: Andreas Mohr <andi@lisas.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andreas Mohr <andi@lisas.de>, Randy Dunlap <rdunlap@xenotime.net>,
       Herbert Xu <herbert@gondor.apana.org.au>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] eradicate bashisms in scripts/patch-kernel
Message-ID: <20071117205125.GA26425@rhlx01.hs-esslingen.de>
References: <20071101082457.ff9a5d67.randy.dunlap@oracle.com> <20071101221606.GA10116@rhlx01.hs-esslingen.de> <20071101160857.6e877307.rdunlap@xenotime.net> <20071102020118.GA13852@gondor.apana.org.au> <20071102200935.GA14153@rhlx01.hs-esslingen.de> <20071102131707.6023a5b7.rdunlap@xenotime.net> <20071105195827.GA24117@rhlx01.hs-esslingen.de> <20071114144627.8628f2dd.rdunlap@xenotime.net> <20071117163327.GA4296@rhlx01.hs-esslingen.de> <20071117172816.GC7213@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071117172816.GC7213@uranus.ravnborg.org>
X-Priority: none
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the patch-kernel shell script sufficiently compatible with POSIX
shells,
i.e., remove bashisms from scripts/patch-kernel.
This means that it now also works on dash 0.5.3-5
and still works on bash 3.1dfsg-8.

Full changelog:
- replaced non-standard "==" by standard "="
- replaced non-standard "source" statement by POSIX "dot" command
- use leading ./ on mktemp filename to force the tempfile to a local
  directory, so that the search path is not used
- replace bash syntax to remove leading dot by similar POSIX syntax
- added missing (optional/not required) $ signs to shell variable names

Signed-off-by: Andreas Mohr <andi@lisas.de>
---
Thanks for all comments! I might want to make sure to read more specs
next time...
Cowardly didn't dare to pre-add Randy's line, feel free to ack ;)

--- linux-2.6.23/scripts/patch-kernel.orig	2007-11-17 21:26:47.000000000 +0100
+++ linux-2.6.23/scripts/patch-kernel	2007-11-17 21:27:59.000000000 +0100
@@ -65,7 +65,7 @@
 patchdir=${2-.}
 stopvers=${3-default}
 
-if [ "$1" == -h -o "$1" == --help -o ! -r "$sourcedir/Makefile" ]; then
+if [ "$1" = -h -o "$1" = --help -o ! -r "$sourcedir/Makefile" ]; then
 cat << USAGE
 usage: $PNAME [-h] [ sourcedir [ patchdir [ stopversion ] [ -acxx ] ] ]
   source directory defaults to /usr/src/linux,
@@ -182,10 +182,12 @@
 }
 
 # set current VERSION, PATCHLEVEL, SUBLEVEL, EXTRAVERSION
-TMPFILE=`mktemp .tmpver.XXXXXX` || { echo "cannot make temp file" ; exit 1; }
+# force $TMPFILEs below to be in local directory: a slash character prevents
+# the dot command from using the search path.
+TMPFILE=`mktemp ./.tmpver.XXXXXX` || { echo "cannot make temp file" ; exit 1; }
 grep -E "^(VERSION|PATCHLEVEL|SUBLEVEL|EXTRAVERSION)" $sourcedir/Makefile > $TMPFILE
 tr -d [:blank:] < $TMPFILE > $TMPFILE.1
-source $TMPFILE.1
+. $TMPFILE.1
 rm -f $TMPFILE*
 if [ -z "$VERSION" -o -z "$PATCHLEVEL" -o -z "$SUBLEVEL" ]
 then
@@ -202,11 +204,7 @@
 EXTRAVER=
 if [ x$EXTRAVERSION != "x" ]
 then
-	if [ ${EXTRAVERSION:0:1} == "." ]; then
-		EXTRAVER=${EXTRAVERSION:1}
-	else
-		EXTRAVER=$EXTRAVERSION
-	fi
+	EXTRAVER=${EXTRAVERSION#.}
 	EXTRAVER=${EXTRAVER%%[[:punct:]]*}
 	#echo "$PNAME: changing EXTRAVERSION from $EXTRAVERSION to $EXTRAVER"
 fi
@@ -251,16 +249,16 @@
 do
     CURRENTFULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
     EXTRAVER=
-    if [ $stopvers == $CURRENTFULLVERSION ]; then
+    if [ $stopvers = $CURRENTFULLVERSION ]; then
         echo "Stopping at $CURRENTFULLVERSION base as requested."
         break
     fi
 
-    SUBLEVEL=$((SUBLEVEL + 1))
+    SUBLEVEL=$(($SUBLEVEL + 1))
     FULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
     #echo "#___ trying $FULLVERSION ___"
 
-    if [ $((SUBLEVEL)) -gt $((STOPSUBLEVEL)) ]; then
+    if [ $(($SUBLEVEL)) -gt $(($STOPSUBLEVEL)) ]; then
 	echo "Stopping since sublevel ($SUBLEVEL) is beyond stop-sublevel ($STOPSUBLEVEL)"
 	exit 1
     fi
@@ -297,7 +295,7 @@
 if [ x$gotac != x ]; then
   # Out great user wants the -ac patches
 	# They could have done -ac (get latest) or -acxx where xx=version they want
-	if [ $gotac == "-ac" ]; then
+	if [ $gotac = "-ac" ]; then
 	  # They want the latest version
 		HIGHESTPATCH=0
 		for PATCHNAMES in $patchdir/patch-${CURRENTFULLVERSION}-ac*\.*
