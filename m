Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZJ0UXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZJ0UXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756787AbZJ0UXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:23:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40634 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785AbZJ0UXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:23:09 -0400
Subject: Re: [PATCH 5/9] tracing: recordmcount.pl Clarify the logic on
 mcount section check
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20091027070113.GE22032@uhli>
References: <20091027065421.GA22032@uhli>  <20091027070113.GE22032@uhli>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 27 Oct 2009 16:18:52 -0400
Message-Id: <1256674732.26028.438.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 15:01 +0800, Li Hong wrote:
> >From eb8a2d53bc2484be223e4fa0df8804389e969b72 Mon Sep 17 00:00:00 2001
> From: Li Hong <lihong.hi@gmail.com>
> Date: Tue, 27 Oct 2009 12:53:52 +0800
> Subject: [PATCH] tracing: recordmcount.pl Clarify the logic on mcount section check
> 
> Move the mcount section check to the beginning of the objdump read loop.
> It is clearer, because mcount section check uses headers dump part of objdump
> to identify a mcount section, which goes before the section parts.
> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 970c6d6..a6585b6 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -384,9 +384,26 @@ open(IN, "$objdump -hdr $inputfile|") || die "error running $objdump";
>  
>  my $text;
>  
> -my $read_headers = 1;
>  
>  while (<IN>) {
> +    # read headers first
> +    my $read_headers = 1;
> +    

Please keep the $read_headers initialization outside of the while loop.
It makes it easier for C programers to understand. Otherwise it looks
like it gets reset every time.

-- Steve

> +    if ($read_headers && /$mcount_section/) {
> +	#
> +	# Somehow the make process can execute this script on an
> +	# object twice. If it does, we would duplicate the mcount
> +	# section and it will cause the function tracer self test
> +	# to fail. Check if the mcount section exists, and if it does,
> +	# warn and exit.
> +	#
> +	print STDERR "ERROR: $mcount_section already in $inputfile\n" .
> +	    "\tThis may be an indication that your build is corrupted.\n" .
> +	    "\tDelete $inputfile and try again. If the same object file\n" .
> +	    "\tstill causes an issue, then disable CONFIG_DYNAMIC_FTRACE.\n";
> +	exit(-1);
> +    }
> +
>      # is it a section?
>      if (/$section_regex/) {
>  	$read_headers = 0;
> @@ -427,21 +444,7 @@ while (<IN>) {
>  		$offset = hex $1;
>  	    }
>  	}
> -    } elsif ($read_headers && /$mcount_section/) {
> -	#
> -	# Somehow the make process can execute this script on an
> -	# object twice. If it does, we would duplicate the mcount
> -	# section and it will cause the function tracer self test
> -	# to fail. Check if the mcount section exists, and if it does,
> -	# warn and exit.
> -	#
> -	print STDERR "ERROR: $mcount_section already in $inputfile\n" .
> -	    "\tThis may be an indication that your build is corrupted.\n" .
> -	    "\tDelete $inputfile and try again. If the same object file\n" .
> -	    "\tstill causes an issue, then disable CONFIG_DYNAMIC_FTRACE.\n";
> -	exit(-1);
> -    }
> -
> +    } 
>      # is this a call site to mcount? If so, record it to print later
>      if ($text_found && /$mcount_regex/) {
>  	$offsets[$#offsets + 1] = hex $1;

