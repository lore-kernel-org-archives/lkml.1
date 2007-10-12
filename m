Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbXJLT12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbXJLT12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 15:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbXJLT1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 15:27:20 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54671 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221AbXJLT1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 15:27:18 -0400
Date: Fri, 12 Oct 2007 15:26:54 -0400
From: "Mike D. Day" <ncmike@us.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, Erez Zadok <ezk@cs.sunysb.edu>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] checkpatch: Fix line number reporting
Message-ID: <20071012192654.GB18901@silverwood.ncultra.org>
Reply-To: ncmike@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
X-PGP-Key: http://www.ncultra.org/ncmike/pubkey.asc
X-PGP-Fingerprint: A2EE D0E6 21B7 0DEC 29B5  D5FD 3B27 3154 452B 7C21
x-gpg-key: http://www.ncultra.org/ncmike/pubkey.asc
x-gpg-fingerprint: A2EE D0E6 21B7 0DEC 29B5  D5FD 3B27 3154 452B 7C21
Organization: IBM Linux Technology Center
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix line number reporting when checking source files (as opposed to
patches)

Signed-off-by: Mike D. Day <ncmike@us.ibm.com>
---
checkpatch.pl-next (as of Oct. 12) reports lines incorrectly when
checking source files as opposed to checking patches.

A line number will show up twice in a normal message, 3 times when
using the --emacs option. Here is an example using the 10/12 version:

~/slp-devel/src/cmd-utils/slp_query/slp_query.c:9:
ERROR: trailing whitespace #13: FILE:
~/slp-devel/src/cmd-utils/slp_query/slp_query.c:10:

In the report above, checkpatch reports three different line numbers:
9, 13, and 10. When using the --file option, all numbers are supposed
to be the same. One of the errors is caused by initializing the prefix
too early. By moving that line from 606 to 675 there an improvement,
though still incorrect:

~/slp-devel/src/cmd-utils/slp_query/slp_query.c:10:
ERROR: trailing whitespace #13: FILE:
~/slp-devel/src/cmd-utils/slp_query/slp_query.c:10: 

To check a sourcefie, checkpatch diffs that file with /dev/null and
pipes the resulting patch into stdin. Checkpatch uses different
variables to keep track of a patch ($linenr) and the corresponding
line in the sourcefile ($realline). Since the sourcefile *is* a patch
in this case, the line number is reported incorrectly.

To fix this, checkpatch needs to alter the variable it uses for the
source line when the --file option is used, as below. 

$prefix = "$filename:$realline: " if ($emacs && $file);
$prefix = "$filename:$linenr: " if ($emacs && !$file);
 
--- checkpatch.pl-next-10-12	2007-10-12 13:39:21.000000000 -0400
+++ checkpatch.pl	2007-10-12 14:30:55.000000000 -0400
@@ -606,7 +606,6 @@
 
 		my $rawline = $line;
 
-		$prefix = "$filename:$realline: " if ($emacs);
 
 #extract the filename as it passes
 		if ($line=~/^\+\+\+\s+(\S+)/) {
@@ -665,13 +664,16 @@
 		}
 
 #make up the handle for any error we report on this line
-		$here = "#$linenr: ";
+		$here = "#$linenr: " if (!$file);
+		$here = "#$realline: " if ($file);
 		$here .= "FILE: $realfile:$realline:" if ($realcnt != 0);
 
 		my $hereline = "$here\n$line\n";
 		my $herecurr = "$here\n$line\n";
 		my $hereprev = "$here\n$prevline\n$line\n";
 
+		$prefix = "$filename:$realline: " if ($emacs && $file);
+		$prefix = "$filename:$linenr: " if ($emacs && !$file);
 		$cnt_lines++ if ($realcnt != 0);
 
 #check the patch for a signoff:

-- 
Mike D. Day
IBM LTC
Cell: 919 412-3900
Sametime: ncmike@us.ibm.com AIM: ncmikeday  Yahoo: ultra.runner
PGP key: http://www.ncultra.org/ncmike/pubkey.asc
