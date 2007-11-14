Return-Path: <linux-kernel-owner+w=401wt.eu-S1760386AbXKNWqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386AbXKNWqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbXKNWqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:46:31 -0500
Received: from xenotime.net ([66.160.160.81]:39584 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754401AbXKNWqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:46:30 -0500
Date: Wed, 14 Nov 2007 14:46:27 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andreas Mohr <andi@lisas.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] eradicate bashisms in scripts/patch-kernel
Message-Id: <20071114144627.8628f2dd.rdunlap@xenotime.net>
In-Reply-To: <20071105195827.GA24117@rhlx01.hs-esslingen.de>
References: <20071031211321.GA8363@rhlx01.hs-esslingen.de>
	<47290096.7080207@oracle.com>
	<20071101121133.GA14807@rhlx01.hs-esslingen.de>
	<20071101082457.ff9a5d67.randy.dunlap@oracle.com>
	<20071101221606.GA10116@rhlx01.hs-esslingen.de>
	<20071101160857.6e877307.rdunlap@xenotime.net>
	<20071102020118.GA13852@gondor.apana.org.au>
	<20071102200935.GA14153@rhlx01.hs-esslingen.de>
	<20071102131707.6023a5b7.rdunlap@xenotime.net>
	<20071105195827.GA24117@rhlx01.hs-esslingen.de>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007 20:58:27 +0100 Andreas Mohr wrote:

> > Would you resend a trimmed-down patch?
> > or should I do it?
> 
> Feel free to go ahead, otherwise I'll try another patch sometime soon.
> All I care about is that the result works on (at least)
> one shell implementation _more_ than the current status ;)

Hi Andreas,

Can you comment on (or test) whether this patch is sufficient
for your needs?  And if so, is the Signed-off-by: A.M. OK?

Thanks.

---

Make the patch-kernel shell script sufficiently compatible with POSIX shells,
i.e., remove bashisms from scripts/patch-kernel.

Full changelog:
- replaced non-standard "==" by standard "="
- replaced non-standard "source" statement by POSIX "dot" command
- use leading ./ on mktemp filename to force the tempfile to a local
  directory, so that the search path is not used
- added missing (optional/not required) $ signs to shell variable names

Signed-off-by: Andreas Mohr <andi@lisas.de>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

--- linux-2.6.23/scripts/patch-kernel.orig	2007-11-01 22:51:34.000000000 +0100
+++ linux-2.6.23/scripts/patch-kernel	2007-11-01 22:10:14.000000000 +0100
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
@@ -251,16 +247,16 @@
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
@@ -297,7 +293,7 @@
 if [ x$gotac != x ]; then
   # Out great user wants the -ac patches
 	# They could have done -ac (get latest) or -acxx where xx=version they want
-	if [ $gotac == "-ac" ]; then
+	if [ $gotac = "-ac" ]; then
 	  # They want the latest version
 		HIGHESTPATCH=0
 		for PATCHNAMES in $patchdir/patch-${CURRENTFULLVERSION}-ac*\.*
-
