Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbZFXLqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbZFXLqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758740AbZFXLqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:46:12 -0400
Received: from smtpq1.gn.mail.iss.as9143.net ([212.54.34.164]:50751 "EHLO
	smtpq1.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925AbZFXLqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:46:09 -0400
Date: Wed, 24 Jun 2009 13:46:07 +0200
From: Dick Streefland <dick@streefland.net>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: simplification of scripts/extract-ikconfig
Message-ID: <20090624114607.GA10817@streefland.net>
References: <20090623225245.GA10443@streefland.net> <20090624021506.GA5871@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624021506.GA5871@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-ZiggoSMTP-MailScanner-Information: Please contact the ISP for more information
X-ZiggoSMTP-MailScanner-ID: 1MJQvY-00062n-O4
X-ZiggoSMTP-MailScanner: Found to be clean
X-ZiggoSMTP-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-4.091, required 5, ALL_TRUSTED -1.80, BAYES_00 -2.60,
	TW_IK 0.08, TW_NM 0.08, TW_PN 0.08, TW_RG 0.08)
X-ZiggoSMTP-MailScanner-From: dick@streefland.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 2009-06-24 10:15, Amerigo Wang wrote:
| On Wed, Jun 24, 2009 at 12:52:45AM +0200, Dick Streefland wrote:
| >+	if	pos=`grep -abo "$ikconfig_header" "$1"`
| 
| Are you sure this 'grep' works well?
| 
| My tests on a binary file told me no.

The version of grep on the machines I tested on (GNU grep 2.5.3) does
work, but I now see that this combination of options doesn't work on
older versions like 2.5.1. Bummer!

| >+tmp=/tmp/ikconfig$$
| >+trap "rm -f $tmp" 0
| 
| Why do you use trap instead of doing this explicitly
| on exit?

Because it is simpler when you have multiple exit points, and also
to make sure the file is removed when the script is terminated
prematurely, for instance by a signal.

| Can we have more than one $gzip_header? But even if yes,
| grep only reports the first one I am afraid, or at least,
| the first one in one "line".

With grep 2.5.3, you will find every occurrence of the pattern, not
just a single one per "line".

Because I don't want to rely on a particular version of grep, I've
modified the script to use perl instead. I hope that's OK. Below is
a new patch.

======================================================================

I've rewritten the extract-ikconfig script to extract the kernel
configuration from a kernel compiled with CONFIG_IKCONFIG. The main
motivation for the rewrite was to remove the dependency on the
external C program binoffset.c, which is compiled on the initial run.

The binoffset executable is invoked with a relative path, which means
that the old script can only be run from the top of the kernel tree,
and only when you have write permission in the scripts directory.
The new script uses perl/tail/zcat only, and can be invoked from
anywhere. The binoffset.c program has been removed.

Signed-off-by: Dick Streefland <dick@streefland.net>
---

 Documentation/dontdiff   |    1 -
 scripts/.gitignore       |    1 -
 scripts/binoffset.c      |  163 ----------------------------------------------
 scripts/extract-ikconfig |  112 ++++++++++++-------------------
 4 files changed, 43 insertions(+), 234 deletions(-)

diff --git a/Documentation/dontdiff b/Documentation/dontdiff
index 88519da..6fef118 100644
--- a/Documentation/dontdiff
+++ b/Documentation/dontdiff
@@ -68,7 +68,6 @@ autoconf.h*
 bbootsect
 bin2c
 binkernel.spec
-binoffset
 bootsect
 bounds.h
 bsetup
diff --git a/scripts/.gitignore b/scripts/.gitignore
index b939fbd..a1f52cb 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -6,4 +6,3 @@ kallsyms
 pnmtologo
 bin2c
 unifdef
-binoffset
diff --git a/scripts/binoffset.c b/scripts/binoffset.c
deleted file mode 100644
index 1a2e39b..0000000
--- a/scripts/binoffset.c
+++ /dev/null
@@ -1,163 +0,0 @@
-/***************************************************************************
- * binoffset.c
- * (C) 2002 Randy Dunlap <rdunlap@xenotime.net>
-
-#   This program is free software; you can redistribute it and/or modify
-#   it under the terms of the GNU General Public License as published by
-#   the Free Software Foundation; either version 2 of the License, or
-#   (at your option) any later version.
-#
-#   This program is distributed in the hope that it will be useful,
-#   but WITHOUT ANY WARRANTY; without even the implied warranty of
-#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-#   GNU General Public License for more details.
-#
-#   You should have received a copy of the GNU General Public License
-#   along with this program; if not, write to the Free Software
-#   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-
-# binoffset.c:
-# - searches a (binary) file for a specified (binary) pattern
-# - returns the offset of the located pattern or ~0 if not found
-# - exits with exit status 0 normally or non-0 if pattern is not found
-#   or any other error occurs.
-
-****************************************************************/
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <errno.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/mman.h>
-
-#define VERSION		"0.1"
-#define BUF_SIZE	(16 * 1024)
-#define PAT_SIZE	100
-
-char		*progname;
-char		*inputname;
-int		inputfd;
-unsigned int	bix;			/* buf index */
-unsigned char	patterns [PAT_SIZE] = {0}; /* byte-sized pattern array */
-int		pat_len;		/* actual number of pattern bytes */
-unsigned char	*madr;			/* mmap address */
-size_t		filesize;
-int		num_matches = 0;
-off_t		firstloc = 0;
-
-void usage (void)
-{
-	fprintf (stderr, "%s ver. %s\n", progname, VERSION);
-	fprintf (stderr, "usage:  %s filename pattern_bytes\n",
-			progname);
-	fprintf (stderr, "        [prints location of pattern_bytes in file]\n");
-	exit (1);
-}
-
-void get_pattern (int pat_count, char *pats [])
-{
-	int ix, err, tmp;
-
-#ifdef DEBUG
-	fprintf (stderr,"get_pattern: count = %d\n", pat_count);
-	for (ix = 0; ix < pat_count; ix++)
-		fprintf (stderr, "  pat # %d:  [%s]\n", ix, pats[ix]);
-#endif
-
-	for (ix = 0; ix < pat_count; ix++) {
-		tmp = 0;
-		err = sscanf (pats[ix], "%5i", &tmp);
-		if (err != 1 || tmp > 0xff) {
-			fprintf (stderr, "pattern or value error in pattern # %d [%s]\n",
-					ix, pats[ix]);
-			usage ();
-		}
-		patterns [ix] = tmp;
-	}
-	pat_len = pat_count;
-}
-
-void search_pattern (void)
-{
-	for (bix = 0; bix < filesize; bix++) {
-		if (madr[bix] == patterns[0]) {
-			if (memcmp (&madr[bix], patterns, pat_len) == 0) {
-				if (num_matches == 0)
-					firstloc = bix;
-				num_matches++;
-			}
-		}
-	}
-}
-
-#ifdef NOTDEF
-size_t get_filesize (int fd)
-{
-	off_t end_off = lseek (fd, 0, SEEK_END);
-	lseek (fd, 0, SEEK_SET);
-	return (size_t) end_off;
-}
-#endif
-
-size_t get_filesize (int fd)
-{
-	int err;
-	struct stat stat;
-
-	err = fstat (fd, &stat);
-	fprintf (stderr, "filesize: %ld\n", err < 0 ? (long)err : stat.st_size);
-	if (err < 0)
-		return err;
-	return (size_t) stat.st_size;
-}
-
-int main (int argc, char *argv [])
-{
-	progname = argv[0];
-
-	if (argc < 3)
-		usage ();
-
-	get_pattern (argc - 2, argv + 2);
-
-	inputname = argv[1];
-
-	inputfd = open (inputname, O_RDONLY);
-	if (inputfd == -1) {
-		fprintf (stderr, "%s: cannot open '%s'\n",
-				progname, inputname);
-		exit (3);
-	}
-
-	filesize = get_filesize (inputfd);
-
-	madr = mmap (0, filesize, PROT_READ, MAP_PRIVATE, inputfd, 0);
-	if (madr == MAP_FAILED) {
-		fprintf (stderr, "mmap error = %d\n", errno);
-		close (inputfd);
-		exit (4);
-	}
-
-	search_pattern ();
-
-	if (munmap (madr, filesize))
-		fprintf (stderr, "munmap error = %d\n", errno);
-
-	if (close (inputfd))
-		fprintf (stderr, "%s: error %d closing '%s'\n",
-				progname, errno, inputname);
-
-	fprintf (stderr, "number of pattern matches = %d\n", num_matches);
-	if (num_matches == 0)
-		firstloc = ~0;
-	printf ("%ld\n", firstloc);
-	fprintf (stderr, "%ld\n", firstloc);
-
-	exit (num_matches ? 0 : 2);
-}
-
-/* end binoffset.c */
diff --git a/scripts/extract-ikconfig b/scripts/extract-ikconfig
index 72997c3..bbbacb2 100755
--- a/scripts/extract-ikconfig
+++ b/scripts/extract-ikconfig
@@ -1,78 +1,52 @@
 #!/bin/sh
-# extracts .config info from a [b]zImage file
-# uses: binoffset (new), dd, zcat, strings, grep
-# $arg1 is [b]zImage filename
-
-binoffset="./scripts/binoffset"
-test -e $binoffset || cc -o $binoffset ./scripts/binoffset.c || exit 1
-
-IKCFG_ST="0x49 0x4b 0x43 0x46 0x47 0x5f 0x53 0x54"
-IKCFG_ED="0x49 0x4b 0x43 0x46 0x47 0x5f 0x45 0x44"
-dump_config() {
-    file="$1"
-
-    start=`$binoffset $file $IKCFG_ST 2>/dev/null`
-    [ "$?" != "0" ] && start="-1"
-    if [ "$start" -eq "-1" ]; then
-	return
-    fi
-    end=`$binoffset $file $IKCFG_ED 2>/dev/null`
-
-    start=`expr $start + 8`
-    size=`expr $end - $start`
-
-    dd if="$file" ibs=1 skip="$start" count="$size" 2>/dev/null | zcat
-
-    clean_up
-    exit 0
-}
-
-
-usage()
+# ----------------------------------------------------------------------
+# extract-ikconfig - Extract the .config file from a kernel image
+#
+# This will only work when the kernel was compiled with CONFIG_IKCONFIG.
+#
+# (c) 2009, Dick Streefland <dick@streefland.net>
+# Licensed under the terms of the GNU General Public License.
+# ----------------------------------------------------------------------
+
+gzip_header='\x1f\x8b\x08'
+ikconfig_header="IKCFG_ST$gzip_header"
+
+dump_config()
 {
-	echo "  usage: extract-ikconfig [b]zImage_filename"
-}
-
-clean_up()
-{
-	if [ "$TMPFILE" != "" ]; then
-		rm -f $TMPFILE
+	pos=`perl -e 'undef $/; print index <>,"'$ikconfig_header'";' "$1"`
+	if	[ "$pos" != -1 ]
+	then
+		tail -c+$(($pos+8+1)) "$1" | zcat -q
+		exit 0
 	fi
 }
 
-if [ $# -lt 1 ]
+# Check invocation:
+me=${0##*/}
+img=$1
+if	[ $# -ne 1 -o ! -s "$img" ]
 then
-	usage
-	exit 1
+	echo "Usage: $me <kernel-image>" >&2
+	exit 2
 fi
 
-TMPFILE=`mktemp -t ikconfig-XXXXXX` || exit 1
-image="$1"
-
-# vmlinux: Attempt to dump the configuration from the file directly
-dump_config "$image"
-
-GZHDR1="0x1f 0x8b 0x08 0x00"
-GZHDR2="0x1f 0x8b 0x08 0x08"
-
-# vmlinux.gz: Check for a compressed images
-off=`$binoffset "$image" $GZHDR1 2>/dev/null`
-[ "$?" != "0" ] && off="-1"
-if [ "$off" -eq "-1" ]; then
-	off=`$binoffset "$image" $GZHDR2 2>/dev/null`
-	[ "$?" != "0" ] && off="-1"
-fi
-if [ "$off" -eq "0" ]; then
-	zcat <"$image" >"$TMPFILE"
-	dump_config "$TMPFILE"
-elif [ "$off" -ne "-1" ]; then
-	(dd ibs="$off" skip=1 count=0 && dd bs=512k) <"$image" 2>/dev/null | \
-		zcat >"$TMPFILE"
-	dump_config "$TMPFILE"
-fi
-
-echo "ERROR: Unable to extract kernel configuration information."
-echo "       This kernel image may not have the config info."
-
-clean_up
+# Initial attempt for uncompressed images or objects:
+dump_config "$img"
+
+# That didn't work, so decompress and try again:
+tmp=/tmp/ikconfig$$
+trap "rm -f $tmp" 0
+script='
+	undef $/;
+	$img = <>;
+	print $i."\n" while ($i = index($img, "'$gzip_header'", $i) + 1);
+'
+for	pos in `perl -e "$script" "$img"`
+do
+	tail -c+$pos "$img" | zcat 2> /dev/null > $tmp
+	dump_config $tmp
+done
+
+# Bail out:
+echo "$me: Cannot find kernel config." >&2
 exit 1
