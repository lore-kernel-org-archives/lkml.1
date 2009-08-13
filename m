Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZHMOvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZHMOvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZHMOvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:51:36 -0400
Received: from cmpxchg.org ([85.214.51.133]:52571 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbZHMOvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:51:36 -0400
Date: Thu, 13 Aug 2009 16:51:06 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: stern@rowland.harvard.edu, James.Bottomley@HansenPartnership.com,
       akpm@linux-foundation.org, apw@canonical.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
Message-ID: <20090813145106.GA25333@cmpxchg.org>
References: <13a78aa7-dd27-49d9-8164-d6e802bd4796@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13a78aa7-dd27-49d9-8164-d6e802bd4796@default>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Randy,

On Thu, Aug 13, 2009 at 05:06:28AM -0700, Randy Dunlap wrote:
> From: hannes@cmpxchg.org
> 
> On Thu, Aug 13, 2009 at 09:25:14AM +0200, Ingo Molnar wrote:
> > 
> > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > On Wed, 2009-08-12 at 10:13 -0400, Alan Stern wrote:
> > > > On Wed, 12 Aug 2009, Ingo Molnar wrote:
> > > > 
> > > > > > And here I was thinking kerneldoc doesn't actually work 
> > > > > > like that, but perhaps Randy fixed it so the initial 
> > > > > > description can line-wrap?
> > > > 
> > > > Yes, that's what I thought too.  If kerneldoc has been fixed 
> > > > then the description line certainly should get wrapped.
> > > 
> > > I really don't think it needs to be fixed: it's a feature not a 
> > > bug.  It requires people writing kernel doc actually to think of 
> > > one line summaries.
> > 
> > As long as the argument is that it's good to have limitations just 
> > because it has good effects as well (which the gist of your argument 
> > seems to be), i disagree.
> > 
> > That's a very basic argument of freedom. Just consider the Gestapo 
> > which was also a 'feature' to keep criminals in check. Did you know 
> > that there were record low levels of petty criminality both in nazi 
> > Germany and during communism (and under just about any totalitarian 
> > regime)? Still nobody in their right mind is arguing that just due 
> > to that they are the right social model ...
> 
> | Although I really like how you Godwin'd kerneldoc comments ;-), we do
> | have other features that are features because of their limiting effect
> | all over the place, don't we?  The 80-columns code rule e.g. or our
> | limited set of allowed indenting characters.
> 
> > I think this DocBook limitation needs to be fixed, because there are 
> > legitimate cases where a function name got too long (for no fault of 
> > its own, but for properties of the name-space it is operating in), 
> > and we do not want a nanny state beat it into a single line.
> 
> | Agreed, just as in the other rules, one should be able to bend this
> | one once in a while without technical consequences, i.e. without
> | kerneldoc breaking.
> 
> 
> Any of you, please feel free to send patches.  Thanks.

Okay, I came up with a syntax to allow continued lines in short
descriptions and parameter descriptons.

I can successfully parse

---
/**
 *	get_tty_driver		-	find device of a tty
 *					...and everything
 *	@device: device identifier
 *		... to identify the device with
 *		... that is to be matched
 *	@index: returns the index of the tty
 *		... for your personal pleasure
 *
 *	This routine returns a tty driver structure, given a device number
 *	and also passes back the index number.
 *
 *	Locking: caller must hold tty_mutex
 */
---

to

---
Name:

get_tty_driver - find device of a tty and everything

Synopsis:

struct tty_driver * get_tty_driver (dev_t device,
                                    int * index);

Arguments:

device
        device identifier to identify the device with that is to be matched
index
        returns the index of the tty for your personal pleasure

Description:

This routine returns a tty driver structure, given a device number
and also passes back the index number.
Locking:

caller must hold tty_mutex
---

Unfortunately, perl requires me to ignore my pathetic rest of taste,
so it may well be horribly ugly without me noticing ;) Would the
following work for you?  I will happily incorporate improvements.

	Hannes

---

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index b52d340..e427b0a 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -279,6 +279,7 @@ my $doc_special = "\@\%\$\&";
 my $doc_start = '^/\*\*\s*$'; # Allow whitespace at end of comment start.
 my $doc_end = '\*/';
 my $doc_com = '\s*\*\s*';
+my $doc_cont = $doc_com . '\.\.\.\s*(.+)';
 my $doc_decl = $doc_com . '(\w+)';
 my $doc_sect = $doc_com . '([' . $doc_special . ']?[\w\s]+):(.*)';
 my $doc_content = $doc_com . '(.*)';
@@ -1995,6 +1996,7 @@ sub process_file($) {
     my $identifier;
     my $func;
     my $descr;
+    my $item;
     my $initial_section_counter = $section_counter;
 
     if (defined($ENV{'SRCTREE'})) {
@@ -2044,7 +2046,9 @@ sub process_file($) {
 		    $descr =~ s/\s*$//;
 		    $descr =~ s/\s+/ /;
 		    $declaration_purpose = xml_escape($descr);
+		    $item = \$declaration_purpose;
 		} else {
+		    $state = 2;
 		    $declaration_purpose = "";
 		}
 
@@ -2075,6 +2079,15 @@ sub process_file($) {
 		++$warnings;
 		$state = 0;
 	    }
+	} elsif (/$doc_cont/o) {
+	    # continued description
+	    if (defined($item)) {
+		chomp($$item);
+		$$item .= " " . $1;
+	    } else {
+		print STDERR "Warning(${file}:$.): Unexpected continuation\n";
+		++$warnings;
+	    }
 	} elsif ($state == 2) {	# look for head: lines, and include content
 	    if (/$doc_sect/o) {
 		$newsection = $1;
@@ -2098,6 +2111,7 @@ sub process_file($) {
 		    }
 		    $contents .= "\n";
 		}
+		$item = \$contents;
 		$section = $newsection;
 	    } elsif (/$doc_end/) {
 
@@ -2114,6 +2128,7 @@ sub process_file($) {
 
 		$prototype = "";
 		$state = 3;
+		$item = undef;
 		$brcount = 0;
 #		print STDERR "end of doc comment, looking for prototype\n";
 	    } elsif (/$doc_content/) {
@@ -2127,10 +2142,12 @@ sub process_file($) {
 		} else {
 		    $contents .= $1 . "\n";
 		}
+		$item = undef;
 	    } else {
 		# i dont know - bad line?  ignore.
 		print STDERR "Warning(${file}:$.): bad line: $_";
 		++$warnings;
+		$item = undef;
 	    }
 	} elsif ($state == 3) {	# scanning for function '{' (end of prototype)
 	    if ($decl_type eq 'function') {
