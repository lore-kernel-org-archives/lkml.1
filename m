Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab0BBWel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 17:34:41 -0500
Received: from mail.perches.com ([173.55.12.10]:1822 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab0BBWek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 17:34:40 -0500
Subject: [RFC PATCH V2] checkpatch.pl: Add warning on non #define 
 continuation lines
From: Joe Perches <joe@perches.com>
To: John Kacur <jkacur@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <520f0cf11002020549td6bb27fp9301d3385dc6a0e3@mail.gmail.com>
References: <cover.1264967493.git.joe@perches.com>
	 <aee58f4fc07709fe8a34021899e701824a0a6b53.1264967500.git.joe@perches.com>
	 <20100201144745.GC26011@rakim.wolfsonmicro.main>
	 <1265044080.25140.266.camel@Joe-Laptop.home>
	 <8bd0f97a1002012013t5c4a3951ra559a8965d67a672@mail.gmail.com>
	 <20100202110824.GF6566@rakim.wolfsonmicro.main>
	 <1265115344.25140.805.camel@Joe-Laptop.home>
	 <520f0cf11002020549td6bb27fp9301d3385dc6a0e3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 14:34:37 -0800
Message-ID: <1265150077.1945.137.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 14:49 +0100, John Kacur wrote:
> On Tue, Feb 2, 2010 at 1:55 PM, Joe Perches <joe@perches.com> wrote:
> > On Tue, 2010-02-02 at 11:08 +0000, Mark Brown wrote:
> >> it'd be good to also check for just regular use of
> >> continuations in code other than macro definitions.  These are just a
> >> style nit but if there's a script that filters out false positives from
> >> the macros that'd be handy...
> >
> >> Running "grep ' \\$' sound/soc/blackfin/*.[ch]" suggests that there's
> >> still some of the continuations I mentioned above in there (plus a lot
> >> of false positives from macros).
> Checkpatch is already kind of loud, so I'm not sure I like the idea -
> you even say yourself that it's just a style nit.
> But just in-case there are a lot of people who do like this, then you
> have to do some work to get rid of false positives. Try something like
> the following.
> 
> 1. apply your patch.
> 2. run something like
> find ./ -name "*.[ch]" | xargs ./scripts/checkpatch.pl -f | grep -a3
> Continuations
> 
> and then go through the results looking for false positives.

This is better.

There's probably something more appropriate that Andy Whitcroft
could work out that actually apply patches and verifies the
code using something like the ctx_statement_block functions but
that code is overly mysterious to me.

Does anyone know if Andy Whitcroft is still looking after checkpatch?

---
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3257d3d..cc5d8ee 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1234,6 +1234,7 @@ sub process {
 
 	$realcnt = 0;
 	$linenr = 0;
+	my $in_define = 0;
 	foreach my $line (@lines) {
 		$linenr++;
 
@@ -1388,6 +1389,17 @@ sub process {
 			WARN("adding a line without newline at end of file\n" . $herecurr);
 		}
 
+# check for line continuations that are not macros or defines
+		if ($rawline =~ /\\$/) {
+		    if ($rawline =~ /\s*\#\s*(define|if)/) {
+			$in_define = 1;
+		    } elsif (!$in_define) {
+			WARN("Line continuations should be avoided unless in #define or #if blocks\n" . $herecurr);
+		    }
+		} else {
+		    $in_define = 0;
+		}
+
 # Blackfin: use hi/lo macros
 		if ($realfile =~ m@arch/blackfin/.*\.S$@) {
 			if ($line =~ /\.[lL][[:space:]]*=.*&[[:space:]]*0x[fF][fF][fF][fF]/) {


