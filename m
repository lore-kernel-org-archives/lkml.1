Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbZHETdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbZHETdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 15:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbZHETdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 15:33:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42377 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbZHETdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 15:33:49 -0400
Date: Wed, 5 Aug 2009 15:33:48 -0400 (EDT)
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
In-Reply-To: <21d7e9970908050013m71ce7500x1d04a591de21ca30@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0908051525070.23591@gandalf.stny.rr.com>
References: <21d7e9970908050013m71ce7500x1d04a591de21ca30@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 5 Aug 2009, Dave Airlie wrote:

> On Fri, Jul 24, 2009 at 2:16 AM, Matt Fleming<matt@console-pimps.org> wrote:
> > Fix the conditional that checks if we already have a $ref_func and that
> > the new function is weak. The code as previously checking whether either
> > condition was false, and we really need to only update $ref_func is both
> > cconditions are false.
> >
> 
> This breaks the powerpc build on Fedora.
> 
> When building on ppc64 this commit causes the links of drivers/hwmon/lm93.o
> to fail.
> 
> It introduces an undefined symbol
>                  U .LM93_IN_FROM_REG
> 
> that isn't produced when this patch is reverted
> 
> This was found when the Fedora kernel failed to build when I pulled in
> -rc5-git3.
> 
> can be seen at the end of:
> http://koji.fedoraproject.org/koji/getfile?taskID=1582002&name=build.log
> 
> So can we revert this (at this stage in -rc5 or maybe fix it).
> 

I was not able to reproduce it, but could you see if this patch fixes the 
issue?

-- Steve

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index d29baa2..a6bfecb 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -402,7 +402,6 @@ while (<IN>) {
 
     # section found, now is this a start of a function?
     } elsif ($read_function && /$function_regex/) {
-	$text_found = 1;
 	$text = $2;
 
 	# if this is either a local function or a weak function
@@ -412,11 +411,13 @@ while (<IN>) {
 	    $ref_func = $text;
 	    $read_function = 0;
 	    $offset = hex $1;
+	    $text_found = 1;
 	} else {
 	    # if we already have a function, and this is weak, skip it
 	    if (!defined($ref_func) && !defined($weak{$text})) {
 		$ref_func = $text;
 		$offset = hex $1;
+		$text_found = 1;
 	    }
 	}
     } elsif ($read_headers && /$mcount_section/) {
