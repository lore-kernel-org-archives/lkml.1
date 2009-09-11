Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbZIKUCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbZIKUCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 16:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbZIKUCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 16:02:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47668 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220AbZIKUAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 16:00:32 -0400
Message-Id: <20090911200035.235119870@goodmis.org>
References: <20090911195849.451244684@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 15:58:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Dick Streefland <dick@streefland.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 10/15] kconfig: search for a config to base the local(mod|yes)config on
Content-Disposition: inline; filename=0010-kconfig-search-for-a-config-to-base-the-local-mod-ye.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Instead of using the .config in the local directory. This patch
changes streamline_config.pl to search various locations for a config.

Here's the list and order of search:

  /proc/config.gz
  /boot/vmlinuz-`uname -r`
  vmlinux  # local to the directory
  /lib/modules/`uname -r`/kernel/kernel/configs.ko
  kernel/configs.ko
  kernel/configs.o
  .config

Once it finds a file that contains a config (it checks if the binary
objects have configs first) it then uses it to create the .config
with minimum modules needed.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |   63 +++++++++++++++++++++++++++++++++-
 1 files changed, 62 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 2334641..9fa3f81 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -45,7 +45,68 @@
 my $config = ".config";
 my $linuxpath = ".";
 
-open(CIN,$config) || die "Can't open current config file: $config";
+my $uname = `uname -r`;
+chomp $uname;
+
+my @searchconfigs = (
+	{
+	    "file" => "/proc/config.gz",
+	    "exec" => "zcat",
+	},
+	{
+	    "file" => "/boot/vmlinuz-$uname",
+	    "exec" => "scripts/extract-ikconfig",
+	    "test" => "scripts/extract-ikconfig",
+	},
+	{
+	    "file" => "vmlinux",
+	    "exec" => "scripts/extract-ikconfig",
+	    "test" => "scripts/extract-ikconfig",
+	},
+	{
+	    "file" => "/lib/modules/$uname/kernel/kernel/configs.ko",
+	    "exec" => "scripts/extract-ikconfig",
+	    "test" => "scripts/extract-ikconfig",
+	},
+	{
+	    "file" => "kernel/configs.ko",
+	    "exec" => "scripts/extract-ikconfig",
+	    "test" => "scripts/extract-ikconfig",
+	},
+	{
+	    "file" => "kernel/configs.o",
+	    "exec" => "scripts/extract-ikconfig",
+	    "test" => "scripts/extract-ikconfig",
+	},
+	{
+	    "file" => ".config",
+	    "exec" => "cat",
+	},
+);
+
+sub find_config {
+    foreach my $conf (@searchconfigs) {
+	my $file = $conf->{"file"};
+
+	next if ( ! -f "$file");
+
+	if (defined($conf->{"test"})) {
+	    `$conf->{"test"} $conf->{"file"} 2>/dev/null`;
+	    next if ($?);
+	}
+
+	my $exec = $conf->{"exec"};
+
+	print STDERR "using config: '$file'\n";
+
+	open(CIN, "$exec $file |") || die "Failed to run $exec $file";
+	return;
+    }
+    die "No config file found";
+}
+
+find_config;
+
 my @makefiles = `find $linuxpath -name Makefile`;
 my %depends;
 my %selects;
-- 
1.6.3.3

-- 
