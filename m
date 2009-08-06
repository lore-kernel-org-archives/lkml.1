Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZHFDnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZHFDnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 23:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZHFDnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 23:43:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52765 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbZHFDnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 23:43:46 -0400
Date: Thu, 6 Aug 2009 05:43:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Airlie <airlied@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: ftrace scripts and make V=1
Message-ID: <20090806034325.GA8861@elte.hu>
References: <21d7e9970908050023j2807ef3bi1321ac2a1fd9a743@mail.gmail.com> <20090805072952.GC19322@elte.hu> <alpine.DEB.2.00.0908052011590.5010@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908052011590.5010@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Well we tracked it down and it is powerpc64 specific.
> 
> Seems that in drivers/hwmon/lm93.c there's a function called:
> 
>    LM93_IN_FROM_REG()
> 
> But PPC64 has function descriptors and the real function names (the ones 
> you see in objdump) start with a '.'. Thus this in objdump you have:
> 
>  Disassembly of section .text:
> 
>  0000000000000000 <.LM93_IN_FROM_REG>:
>        0:       7c 08 02 a6     mflr    r0
>        4:       fb 81 ff e0     std     r28,-32(r1)
> 
> 
> The function name used is .LM93_IN_FROM_REG. But gcc considers 
> symbols that start with ".L" as a special symbol that is used 
> inside the assembly stage.
> 
> The nm passed into recordmcount uses the --synthetic option which 
> shows the ".L" symbols (my runs outside of the build did not 
> include the --synthetic option, so my older patch worked). We see 
> the function as a local.
> 
> Now to capture all the locations that use "mcount" we need to have 
> a reference to link into the object file a list of mcount callers. 
> We need a reference that will not disappear. We try to use a 
> global function and if that does not work, we use a local function 
> as a reference. But to relink the section back into the object, we 
> need to make it global. In this case, we run objcopy using 
> --globalize-symbol and --localize-symbol to convert the symbol 
> into a global symbol, link the mcount list, then convert it back 
> to a local symbol.
> 
> This works great except for this case. .L* symbols can not be 
> converted into a global symbol, and the mcount section referencing 
> it will remain unresolved.
> 
> Try this patch and see if it fixes your issue.
> 
> Thanks!
> 
> -- Steve
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index d29baa2..4889c44 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -414,7 +414,10 @@ while (<IN>) {
>  	    $offset = hex $1;
>  	} else {
>  	    # if we already have a function, and this is weak, skip it
> -	    if (!defined($ref_func) && !defined($weak{$text})) {
> +	    if (!defined($ref_func) && !defined($weak{$text}) &&
> +		 # PPC64 can have symbols that start with .L and
> +		 # gcc considers these special. Don't use them!
> +		 $text !~ /^\.L/) {
>  		$ref_func = $text;
>  		$offset = hex $1;
>  	    }

Ah, indeed. I'm wondering whether also emitting a build warning 
would be useful - just in the (admittedly unlikely) case of someone 
wondering about why LM93_IN_FROM_REG does not show up in function 
traces.

	Ingo
