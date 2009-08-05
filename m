Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbZHEVV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbZHEVV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZHEVV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:21:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46725 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZHEVV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:21:27 -0400
Date: Wed, 5 Aug 2009 17:21:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Dave Airlie <airlied@gmail.com>
cc: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: Please revert fc4c73554c9d93b3e495f2f7acae1323b0d5db84. Re:
 [PATCH  1/2] ftrace: Fix the conditional that updates $ref_func
In-Reply-To: <alpine.DEB.2.00.0908051525070.23591@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0908051720350.23591@gandalf.stny.rr.com>
References: <21d7e9970908050013m71ce7500x1d04a591de21ca30@mail.gmail.com> <alpine.DEB.2.00.0908051525070.23591@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 5 Aug 2009, Steven Rostedt wrote:

> 
> On Wed, 5 Aug 2009, Dave Airlie wrote:
> 
> > On Fri, Jul 24, 2009 at 2:16 AM, Matt Fleming<matt@console-pimps.org> wrote:
> > > Fix the conditional that checks if we already have a $ref_func and that
> > > the new function is weak. The code as previously checking whether either
> > > condition was false, and we really need to only update $ref_func is both
> > > cconditions are false.
> > >
> > 
> > This breaks the powerpc build on Fedora.
> > 
> > When building on ppc64 this commit causes the links of drivers/hwmon/lm93.o
> > to fail.
> > 
> > It introduces an undefined symbol
> >                  U .LM93_IN_FROM_REG
> > 
> > that isn't produced when this patch is reverted
> > 
> > This was found when the Fedora kernel failed to build when I pulled in
> > -rc5-git3.
> > 
> > can be seen at the end of:
> > http://koji.fedoraproject.org/koji/getfile?taskID=1582002&name=build.log
> > 
> > So can we revert this (at this stage in -rc5 or maybe fix it).
> > 
> 
> I was not able to reproduce it, but could you see if this patch fixes the 
> issue?
> 

Forget that one. I was finally able to reproduce it. This patch fixed it 
for me:

-- Steve

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index d29baa2..98e4afb 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -135,6 +135,7 @@ $mv = "mv" if ((length $mv) == 0);
 
 my %locals;		# List of local (static) functions
 my %weak;		# List of weak functions
+my %symbols;		# List of symbols that are not local or weak
 my %convert;		# List of local functions used that needs conversion
 
 my $type;
@@ -318,6 +319,8 @@ while (<IN>) {
 	$locals{$1} = 1;
     } elsif (/^[0-9a-fA-F]+\s+([wW])\s+(\S+)/) {
 	$weak{$2} = $1;
+    } elsif (/^[0-9a-fA-F]+\s+(\S+)\s+(\S+)/) {
+	$symbols{$2} = $1;
     }
 }
 close(IN);
@@ -408,13 +411,15 @@ while (<IN>) {
 	# if this is either a local function or a weak function
 	# keep looking for functions that are global that
 	# we can use safely.
-	if (!defined($locals{$text}) && !defined($weak{$text})) {
+	if (!defined($locals{$text}) && !defined($weak{$text}) &&
+	    defined($symbols{$text})) {
 	    $ref_func = $text;
 	    $read_function = 0;
 	    $offset = hex $1;
 	} else {
 	    # if we already have a function, and this is weak, skip it
-	    if (!defined($ref_func) && !defined($weak{$text})) {
+	    if (!defined($ref_func) && defined($locals{$text}) &&
+		!defined($weak{$text})) {
 		$ref_func = $text;
 		$offset = hex $1;
 	    }
