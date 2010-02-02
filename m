Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab0BBMzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 07:55:50 -0500
Received: from mail.perches.com ([173.55.12.10]:1804 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab0BBMzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 07:55:46 -0500
Subject: [RFC PATCH] checkpatch.pl: Add warning on non #define continuation
 lines
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100202110824.GF6566@rakim.wolfsonmicro.main>
References: <cover.1264967493.git.joe@perches.com>
	 <aee58f4fc07709fe8a34021899e701824a0a6b53.1264967500.git.joe@perches.com>
	 <20100201144745.GC26011@rakim.wolfsonmicro.main>
	 <1265044080.25140.266.camel@Joe-Laptop.home>
	 <8bd0f97a1002012013t5c4a3951ra559a8965d67a672@mail.gmail.com>
	 <20100202110824.GF6566@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 04:55:44 -0800
Message-ID: <1265115344.25140.805.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 11:08 +0000, Mark Brown wrote:
> it'd be good to also check for just regular use of
> continuations in code other than macro definitions.  These are just a
> style nit but if there's a script that filters out false positives from
> the macros that'd be handy...

> Running "grep ' \\$' sound/soc/blackfin/*.[ch]" suggests that there's
> still some of the continuations I mentioned above in there (plus a lot
> of false positives from macros).

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3257d3d..a174501 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1234,6 +1234,7 @@ sub process {
 
 	$realcnt = 0;
 	$linenr = 0;
+	my $in_define = 0;
 	foreach my $line (@lines) {
 		$linenr++;
 
@@ -1388,6 +1389,16 @@ sub process {
 			WARN("adding a line without newline at end of file\n" . $herecurr);
 		}
 
+		if ($rawline =~ /\\$/) {
+		    if ($rawline =~ /\s*\#\s*define\s+/) {
+			$in_define = 1;
+		    } elsif (!$in_define) {
+			WARN("Continuations outside of macros should be avoided\n" . $herecurr);
+		    }
+		} else {
+		    $in_define = 0;
+		}
+
 # Blackfin: use hi/lo macros
 		if ($realfile =~ m@arch/blackfin/.*\.S$@) {
 			if ($line =~ /\.[lL][[:space:]]*=.*&[[:space:]]*0x[fF][fF][fF][fF]/) {


