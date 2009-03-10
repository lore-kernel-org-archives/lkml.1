Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZCJRWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZCJRWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbZCJRWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:22:38 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:48118 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbZCJRWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:22:37 -0400
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH] checkpatch: make -f alias --file, add --help,
	more verbose help message
Date: Tue, 10 Mar 2009 18:21:23 +0100
Message-ID: <20090310172026.10948.10453.stgit@f10box.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
References: <20090112092839.GA2190@elf.ucw.cz> <496B0E5F.1020902@tremplin-utc.net> <20090116121940.GA30302@elf.ucw.cz> <20090116143404.ccf2d9ee.akpm@linux-foundation.org> <20090120103219.GK2576@elf.ucw.cz>
To: Andy Whitcroft <apw@canonical.com>
Cc: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact:
  - More verbose help/usage message.
  - Make the option -f an alias for --file.
  - On -h, --help, and --version display help message and exit(0).
  - With no FILE(s) given, exit(1) with "no input files".
  - On invalid options display help/usage and exit(1).

Based on a patch by Pavel Machek.

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Cc: Pavel Machek <pavel@suse.cz>
---

parts from the original mail:

On Tue, Jan 20, 2009 at 11:32 AM, Pavel Machek <pavel@suse.cz> wrote:
> Subject: checkpatch fun (was Re: hp accelerometer: add freefall detection)
>
> [... skip ...]
>
> I tried checkpatch-ing a file, and not only my attempts to use it
> failed, my attempts to get help failed too.
>
> pavel@amd:/data/l/linux/Documentation$ ../scripts/checkpatch.pl hwmon/hpfall.c
> ERROR: Does not appear to be a unified-diff format patch
> ....
> pavel@amd:/data/l/linux/Documentation$ ../scripts/checkpatch.pl -f hwmon/hpfall.c
> Unknown option: f
> pavel@amd:/data/l/linux/Documentation$ ../scripts/checkpatch.pl -h
> Unknown option: h
> pavel@amd:/data/l/linux/Documentation$ ../scripts/checkpatch.pl --help
> Unknown option: help
>
> [... skip ...]
>

 scripts/checkpatch.pl |   55 +++++++++++++++++++++++++++++++++++++------------
 1 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2d5ece7..1e730be 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -28,6 +28,41 @@ my $mailback = 0;
 my $summary_file = 0;
 my $root;
 my %debug;
+my $help = 0;
+
+sub help {
+	my ($exitcode) = @_;
+
+	print << "EOM";
+Usage: $P [OPTION]... [FILE]...
+Version: $V
+
+Options:
+  -q, --quiet                quiet
+  --no-tree                  run without a kernel tree
+  --no-signoff               do not check for 'Signed-off-by' line
+  --patch                    treat FILE as patchfile (default)
+  --emacs                    emacs compile window format
+  --terse                    one line per report
+  -f, --file                 treat FILE as regular source file
+  --subjective, --strict     enable more subjective tests
+  --root=PATH                PATH to the kernel tree root
+  --no-summary               suppress the per-file summary
+  --mailback                 only produce a report in case of warnings/errors
+  --summary-file             include the filename in summary
+  --debug KEY=[0|1]          turn on/off debugging of KEY, where KEY is one of
+                             'values', 'possible', 'type', and 'attr' (default
+                             is all off)
+  --test-only=WORD           report only warnings/errors containing WORD
+                             literally
+  -h, --help, --version      display this help and exit
+
+When FILE is - read standard input.
+EOM
+
+	exit($exitcode);
+}
+
 GetOptions(
 	'q|quiet+'	=> \$quiet,
 	'tree!'		=> \$tree,
@@ -35,7 +70,7 @@ GetOptions(
 	'patch!'	=> \$chk_patch,
 	'emacs!'	=> \$emacs,
 	'terse!'	=> \$terse,
-	'file!'		=> \$file,
+	'f|file!'	=> \$file,
 	'subjective!'	=> \$check,
 	'strict!'	=> \$check,
 	'root=s'	=> \$root,
@@ -45,22 +80,16 @@ GetOptions(
 
 	'debug=s'	=> \%debug,
 	'test-only=s'	=> \$tst_only,
-) or exit;
+	'h|help'	=> \$help,
+	'version'	=> \$help
+) or help(1);
+
+help(0) if ($help);
 
 my $exit = 0;
 
 if ($#ARGV < 0) {
-	print "usage: $P [options] patchfile\n";
-	print "version: $V\n";
-	print "options: -q               => quiet\n";
-	print "         --no-tree        => run without a kernel tree\n";
-	print "         --terse          => one line per report\n";
-	print "         --emacs          => emacs compile window format\n";
-	print "         --file           => check a source file\n";
-	print "         --strict         => enable more subjective tests\n";
-	print "         --root           => path to the kernel tree root\n";
-	print "         --no-summary     => suppress the per-file summary\n";
-	print "         --summary-file   => include the filename in summary\n";
+	print "$P: no input files\n";
 	exit(1);
 }
 

