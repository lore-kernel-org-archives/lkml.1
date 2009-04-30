Return-Path: <linux-kernel-owner+w=401wt.eu-S1764900AbZD3SxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764900AbZD3SxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764369AbZD3SwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:52:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35145 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763234AbZD3SwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:52:20 -0400
Message-Id: <20090430185218.681261851@goodmis.org>
References: <20090430185022.122124349@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 30 Apr 2009 14:50:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/7] kconfig: do not warn about modules built in
Content-Disposition: inline; filename=0002-kconfig-do-not-warn-about-modules-built-in.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The streamline_config.pl finds all the configs that are needed to
compile the currently loaded modules. After it creates the .config
file, it tests to make sure all the configs that are needed were
set.

It only looks at the configs that are modules, it does not look
at the builtin configs. This causes unnecessary warnings about modules
not being covered.

[ Impact: stops false warnings about modules not configured ]

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 1774905..caac952 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -256,12 +256,14 @@ my %setconfigs;
 # Finally, read the .config file and turn off any module enabled that
 # we could not find a reason to keep enabled.
 while(<CIN>) {
-	if (/^(CONFIG.*)=m/) {
+	if (/^(CONFIG.*)=(m|y)/) {
 		if (defined($configs{$1})) {
-		    $setconfigs{$1} = 1;
+		    $setconfigs{$1} = $2;
 		    print;
-		} else {
+		} elsif ($2 eq "m") {
 		    print "# $1 is not set\n";
+		} else {
+		    print;
 		}
 	} else {
 		print;
-- 
1.6.2.1

-- 
