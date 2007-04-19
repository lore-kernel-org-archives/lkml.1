Return-Path: <linux-kernel-owner+w=401wt.eu-S1766841AbXDSQSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766841AbXDSQSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766842AbXDSQSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:18:21 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58049 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766841AbXDSQSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:18:20 -0400
Date: Thu, 19 Apr 2007 09:21:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: bbpetkov@yahoo.de
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] [KERNEL-DOC] kill warnings when building mandocs
Message-Id: <20070419092122.51b59719.randy.dunlap@oracle.com>
In-Reply-To: <20070419071931.GA4778@gollum.tnic>
References: <20070413091422.GA15426@zmei.tnic>
	<20070413092943.GA16491@zmei.tnic>
	<20070418101654.7c7906c1.randy.dunlap@oracle.com>
	<20070419063019.GB3974@gollum.tnic>
	<20070419071931.GA4778@gollum.tnic>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 09:19:32 +0200 Borislav Petkov wrote:

> A fixed version of the patch shutting up missing version warnings when building
> mandocs.

http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt ::
Please include a full patch description/changelog in the future.


> +sub get_kernel_version() {
> +    my $version;
> +    open (FILE, $ENV{"SRCTREE"}."Makefile") || die "Can't open main kernel Makefile: $!";

This needs to handle the environment variable not
being there, as another location in scripts/kernel-doc does.
Updated patch below.  Is this OK with you?

-----

From: Borislav Petkov <bbpetkov@yahoo.de>

This patch shuts warnings of the sort:

make -C /mnt/samsung_200/sam/kernel/trees/21-rc6/build \
	KBUILD_SRC=/mnt/samsung_200/sam/kernel/trees/21-rc6 \
	KBUILD_EXTMOD="" -f /mnt/samsung_200/sam/kernel/trees/21-rc6/Makefile mandocs
make -f /mnt/samsung_200/sam/kernel/trees/21-rc6/scripts/Makefile.build obj=scripts/basic
make -f /mnt/samsung_200/sam/kernel/trees/21-rc6/scripts/Makefile.build obj=Documentation/DocBook mandocs
  SRCTREE=/mnt/samsung_200/sam/kernel/trees/21-rc6/ /mnt/samsung_200/sam/kernel/trees/21-rc6/build/scripts/basic/docproc doc /mnt/samsung_200/sam/kernel/trees/21-rc6/Documentation/DocBook/wanbook.tmpl >Documentation/DocBook/wanbook.xml
  if grep -q refentry Documentation/DocBook/wanbook.xml; then xmlto man -m /mnt/samsung_200/sam/kernel/trees/21-rc6/Documentation/DocBook/stylesheet.xsl -o Documentation/DocBook/man Documentation/DocBook/wanbook.xml ; gzip -f Documentation/DocBook/man/*.9; fi
Note: meta version: No productnumber or alternative     sppp_close
Note: meta version: No refmiscinfo@class=version        sppp_close
Note: Writing sppp_close.9
Note: meta version: No productnumber or alternative     sppp_open
Note: meta version: No refmiscinfo@class=version        sppp_open

by adding a RefMiscInfo xml tag in the form of the current kernel version to 
the function, struct and enum definitions in files included by kernel-doc when 
building 'mandocs'.  However, the version string appears truncated on the manpage
due to some constraints in the xml DTD for the man header, I believe, for the
troff output is truncated too.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---

 scripts/kernel-doc |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- linux-2621-rc7.orig/scripts/kernel-doc
+++ linux-2621-rc7/scripts/kernel-doc
@@ -326,6 +326,39 @@ while ($ARGV[0] =~ m/^-(.*)/) {
     }
 }
 
+# get kernel version
+sub get_kernel_version() {
+    my $version;
+    my $mkfile;
+    if (defined($ENV{'srctree'})) {
+	$mkfile = "$ENV{'srctree'}" . "/Makefile";
+    }
+    else {
+	$mkfile = "Makefile";
+    }
+    open (FILE, "$mkfile") || die "Can't open main kernel Makefile: $!";
+
+    EOF: while (my $line = <FILE>)
+    {
+	if ($line =~ /VERSION\s+=\s+(\d+)/) {
+	     $version .= $1;
+	     next;
+	}
+	if ($line =~ /PATCHLEVEL\s+=\s+(\d+)/) {
+	     $version .= ".$1";
+	     next;
+	}
+	if ($line =~ /SUBLEVEL\s+=\s+(\d+)/) {
+	     $version .= ".$1";
+	     next;
+	}
+	if ($line =~ /EXTRAVERSION\s+=\s+(.*)$/) {
+	     $version .= $1;
+	     last EOF;
+	}
+    }
+    return $version;
+}
 
 # generate a sequence of code that will splice in highlighting information
 # using the s// operator.
@@ -592,6 +625,7 @@ sub output_function_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>".$args{'function'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
+    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>".$args{'function'}."</refname>\n";
@@ -668,6 +702,7 @@ sub output_struct_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>".$args{'type'}." ".$args{'struct'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
+    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>".$args{'type'}." ".$args{'struct'}."</refname>\n";
@@ -752,6 +787,7 @@ sub output_enum_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>enum ".$args{'enum'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
+    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>enum ".$args{'enum'}."</refname>\n";
