Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbZIKUAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbZIKUAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 16:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756307AbZIKUAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 16:00:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53732 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbZIKUAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 16:00:31 -0400
Message-Id: <20090911200033.834879243@goodmis.org>
References: <20090911195849.451244684@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 15:58:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Dick Streefland <dick@streefland.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 05/15] kconfig: do not warn about modules built in
Content-Disposition: inline; filename=0005-kconfig-do-not-warn-about-modules-built-in.patch
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
1.6.3.3

-- 
