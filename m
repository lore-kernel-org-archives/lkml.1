Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbXDMJO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbXDMJO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 05:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbXDMJOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 05:14:55 -0400
Received: from smtp102.plus.mail.re2.yahoo.com ([206.190.53.27]:26830 "HELO
	smtp102.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753024AbXDMJOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 05:14:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:User-Agent;
  b=Ej4bNvOZ/s1RXTcmj8I1Fbrz+xyiFjQeaNCxzag31Naf9QA5XLG2wE1zb0NuczB3prWGSMSZL3p04auMdSdE/8ygAaXUHet1upp0DLUag3ZMwJxJ2eq6Bc6Fv2KfoHxR2OqieuwX6LPUZ86+roGucpBJ5+y5UPr3YzKOrUZW53o=  ;
X-YMail-OSG: R_4pqK0VM1mFuODGIE9sT.Kg6PqNmxBrmmEYM9NlWh8RtsVGKenBg6ZBIrqMGNwCwJPyy4IVcQ--
Date: Fri, 13 Apr 2007 11:14:22 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] [KERNEL-DOC] kill warnings when building mandocs
Message-ID: <20070413091422.GA15426@zmei.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

Index: 21-rc6/scripts/kernel-doc
===================================================================
--- 21-rc6.orig/scripts/kernel-doc
+++ 21-rc6/scripts/kernel-doc
@@ -326,6 +326,34 @@ while ($ARGV[0] =~ m/^-(.*)/) {
     }
 }
 
+# get kernel version
+sub get_kernel_version() {
+
+	my $version;
+	open (FILE, "../Makefile") || die "Can't open man kernel Makefile: $!";
+
+	EOF: while (my $line = <FILE>)
+	{
+		if ($line =~ /VERSION\s+=\s+(\d+)/) {
+			$version .= $1;
+			next;
+		}
+		if ($line =~ /PATCHLEVEL\s+=\s+(\d+)/) {
+			$version .= ".$1";
+			next;
+		}
+		if ($line =~ /SUBLEVEL\s+=\s+(\d+)/) {
+			$version .= ".$1";
+			next;
+		}
+		if ($line =~ /EXTRAVERSION\s+=\s+(.*)$/) {
+			$version .= $1;
+			last EOF;
+		}
+	}
+	return $version;
+}
+
 
 # generate a sequence of code that will splice in highlighting information
 # using the s// operator.
@@ -592,6 +620,7 @@ sub output_function_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>".$args{'function'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
+    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>".$args{'function'}."</refname>\n";
@@ -668,6 +697,7 @@ sub output_struct_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>".$args{'type'}." ".$args{'struct'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
+    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>".$args{'type'}." ".$args{'struct'}."</refname>\n";
@@ -752,6 +782,7 @@ sub output_enum_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>enum ".$args{'enum'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
+    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>enum ".$args{'enum'}."</refname>\n";
