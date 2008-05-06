Return-Path: <linux-kernel-owner+w=401wt.eu-S1762968AbYEFFuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762968AbYEFFuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 01:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762902AbYEFFtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 01:49:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43731 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761531AbYEFFtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 01:49:14 -0400
Date: Mon, 5 May 2008 22:48:57 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>,
       Adrian Bunk <bunk@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Alexander Viro <viro@ftp.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches
 (was: Re: [2.6 patch] make sched_feat_{names,open} static)
Message-ID: <20080505224857.0aa06fc8@infradead.org>
In-Reply-To: <20080505145132.58df7e70@infradead.org>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi>
	<20080505201906.GA900@elte.hu>
	<Pine.LNX.4.64.0805051327530.27703@shark.he.net>
	<20080505145132.58df7e70@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 14:51:32 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> can we do a "make patchcheck" kernel build target that would
> * run checkpatch on teh patch
> * build the kernel without the patch (in various .configs, probably
> allyesconfig / allmodconfig is enough, but we can figure this out
> later)
> * apply the patch
> * build the kernel in the same configs
> * build a kernel for install that has the 'standard debug options' on
>   (lockdep, slabpoison etc)
> then we can
> * compare if new gcc warnings got introduced
> * compare if major stack usage got introduced
> * compare if namespace_check and some of the others introduce new
> issues
> * compare if new sparse warnings got introduced
> and maybe even run a bloat-o-meter to show code growth/shrinkage
> [insert other useful checks here]
> 
> if all of that is just one command away, I bet quite a few people
> would use it
> (and the more useful it gets the more people will use it)
> 

since people seem to be at least somewhat interested; I've started a
shell script that will do (for now, part of) the above.

It's very very premature, for one it is missing any and all error
checking, but it's a start. It's getting late here.. .maybe someone
wants to improve it before I wake up ? ;)

From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 5 May 2008 19:14:40 -0700
Subject: [PATCH] first stab at a "build with/without patch and report new non-statics and new unused exports" script

---
 dopatchtest.sh           |   63 ++++++++++++++++++++++++++++++++++++++++++++++
 scripts/export_report.pl |   20 ++++++++++++--
 scripts/namespace.pl     |   26 +++++++++++++------
 3 files changed, 98 insertions(+), 11 deletions(-)
 create mode 100644 dopatchtest.sh

diff --git a/dopatchtest.sh b/dopatchtest.sh
new file mode 100644
index 0000000..9362493
--- /dev/null
+++ b/dopatchtest.sh
@@ -0,0 +1,63 @@
+#!/bin/sh
+
+
+echo "cleaning trees"
+make mrproper
+
+rm -rf before after
+mkdir before before/allyesconfig  before/allmodconfig before/allnoconfig &> /dev/null
+mkdir after after/allyesconfig after/allmodconfig  after/allnoconfig &> /dev/null
+
+function build {
+	echo "   building $2"
+	make O=$1/$2 $2 &> $1/$2/config.log
+	make O=$1/$2 -j16 -s &> $1/$2/build.log
+	export srctree=$PWD
+	pushd $1/$2 > /dev/null
+	perl ../../scripts/namespace.pl --compact &> namespace.log
+	perl ../../scripts/export_report.pl -u &> export_report.log
+	popd > /dev/null
+	make O=$1/$2 checkstack &> $1/$2/checkstack.log
+}
+
+function check_static {
+	verbose=0
+	diff before/$1/namespace.log after/$1/namespace.log | grep -q "^>" && verbose=1
+	if [ $verbose -eq 1 ]; then
+		echo "New global symbols without users:"
+		diff before/$1/namespace.log after/$1/namespace.log | grep "^>" | cut -c2-
+	fi
+}
+
+function check_exports {
+	verbose=0
+	diff before/$1/export_report.log after/$1/export_report.log | grep -q "^>" && verbose=1
+	if [ $verbose -eq 1 ]; then
+		echo "New unused exports:"
+		diff before/$1/export_report.log after/$1/export_report.log | grep "^>" | cut -c2-
+	fi
+}
+
+
+echo "Before series"
+#build before allnoconfig
+build before allyesconfig
+build before allmodconfig
+
+echo "Applying patch"
+cat $1 | patch -p1
+
+echo "After series"
+
+#build after allnoconfig
+build after allyesconfig
+build after allmodconfig
+
+echo "Reverting patch"
+cat $1 | patch -p1  -R
+
+echo 
+echo "Running checks"
+check_static allyesconfig
+check_exports allmodconfig
+
diff --git a/scripts/export_report.pl b/scripts/export_report.pl
index 705b5ba..a2f8b8d 100644
--- a/scripts/export_report.pl
+++ b/scripts/export_report.pl
@@ -44,7 +44,8 @@ sub usage {
 	      "\t-h: print detailed help\n",
 	      "\t-k: the path to Module.symvers file. By default uses ",
 	      "the file from the current directory\n",
-	      "\t-o outputfile: output the report to outputfile\n";
+	      "\t-o outputfile: output the report to outputfile\n",
+	      "\t-u: display only unused symbols\n";
 	exit 0;
 }
 
@@ -57,7 +58,7 @@ sub collectcfiles {
 
 my (%SYMBOL, %MODULE, %opt, @allcfiles);
 
-if (not getopts('hk:o:f',\%opt) or defined $opt{'h'}) {
+if (not getopts('huk:o:f',\%opt) or defined $opt{'h'}) {
         usage($0);
 }
 
@@ -81,6 +82,11 @@ if (defined $opt{'o'}) {
 	}
 	select OUTPUT_HANDLE;
 }
+
+my $unused_only = 0;
+if (defined $opt{'u'}) {
+	$unused_only = 1;
+}
 #
 # collect all the symbols and their attributes from the
 # Module.symvers file
@@ -127,6 +133,7 @@ foreach my $thismod (@allcfiles) {
 	close(MODULE_MODULE);
 }
 
+if ($unused_only <= 0) {
 print "\tThis file reports the exported symbols usage patterns by in-tree\n",
 	"\t\t\t\tmodules\n";
 printf("%s\n\n\n","x"x80);
@@ -137,12 +144,16 @@ printf("%s\n\n\n","x"x80);
 printf("SECTION 1:\tThe exported symbols and their usage count\n\n");
 printf("%-25s\t%-25s\t%-5s\t%-25s\n", "Symbol", "Module", "Usage count",
 	"export type");
-
+}
 #
 # print the list of unused exported symbols
 #
 foreach my $list (sort alphabetically values(%SYMBOL)) {
 	my ($module, $value, $symbol, $gpl) = @{$list};
+	
+	if ($value > 0 && $unused_only > 0) {
+		exit;
+	}
 	printf("%-25s\t%-25s\t%-10s\t", $symbol, $module, $value);
 	if (defined $gpl) {
 		printf("%-25s\n",$gpl);
@@ -152,6 +163,9 @@ foreach my $list (sort alphabetically values(%SYMBOL)) {
 }
 printf("%s\n\n\n","x"x80);
 
+if ($unused_only > 0) {
+ exit;
+}
 printf("SECTION 2:\n\tThis section reports export-symbol-usage of in-kernel
 modules. Each module lists the modules, and the symbols from that module that
 it uses.  Each listed symbol reports the number of modules using it\n");
diff --git a/scripts/namespace.pl b/scripts/namespace.pl
index c6e88c6..f512d8a 100755
--- a/scripts/namespace.pl
+++ b/scripts/namespace.pl
@@ -70,12 +70,15 @@ my $nm = ($ENV{'NM'} || "nm") . " -p";
 my $objdump = ($ENV{'OBJDUMP'} || "objdump") . " -s -j .comment";
 my $srctree = "";
 my $objtree = "";
+
+my $compact = 0;
 $srctree = "$ENV{'srctree'}/" if (exists($ENV{'srctree'}));
 $objtree = "$ENV{'objtree'}/" if (exists($ENV{'objtree'}));
 
-if ($#ARGV != -1) {
-	print STDERR "usage: $0 takes no parameters\n";
-	die("giving up\n");
+if ($ARGV[0]) {
+	if ($ARGV[0] eq "--compact") {
+		$compact = 1;
+	}
 }
 
 my %nmdata = ();	# nm data for each object
@@ -192,7 +195,7 @@ sub do_nm
 		}
 		close(OBJDUMPDATA);
 		if (!defined($comment) || $comment !~ /GCC\:.*GCC\:/m) {
-			printf STDERR "No source file found for $fullname\n";
+			printf STDERR "No source file found for $fullname\n" if $compact == 0;
 		}
 		return;
 	}
@@ -288,7 +291,7 @@ sub do_nm
 			&& $fullname ne "fs/ntfs/sysctl.o"
 			&& $fullname ne "fs/jfs/jfs_debug.o"
 		) {
-			printf "No nm data for $fullname\n";
+			printf "No nm data for $fullname\n" if $compact == 0;
 		}
 		return;
 	}
@@ -317,6 +320,9 @@ sub drop_def
 sub list_multiply_defined
 {
 	my ($name, $module);
+	if ($compact == 1) {
+		return;
+	}
 	foreach $name (keys(%def)) {
 		if ($#{$def{$name}} > 0) {
 			# Special case for cond_syscall
@@ -411,6 +417,7 @@ sub resolve_external_references
 					&& $name !~ /^__mod_page_state/
 					&& $name !~ /^init_module/
 					&& $name !~ /^cleanup_module/
+					&& $compact == 0
 				) {
 					printf "Cannot resolve ";
 					printf "weak " if ($type eq "w");
@@ -437,9 +444,8 @@ sub list_extra_externals
 		}
 	}
 	if (%noref) {
-		printf "\nExternally defined symbols with no external references\n";
+		printf "\nExternally defined symbols with no external references\n" if $compact == 0;
 		foreach $module (sort(keys(%noref))) {
-			printf "  $module\n";
 			foreach (sort(@{$noref{$module}})) {
 				if (exists($export{$_})) {
 					$export = " (export only)";
@@ -447,7 +453,11 @@ sub list_extra_externals
 				else {
 					$export = "";
 				}
-				printf "    $_$export\n";
+				if ($compact>0) {
+					printf "$module	$_$export\n";
+				} else {
+					printf "	$_$export\n";
+				}
 			}
 		}
 	}
-- 
1.5.4.5

