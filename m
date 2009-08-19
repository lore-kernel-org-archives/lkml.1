Return-Path: <linux-kernel-owner+w=401wt.eu-S1752218AbZHSDCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbZHSDCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZHSDCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:02:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61034 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbZHSDAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:00:38 -0400
Message-Id: <20090819030038.750665213@goodmis.org>
References: <20090819025634.987354707@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 18 Aug 2009 22:56:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 10/14] kconfig: search for a config to base the local(mod|yes)config on
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
