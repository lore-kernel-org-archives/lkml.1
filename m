Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbZIKUDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbZIKUDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 16:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbZIKUDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 16:03:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47646 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbZIKUAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 16:00:31 -0400
Message-Id: <20090911200034.125899575@goodmis.org>
References: <20090911195849.451244684@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 15:58:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Dick Streefland <dick@streefland.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 06/15] kconfig: enable CONFIG_IKCONFIG from streamline_config.pl
Content-Disposition: inline; filename=0006-kconfig-enable-CONFIG_IKCONFIG-from-streamline_confi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Ingo Molnar suggested that the streamline_config.pl should enable
CONFIG_IKCONFIG to keep the current config in the kernel.
Then we can use scripts/extract-ikconfig to find the current
modules.

This patch changes streamline_config.pl to check if CONFIG_IKCONFIG
is not set, and if it is not, it enables it to be a module.

[ Impact: make current config options easier to find ]

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |   33 +++++++++++++++++++++++----------
 1 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index caac952..2334641 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -256,18 +256,31 @@ my %setconfigs;
 # Finally, read the .config file and turn off any module enabled that
 # we could not find a reason to keep enabled.
 while(<CIN>) {
-	if (/^(CONFIG.*)=(m|y)/) {
-		if (defined($configs{$1})) {
-		    $setconfigs{$1} = $2;
-		    print;
-		} elsif ($2 eq "m") {
-		    print "# $1 is not set\n";
-		} else {
-		    print;
-		}
+
+    if (/CONFIG_IKCONFIG/) {
+	if (/# CONFIG_IKCONFIG is not set/) {
+	    # enable IKCONFIG at least as a module
+	    print "CONFIG_IKCONFIG=m\n";
+	    # don't ask about PROC
+	    print "# CONFIG_IKCONFIG is not set\n";
+	} else {
+	    print;
+	}
+	next;
+    }
+
+    if (/^(CONFIG.*)=(m|y)/) {
+	if (defined($configs{$1})) {
+	    $setconfigs{$1} = $2;
+	    print;
+	} elsif ($2 eq "m") {
+	    print "# $1 is not set\n";
 	} else {
-		print;
+	    print;
 	}
+    } else {
+	print;
+    }
 }
 close(CIN);
 
-- 
1.6.3.3

-- 
