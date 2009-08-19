Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZHSWYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZHSWYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 18:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbZHSWYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 18:24:51 -0400
Received: from cmpxchg.org ([85.214.51.133]:45278 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbZHSWYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 18:24:50 -0400
Date: Thu, 20 Aug 2009 00:23:57 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       stern@rowland.harvard.edu, akpm@linux-foundation.org, apw@canonical.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
Message-ID: <20090819222357.GA12821@cmpxchg.org>
References: <13a78aa7-dd27-49d9-8164-d6e802bd4796@default> <20090813145106.GA25333@cmpxchg.org> <1250175853.3901.34.camel@mulgrave.site> <4A843D66.1060407@xenotime.net> <20090813180856.GB26020@cmpxchg.org> <4A85ABBB.5060806@oracle.com> <20090818090419.GA3730@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818090419.GA3730@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 18, 2009 at 11:04:19AM +0200, Johannes Weiner wrote:
> Hello Randy,
> 
> On Fri, Aug 14, 2009 at 11:23:55AM -0700, Randy Dunlap wrote:
> > Johannes Weiner wrote:
> > > diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> > > index b52d340..2921aab 100755
> > > --- a/scripts/kernel-doc
> > > +++ b/scripts/kernel-doc
> > > @@ -281,6 +281,7 @@ my $doc_end = '\*/';
> > >  my $doc_com = '\s*\*\s*';
> > >  my $doc_decl = $doc_com . '(\w+)';
> > >  my $doc_sect = $doc_com . '([' . $doc_special . ']?[\w\s]+):(.*)';
> > > +my $doc_cont = $doc_com . '([^@/\s].*)';
> > >  my $doc_content = $doc_com . '(.*)';
> > >  my $doc_block = $doc_com . 'DOC:\s*(.*)?';
> > >  
> > > @@ -1995,6 +1996,7 @@ sub process_file($) {
> > >      my $identifier;
> > >      my $func;
> > >      my $descr;
> > > +    my $in_purpose = 0;
> > >      my $initial_section_counter = $section_counter;
> > >  
> > >      if (defined($ENV{'SRCTREE'})) {
> > > @@ -2044,6 +2046,7 @@ sub process_file($) {
> > >  		    $descr =~ s/\s*$//;
> > >  		    $descr =~ s/\s+/ /;
> > >  		    $declaration_purpose = xml_escape($descr);
> > > +		    $in_purpose = 1;
> > >  		} else {
> > >  		    $declaration_purpose = "";
> > >  		}
> > > @@ -2075,7 +2078,12 @@ sub process_file($) {
> > >  		++$warnings;
> > >  		$state = 0;
> > >  	    }
> > > +	} elsif ($in_purpose == 1 && /$doc_cont/o) {
> > > +	    # continued description
> > > +	    chomp($declaration_purpose);
> > > +	    $declaration_purpose .= " " . $1;
> > >  	} elsif ($state == 2) {	# look for head: lines, and include content
> > > +	    $in_purpose = 0;
> > >  	    if (/$doc_sect/o) {
> > >  		$newsection = $1;
> > >  		$newcontents = $2;
> > 
> > Hi Hannes,
> > 
> > This looks good in theory, but it doesn't survive a "make htmldocs"
> > after the patch is applied.
> > 
> > It could be the ending kernel-doc comment characters:
> >  **/
> > 
> > The problem is in drivers/scsi/scsi_devinfo.c:
> > /**
> >  * scsi_dev_info_list_delete - called from scsi.c:exit_scsi to remove the scsi_dev_info_list.
> >  **/
> > void scsi_exit_devinfo(void)
> > {
> > 
> > 
> > I'm currently on vacation, but I'll look into it more if you can't
> > do so.
> 
> Yeah, it's the terminating **/ which matches $doc_cont.  I will try to
> send an updated version this evening.

I got completely rid of the extra re.  Just parse a non-empty content
line following the declaration purpose immediately as continuation.

It survives make htmldocs, the scsi_exit_devinfo() doc looks okay and
for stuff that had continuation lines before, it does what's expected
- e.g. for the doc of kernel/sched.c::init_sd_power_savings_stats().

It behaves differently for broken docs
(mm/page_alloc.c::calculate_zone_inactive_ratio e.g.), but that
shouldn't matter.

I didn't find any other misbehaviour when checking random samples.

---
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: kernel-doc: allow multi-line declaration purpose descriptions

Allow the short description after symbol name and dash in a kernel-doc
comment to span multiple lines, e.g. like this:

	/**
	 * unmap_mapping_range - unmap the portion of all mmaps in the
	 *	specified address_space corresponding to the specified
	 *	page range in the underlying file.
	 * @mapping: the address space containing mmaps to be unmapped.
	 * ...
	 */

The short description ends with a parameter description, an empty line
or the end of the comment block.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 Documentation/kernel-doc-nano-HOWTO.txt |    4 +++-
 scripts/kernel-doc                      |   19 ++++++++++++++-----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-doc-nano-HOWTO.txt b/Documentation/kernel-doc-nano-HOWTO.txt
index 4d04572..348b9e5 100644
--- a/Documentation/kernel-doc-nano-HOWTO.txt
+++ b/Documentation/kernel-doc-nano-HOWTO.txt
@@ -66,7 +66,9 @@ Example kernel-doc function comment:
  * The longer description can have multiple paragraphs.
  */
 
-The first line, with the short description, must be on a single line.
+The short description following the subject can span multiple lines
+and ends with an @argument description, an empty line or the end of
+the comment block.
 
 The @argument descriptions must begin on the very next line following
 this opening short function description line, with no intervening
diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index b52d340..6194ef5 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1995,6 +1995,7 @@ sub process_file($) {
     my $identifier;
     my $func;
     my $descr;
+    my $in_purpose = 0;
     my $initial_section_counter = $section_counter;
 
     if (defined($ENV{'SRCTREE'})) {
@@ -2044,6 +2045,7 @@ sub process_file($) {
 		    $descr =~ s/\s*$//;
 		    $descr =~ s/\s+/ /;
 		    $declaration_purpose = xml_escape($descr);
+		    $in_purpose = 1;
 		} else {
 		    $declaration_purpose = "";
 		}
@@ -2090,6 +2092,7 @@ sub process_file($) {
 		}
 
 		$in_doc_sect = 1;
+		$in_purpose = 0;
 		$contents = $newcontents;
 		if ($contents ne "") {
 		    while ((substr($contents, 0, 1) eq " ") ||
@@ -2119,11 +2122,17 @@ sub process_file($) {
 	    } elsif (/$doc_content/) {
 		# miguel-style comment kludge, look for blank lines after
 		# @parameter line to signify start of description
-		if ($1 eq "" &&
-			($section =~ m/^@/ || $section eq $section_context)) {
-		    dump_section($file, $section, xml_escape($contents));
-		    $section = $section_default;
-		    $contents = "";
+		if ($1 eq "") {
+		    if ($section =~ m/^@/ || $section eq $section_context) {
+			dump_section($file, $section, xml_escape($contents));
+			$section = $section_default;
+			$contents = "";
+		    }
+		    $in_purpose = 0;
+		} elsif ($in_purpose == 1) {
+		    # Continued declaration purpose
+		    chomp($declaration_purpose);
+		    $declaration_purpose .= " " . $1;
 		} else {
 		    $contents .= $1 . "\n";
 		}
