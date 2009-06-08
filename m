Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZFHN36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZFHN36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbZFHN3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:29:51 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56815 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbZFHN3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:29:50 -0400
Date: Mon, 8 Jun 2009 14:29:50 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: [PATCH] Add a gfp-translate script to help understand page
	allocation failure reports
Message-ID: <20090608132950.GB15070@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The page allocation failure messages include a line that looks like

page allocation failure. order:1, mode:0x4020

The mode is easy to translate but irritating for the lazy and a bit error
prone. This patch adds a very simple helper script gfp-translate for the mode:
portion of the page allocation failure messages. An example usage looks like

  mel@machina:~/linux-2.6 $ scripts/gfp-translate 0x4020
  Source: /home/mel/linux-2.6
  Parsing: 0x4020
  #define __GFP_HIGH	(0x20)	/* Should access emergency pools? */
  #define __GFP_COMP	(0x4000) /* Add compound page metadata */

The script is not a work of art but it has come in handy for me a few times
so I thought I would share.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 scripts/gfp-translate |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/scripts/gfp-translate b/scripts/gfp-translate
new file mode 100755
index 0000000..724db2d
--- /dev/null
+++ b/scripts/gfp-translate
@@ -0,0 +1,81 @@
+#!/bin/bash
+# Translate the bits making up a GFP mask
+# (c) 2009, Mel Gorman <mel@csn.ul.ie>
+# Licensed under the terms of the GNU GPL License version 2
+SOURCE=
+GFPMASK=none
+
+# Helper function to report failures and exit
+die() {
+	echo ERROR: $@
+	if [ "$TMPFILE" != "" ]; then
+		rm -f $TMPFILE
+	fi
+	exit -1
+}
+
+usage() {
+	echo "usage: gfp-translate [-h] [ --source DIRECTORY ] gfpmask"
+	exit 0
+}
+
+# Parse command-line arguements
+while [ $# -gt 0 ]; do
+	case $1 in
+		--source)
+			SOURCE=$2
+			shift 2
+			;;
+		-h)
+			usage
+			;;
+		--help)
+			usage
+			;;
+		*)
+			GFPMASK=$1
+			shift
+			;;
+	esac
+done
+
+# Guess the kernel source directory if it's not set. Preference is in order of
+# o current directory
+# o /usr/src/linux
+if [ "$SOURCE" = "" ]; then
+	if [ -r "/usr/src/linux/Makefile" ]; then
+		SOURCE=/usr/src/linux
+	fi
+	if [ -r "`pwd`/Makefile" ]; then
+		SOURCE=`pwd`
+	fi
+fi
+
+# Confirm that a source directory exists
+if [ ! -r "$SOURCE/Makefile" ]; then
+	die "Could not locate source directory or it is invalid"
+fi
+
+# Confirm that a GFP mask has been specified
+if [ "$GFPMASK" = "none" ]; then
+	usage
+fi
+
+# Extract GFP flags from the kernel source
+TMPFILE=`mktemp -t gfptranslate-XXXXXX` || exit 1
+grep "^#define __GFP" $SOURCE/include/linux/gfp.h | sed -e 's/(__force gfp_t)//' | sed -e 's/u)/)/' | grep -v GFP_BITS | sed -e 's/)\//) \//' > $TMPFILE
+
+# Parse the flags
+IFS="
+"
+echo Source: $SOURCE
+echo Parsing: $GFPMASK
+for LINE in `cat $TMPFILE`; do
+	MASK=`echo $LINE | awk '{print $3}'`
+	if [ $(($GFPMASK&$MASK)) -ne 0 ]; then
+		echo $LINE
+	fi
+done
+
+rm -f $TMPFILE
+exit 0
