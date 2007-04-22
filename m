Return-Path: <linux-kernel-owner+w=401wt.eu-S965352AbXDVHkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965352AbXDVHkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 03:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965397AbXDVHkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 03:40:45 -0400
Received: from smtp110.plus.mail.mud.yahoo.com ([68.142.206.243]:41010 "HELO
	smtp110.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965352AbXDVHko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 03:40:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=4g1MIvQf1JT963B5cElLkwzKUAqIeC6dQg2bn6HPMkFCNVKGczbcTLBbgyxPnsQ67JAZBgINGCqu+5awIlcKQQ5DbfBfibU5MjDUyMhH18jqzKsJgnwbAFDCWAXfF6hQ/I4T8ISKmRsCQhYuxNJQAsRyw5dhkF+AC1ZtbHn5Og8=  ;
X-YMail-OSG: B9JBFKAVM1kZis49th_3P9dyOmDK5NaThFSsUpRa1V_dtEo9EyOoZGI5adcx5WnnfF8B32T4rQ--
Date: Sun, 22 Apr 2007 09:40:36 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCHv3] [KERNEL-DOC] kill warnings when building mandocs
Message-ID: <20070422074036.GA3934@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070413091422.GA15426@zmei.tnic> <20070413092943.GA16491@zmei.tnic> <20070418101654.7c7906c1.randy.dunlap@oracle.com> <20070419063019.GB3974@gollum.tnic> <20070419071931.GA4778@gollum.tnic> <20070421002045.36a663ba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070421002045.36a663ba.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2007 at 12:20:45AM -0700, Andrew Morton wrote:
> On Thu, 19 Apr 2007 09:19:32 +0200 Borislav Petkov <bbpetkov@yahoo.de> wrote:
>
> we already did this in the top-level Makefile.  It's in $(KERNELVERSION)
> and is printed by `make kernelversion'.
> 
> Cannot we use that info somehow?

Yes, we can. I personally like this one even better.


-----
From: Borislav Petkov <bbpetkov@yahoo.de>

This patch shuts warnings of the sort:

make -C /mnt/samsung_200/sam/kernel/trees/21-rc6/build \
        KBUILD_SRC=/mnt/samsung_200/sam/kernel/trees/21-rc6 \
        KBUILD_EXTMOD="" -f /mnt/samsung_200/sam/kernel/trees/21-rc6/Makefile mandocs
make -f /mnt/samsung_200/sam/kernel/trees/21-rc6/scripts/Makefile.build obj=scripts/basic
make -f /mnt/samsung_200/sam/kernel/trees/21-rc6/scripts/Makefile.build obj=Documentation/DocBook mandocs
  SRCTREE=/mnt/samsung_200/sam/kernel/trees/21-rc6/ /mnt/samsung_200/sam/kernel/trees/21-rc6/build/scripts/basic/docproc doc
 /mnt/samsung_200/sam/kernel/trees/21-rc6/Documentation/DocBook/wanbook.tmpl >Documentation/DocBook/wanbook.xml
  if grep -q refentry Documentation/DocBook/wanbook.xml; then xmlto man -m /mnt/samsung_200/sam/kernel/trees/21-rc6/Documentation/DocBook/stylesheet.xsl -o
 Documentation/DocBook/man Documentation/DocBook/wanbook.xml ; gzip -f Documentation/DocBook/man/*.9; fi
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

The current patch improves upon previous versions by reading the kernel version
directly from the enclosing build environment. In order to do so, the
KERNELVERSION variable is passed onto the shell from within the Makefile build
command string.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
CC: Randy Dunlap <randy.dunlap@oracle.com>

---

Index: 21-rc7/Documentation/DocBook/Makefile
===================================================================
--- 21-rc7.orig/Documentation/DocBook/Makefile
+++ 21-rc7/Documentation/DocBook/Makefile
@@ -147,7 +147,7 @@ quiet_cmd_db2html = HTML   $@
             cp $(PNG-$(basename $(notdir $@))) $(patsubst %.html,%,$@); fi

 quiet_cmd_db2man = MAN     $@
-      cmd_db2man = if grep -q refentry $<; then xmlto man $(XMLTOFLAGS) -o $(obj)/man $< ; gzip -f $(obj)/man/*.9; fi
+      cmd_db2man = if grep -q refentry $<; then KERNELVERSION=$(KERNELVERSION) xmlto man $(XMLTOFLAGS) -o $(obj)/man $< ; gzip -f $(obj)/man/*.9; fi
 %.9 : %.xml
 	@(which xmlto > /dev/null 2>&1) || \
 	 (echo "*** You need to install xmlto ***"; \
Index: 21-rc7/scripts/kernel-doc
===================================================================
--- 21-rc7.orig/scripts/kernel-doc
+++ 21-rc7/scripts/kernel-doc
@@ -326,6 +326,15 @@ while ($ARGV[0] =~ m/^-(.*)/) {
     }
 }

+# get kernel version from env
+sub get_kernel_version() {
+	my $version;
+
+	if (defined($ENV{'KERNELVERSION'})) {
+		$version = $ENV{'KERNELVERSION'};
+	}
+	return $version;
+}

 # generate a sequence of code that will splice in highlighting information
 # using the s// operator.
@@ -592,6 +601,7 @@ sub output_function_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>".$args{'function'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
+	print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>".$args{'function'}."</refname>\n";
@@ -668,6 +678,7 @@ sub output_struct_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>".$args{'type'}." ".$args{'struct'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
+	print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>".$args{'type'}." ".$args{'struct'}."</refname>\n";
@@ -752,6 +763,7 @@ sub output_enum_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>enum ".$args{'enum'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
+	print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>enum ".$args{'enum'}."</refname>\n";

-- 
Regards/Gruﬂ,
    Boris.
