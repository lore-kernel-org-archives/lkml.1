Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbZHFCKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbZHFCKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 22:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZHFCK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 22:10:29 -0400
Received: from mail.atheros.com ([12.36.123.2]:33633 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbZHFCK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 22:10:29 -0400
Date: Wed, 5 Aug 2009 19:10:28 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "joe@perches.com" <joe@perches.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mcgrof@gmail.com" <mcgrof@gmail.com>
Subject: Re: [PATCH 3/3] checkincludes.pl: add option to remove duplicates
 in place
Message-ID: <20090806021028.GJ4727@mosca>
References: <1249519872-23958-1-git-send-email-lrodriguez@atheros.com>
 <1249519872-23958-4-git-send-email-lrodriguez@atheros.com>
 <20090805185945.1ece6088.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090805185945.1ece6088.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 06:59:45PM -0700, Andrew Morton wrote:
> On Wed, 5 Aug 2009 17:51:12 -0700 "Luis R. Rodriguez" <lrodriguez@Atheros.com> wrote:
> 
> > checkincludes.pl is more useful if it actually removed
> > the lines. This adds support for that with -r.
> >
> 
> hm, spose so.  It can't do any harm.
> 
> Plus it's about time we edited that file - it hasn't been changed since
> we started the bk tree.

Hehe yeah.. Anno Domini

> > ---
> >  scripts/checkincludes.pl |   57 +++++++++++++++++++++++++++++++++++++++++-----
> >  1 files changed, 51 insertions(+), 6 deletions(-)
> >
> > diff --git a/scripts/checkincludes.pl b/scripts/checkincludes.pl
> > index 4bff139..5a53407 100755
> > --- a/scripts/checkincludes.pl
> > +++ b/scripts/checkincludes.pl
> > @@ -2,32 +2,77 @@
> >  #
> >  # checkincludes: Find files included more than once in (other) files.
> >  # Copyright abandoned, 2000, Niels Kristian Bech Jensen <nkbj@image.dk>.
> > +# Copyright abandoned, 2009, Luis R. Rodriguez <mcgrof@gmail.com>
> >
> >  sub usage {
> > -     print "Usage: checkincludes.pl <file list>\n";
> > +     print "Usage: checkincludes.pl [-r]\n";
> > +     print "By default we just warn of duplicates\n";
> > +     print "To remove files in place use -r\n";
> 
> I'm not sure I like the wording here - I don't _want_ my files removed!
> 
> This?
> 
> --- a/scripts/checkincludes.pl~checkincludespl-add-option-to-remove-duplicates-in-place-fix
> +++ a/scripts/checkincludes.pl
> @@ -7,7 +7,7 @@
>  sub usage {
>         print "Usage: checkincludes.pl [-r]\n";
>         print "By default we just warn of duplicates\n";
> -       print "To remove files in place use -r\n";
> +       print "To remove duplicated includes in place use -r\n";
>         exit 1;
>  }

Sure, attached new v2

From: Luis R. Rodriguez <lrodriguez@atheros.com>
Subject: [PATCH v2] checkincludes.pl: add option to remove duplicates in place

checkincludes.pl is more useful if it actually removed
the lines. This adds support for that with -r.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Now with Andrew's change in place and some sort of documentation added.

 scripts/checkincludes.pl |   66 +++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 59 insertions(+), 7 deletions(-)

diff --git a/scripts/checkincludes.pl b/scripts/checkincludes.pl
index 4bff139..676ddc0 100755
--- a/scripts/checkincludes.pl
+++ b/scripts/checkincludes.pl
@@ -1,33 +1,85 @@
 #!/usr/bin/perl
 #
-# checkincludes: Find files included more than once in (other) files.
+# checkincludes: find/remove files included more than once
+#
 # Copyright abandoned, 2000, Niels Kristian Bech Jensen <nkbj@image.dk>.
+# Copyright 2009 Luis R. Rodriguez <mcgrof@gmail.com>
+#
+# This script checks for duplicate includes. It also has support
+# to remove them in place. Note that this will not take into
+# consideration macros so you should run this only if you know
+# you do have real dups and do not have them under #ifdef's. You
+# could also just review the results.
 
 sub usage {
-	print "Usage: checkincludes.pl <file list>\n";
+	print "Usage: checkincludes.pl [-r]\n";
+	print "By default we just warn of duplicates\n";
+	print "To remove duplicated includes in place use -r\n";
 	exit 1;
 }
 
+my $remove = 0;
+
 if ($#ARGV < 0) {
-        usage();
+	usage();
+}
+
+if ($#ARGV >= 1) {
+	if ($ARGV[0] =~ /^-/) {
+		if ($ARGV[0] eq "-r") {
+			$remove = 1;
+			shift;
+		} else {
+			usage();
+		}
+	}
 }
 
 foreach $file (@ARGV) {
 	open(FILE, $file) or die "Cannot open $file: $!.\n";
 
 	my %includedfiles = ();
+	my @file_lines = ();
 
 	while (<FILE>) {
 		if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
 			++$includedfiles{$1};
 		}
+		push(@file_lines, $_);
 	}
 
 	close(FILE);
-	
-	foreach $filename (keys %includedfiles) {
-		if ($includedfiles{$filename} > 1) {
-			print "$file: $filename is included more than once.\n";
+
+	if (!$remove) {
+		foreach $filename (keys %includedfiles) {
+			if ($includedfiles{$filename} > 1) {
+				print "$file: $filename is included more than once.\n";
+			}
 		}
+		next;
 	}
+
+	open(FILE,">$file") || die("Cannot write to $file: $!");
+
+	my $dups = 0;
+	foreach (@file_lines) {
+		if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
+			foreach $filename (keys %includedfiles) {
+				if ($1 eq $filename) {
+					if ($includedfiles{$filename} > 1) {
+						$includedfiles{$filename}--;
+						$dups++;
+					} else {
+						print FILE $_;
+					}
+				}
+			}
+		} else {
+			print FILE $_;
+		}
+	}
+	if ($dups > 0) {
+		print "$file: removed $dups duplicate includes\n";
+	}
+	close(FILE);
 }
-- 
1.6.3.3

