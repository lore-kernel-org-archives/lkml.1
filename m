Return-Path: <linux-kernel-owner+w=401wt.eu-S1759795AbXJaVWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795AbXJaVWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbXJaVWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:22:21 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:36199 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbXJaVWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:22:20 -0400
X-Greylist: delayed 538 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2007 17:22:20 EDT
Date: Wed, 31 Oct 2007 22:13:21 +0100
From: Andreas Mohr <andi@lisas.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH/RFC] eradicate bashisms in scripts/patch-kernel
Message-ID: <20071031211321.GA8363@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was non-mildly horrified to find that the rather widely used patch-kernel
script seems to rely on bash despite specifying the interpreter as #!/bin/sh,
since my dash-using Debian install choked on it.

Thus I'm delivering a first, preliminary, non-reviewed change to make
patch-kernel (a little bit more?) POSIX-compatible. It now survives both
a dash and a bash run.

If this mail goes through relatively unscathed, then it might be a good
idea to plant it into -mm via a follow-up mail.

Comments?

- replaced "==" by "="
- the "source" statement most likely needs the ./ prepended, as can be
gathered from e.g. http://osdir.com/ml/colinux.devel/2005-12/msg00036.html
- the newly replaced sed expression below: is it ok? correct? strict enough?

Thanks,

Andreas Mohr

(who's strongly hoping that submitting a patch for this thingy doesn't
automatically equal becoming "maintainer for life" for it ;)

--- linux-2.6.23/scripts/patch-kernel	2007-10-31 21:55:26.000000000 +0100
+++ linux-2.6.23/scripts/patch-kernel.dash	2007-10-31 21:58:37.000000000 +0100
@@ -65,7 +65,7 @@
 patchdir=${2-.}
 stopvers=${3-default}
 
-if [ "$1" == -h -o "$1" == --help -o ! -r "$sourcedir/Makefile" ]; then
+if [ "$1" = "-h" -o "$1" = "--help" -o ! -r "$sourcedir/Makefile" ]; then
 cat << USAGE
 usage: $PNAME [-h] [ sourcedir [ patchdir [ stopversion ] [ -acxx ] ] ]
   source directory defaults to /usr/src/linux,
@@ -185,7 +185,7 @@
 TMPFILE=`mktemp .tmpver.XXXXXX` || { echo "cannot make temp file" ; exit 1; }
 grep -E "^(VERSION|PATCHLEVEL|SUBLEVEL|EXTRAVERSION)" $sourcedir/Makefile > $TMPFILE
 tr -d [:blank:] < $TMPFILE > $TMPFILE.1
-source $TMPFILE.1
+. ./$TMPFILE.1
 rm -f $TMPFILE*
 if [ -z "$VERSION" -o -z "$PATCHLEVEL" -o -z "$SUBLEVEL" ]
 then
@@ -202,13 +202,7 @@
 EXTRAVER=
 if [ x$EXTRAVERSION != "x" ]
 then
-	if [ ${EXTRAVERSION:0:1} == "." ]; then
-		EXTRAVER=${EXTRAVERSION:1}
-	else
-		EXTRAVER=$EXTRAVERSION
-	fi
-	EXTRAVER=${EXTRAVER%%[[:punct:]]*}
-	#echo "$PNAME: changing EXTRAVERSION from $EXTRAVERSION to $EXTRAVER"
+	EXTRAVER=`echo $EXTRAVERSION|sed -s 's/^[\.]\?\([^[:punct:]]*\).*/\1/'`
 fi
 
 #echo "stopvers=$stopvers"
@@ -251,16 +245,16 @@
 do
     CURRENTFULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
     EXTRAVER=
-    if [ $stopvers == $CURRENTFULLVERSION ]; then
+    if [ $stopvers = $CURRENTFULLVERSION ]; then
         echo "Stopping at $CURRENTFULLVERSION base as requested."
         break
     fi
 
-    SUBLEVEL=$((SUBLEVEL + 1))
+    SUBLEVEL=$(( $SUBLEVEL + 1 ))
     FULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
     #echo "#___ trying $FULLVERSION ___"
 
-    if [ $((SUBLEVEL)) -gt $((STOPSUBLEVEL)) ]; then
+    if [ $SUBLEVEL -gt $STOPSUBLEVEL ]; then
 	echo "Stopping since sublevel ($SUBLEVEL) is beyond stop-sublevel ($STOPSUBLEVEL)"
 	exit 1
     fi
@@ -297,7 +291,7 @@
 if [ x$gotac != x ]; then
   # Out great user wants the -ac patches
 	# They could have done -ac (get latest) or -acxx where xx=version they want
-	if [ $gotac == "-ac" ]; then
+	if [ $gotac = "-ac" ]; then
 	  # They want the latest version
 		HIGHESTPATCH=0
 		for PATCHNAMES in $patchdir/patch-${CURRENTFULLVERSION}-ac*\.*
