Return-Path: <linux-kernel-owner+w=401wt.eu-S1764814AbZD3Sw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764814AbZD3Sw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764271AbZD3SwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:52:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56264 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763217AbZD3SwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:52:19 -0400
Message-Id: <20090430185217.661759804@goodmis.org>
References: <20090430185022.122124349@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 30 Apr 2009 14:50:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 1/7] kconfig: streamline_config.pl do not stop with no depends
Content-Disposition: inline; filename=0001-kconfig-streamline_config.pl-do-not-stop-with-no-de.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If a config is does not have a prompt, it must be selected.
streamline_config.pl keeps track of all configs that select other configs.
If a config that does not have a prompt needs to be set to enable a
current module, it will add include all configs that select it.
Note, streamline_config.pl does not enable modules that are not already
enabled. It only keeps enabled those that were enabled and might be
needed to compile the current modules.

The code to find the selects of a config is after the code that
adds the depends. But if a config needed selects but had no dependencies,
it would not be set. Because the code would stop before getting to
the select.

[ Impact: fix to enable configs that need to be selected ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 79d8557..1774905 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -237,13 +237,11 @@ while ($repeat) {
     foreach my $config (keys %configs) {
 	$config =~ s/^CONFIG_//;
 
-	if (!defined($depends{$config})) {
-	    next;
+	if (defined($depends{$config})) {
+	    # This config has dependencies. Make sure they are also included
+	    parse_config_dep_select $depends{$config};
 	}
 
-	# This config has dependencies. Make sure they are also included
-	parse_config_dep_select $depends{$config};
-
 	if (defined($prompt{$config}) || !defined($selects{$config})) {
 	    next;
 	}
-- 
1.6.2.1

-- 
