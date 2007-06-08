Return-Path: <linux-kernel-owner+w=401wt.eu-S1764887AbXFHG27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764887AbXFHG27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 02:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbXFHG2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 02:28:51 -0400
Received: from raven.upol.cz ([158.194.120.4]:41955 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbXFHG2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 02:28:50 -0400
To: kbuild-devel@lists.sourceforge.net
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@computergmbh.de>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch] scripts: clean-whitespace.sh
In-Reply-To: <4668929C.7040209@zytor.com>
References: <20070605073335.GM7266@flower.upol.cz> <20070605081959.GB21991@uranus.ravnborg.org> <20070605133834.GO7266@flower.upol.cz> <20070605141254.GA24722@uranus.ravnborg.org> <20070605145759.GP7266@flower.upol.cz> <20070605151101.GQ7266@flower.upol.cz> <20070606174556.GS7266@flower.upol.cz> <20070606175026.GA6303@uranus.ravnborg.org> <20070606191426.GT7266@flower.upol.cz> <Pine.LNX.4.64.0706071634470.8762@fbirervta.pbzchgretzou.qr> <20070607230657.GV7266@flower.upol.cz> <4668929C.7040209@zytor.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: jed + slrn (x86_64-pc-linux-glibc-debian)
Date: Fri, 8 Jun 2007 08:40:42 +0200
Message-Id: <E1HwY9K-0008Jz-CG@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After running this script with filename as parameter,
look (with diff) for, what can be corrected.

Only "*.diff" and "*.patch" files are handled as patches.

Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
--
 Two clean rules added, that can change look of damaged lines.
 Yet script still fits one ordinary screen, so read the code!

 test cases: include/linux/ipv6.h, arch/x86_64/lib/{copy_user, memcpy}.S

 It's like lguest -- just for fun.

 clean-whitespace.sh |   28 ++++++++++++++++++++++++++++
  1 file changed, 28 insertions(+)

--- /dev/null	2007-04-04 10:55:19.204075250 +0200
+++ linux-just-for-fun/scripts/clean-whitespace.sh	2007-06-08 07:53:21.000000000 +0200
@@ -0,0 +1,28 @@
+#!/bin/sh -e
+# clean whitespace damage; i/o = $1/$1.clean
+
+IFS='' ; t="`printf '\t'`" ; s=' ' ; s4="$s$s$s$s" ; w79=79 ;
+i="$1" ; o="$1.clean"
+strip_file_end='/^$/{N;s_^\n$_&_;T e;:n;N;s_^.*\n\n$_&_;t n;:e;};'
+not_patch_line='/^+[^+]/'
+
+case $1 in *[.]diff | *[.]patch)
+	file=patch ; sp='+[!+]' ; p='+' ; addr="$not_patch_line";;
+esac
+
+sed -n "${addr:-$strip_file_end} {
+s|[$t$s]*$||;	# trailing whitespace
+:next;		# x*8 spaces on the line start -> x*tabs
+s|^\([\n]*\)$p\($t*\)$s4$s4|\1$p\2$t|;t next;	# \n is needed after N command
+s|^\([\n]*\)$p\($t*\)$s*$t|\1$p\2$t|g;		# strip spaces between tabs
+s|$s4$s4$s$s*|$t$t|g				# more than 8 spaces -> 2 tabs
+s|$s*$t|$t|g	# strip spaces before tab; tradeoff: may break some alignment !
+};p" -- "$i" >"$o" && echo "
+please, see clean ${file:=source} file: $o
+"
+exec expand $i | while read -r line # check for long line
+do   [ ${#line} -gt $w79 ] && case "$line" in $sp*) echo \
+"at least one line wider than $w79 chars, found
+check your $file, please
+" 1>&2 ; exit ;; esac
+done
