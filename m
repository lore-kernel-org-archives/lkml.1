Return-Path: <linux-kernel-owner+w=401wt.eu-S968597AbYD1XNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968597AbYD1XNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968127AbYD1XGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:06:15 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4308 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968121AbYD1XGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:06:13 -0400
Date: Tue, 29 Apr 2008 00:06:37 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Rogan Dawes <lists@dawes.za.net>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: +patch Why these dot chars in scripts/checkpatch.pl?
Message-ID: <20080428230637.GX5401@shadowen.org>
References: <20080428153122.a94d21ba.pj@sgi.com> <481637D7.8090000@dawes.za.net> <alpine.LNX.1.10.0804282351120.21466@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0804282351120.21466@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 12:10:03AM +0200, Jan Engelhardt wrote:
> 
> On Monday 2008-04-28 22:47, Rogan Dawes wrote:
> > Paul Jackson wrote:
> >> Andy,
> >> 
> >> Perhaps I'm loosing my magic regex pixie dust, but the dot '.' char
> >> in the pattern "/^.#" in the following lines looks wrong to me, as if
> >> one were trying to match pre-processor directives that were set in by
> >> one character:
> >
> > Perhaps it is because checkpatch.pl is supposed to check *patches*, which are
> > typically indented by one character (+- )?
> 
> Even so, the regexes are not entirely accurate.
> Patch below.

Yeah I was under the missaprehension that whitespace was allowed after
the # but not before.  That seems to be flawed.  Thanks for the patch.

"Preprocessing directives are lines in your program that start with `#'.
Whitespace is allowed before and after the `#'."

> ===
> commit e08a94e334d67ac5f2437c8aba4c6ffbb058d7db
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Tue Apr 29 00:06:42 2008 +0200
> 
> checkpatch: fix recognition of preprocessor directives
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 58a9494..22df611 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -355,12 +355,12 @@ sub sanitise_line {
>  	}
>  
>  	# The pathname on a #include may be surrounded by '<' and '>'.
> -	if ($res =~ /^.#\s*include\s+\<(.*)\>/) {
> +	if ($res =~ /^.\s*#\s*include\s+\<(.*)\>/) {
>  		my $clean = 'X' x length($1);
>  		$res =~ s@\<.*\>@<$clean>@;
>  
>  	# The whole of a #error is a string.
> -	} elsif ($res =~ /^.#\s*(?:error|warning)\s+(.*)\b/) {
> +	} elsif ($res =~ /^.\s*#\s*(?:error|warning)\s+(.*)\b/) {
>  		my $clean = 'X' x length($1);
>  		$res =~ s@(#\s*(?:error|warning)\s+).*@$1$clean@;
>  	}
> @@ -1194,7 +1194,7 @@ sub process {
>  
>  # if/while/etc brace do not go on next line, unless defining a do while loop,
>  # or if that brace on the next line is for something else
> -		if ($line =~ /(.*)\b((?:if|while|for|switch)\s*\(|do\b|else\b)/ && $line !~ /^.#/) {
> +		if ($line =~ /(.*)\b((?:if|while|for|switch)\s*\(|do\b|else\b)/ && $line !~ /^.\s*#/) {
>  			my $pre_ctx = "$1$2";
>  
>  			my ($level, @ctx) = ctx_statement_level($linenr, $realcnt, 0);
> @@ -1877,7 +1877,7 @@ sub process {
>  		}
>  
>  # warn about #if 0
> -		if ($line =~ /^.#\s*if\s+0\b/) {
> +		if ($line =~ /^.\s*#\s*if\s+0\b/) {
>  			CHK("if this code is redundant consider removing it\n" .
>  				$herecurr);
>  		}
> @@ -1891,14 +1891,14 @@ sub process {
>  		}
>  
>  # warn about #ifdefs in C files
> -#		if ($line =~ /^.#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
> +#		if ($line =~ /^.\s*#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
>  #			print "#ifdef in C files should be avoided\n";
>  #			print "$herecurr";
>  #			$clean = 0;
>  #		}
>  
>  # warn about spacing in #ifdefs
> -		if ($line =~ /^.#\s*(ifdef|ifndef|elif)\s\s+/) {
> +		if ($line =~ /^.\s*#\s*(ifdef|ifndef|elif)\s\s+/) {
>  			ERROR("exactly one space required after that #$1\n" . $herecurr);
>  		}
>  
> @@ -1972,7 +1972,7 @@ sub process {
>  # use of NR_CPUS is usually wrong
>  # ignore definitions of NR_CPUS and usage to define arrays as likely right
>  		if ($line =~ /\bNR_CPUS\b/ &&
> -		    $line !~ /^.#\s*define\s+NR_CPUS\s+/ &&
> +		    $line !~ /^.\s*#\s*define\s+NR_CPUS\s+/ &&
>  		    $line !~ /^.\s*$Declare\s.*\[[^\]]*NR_CPUS[^\]]*\]/)
>  		{
>  			WARN("usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
