Return-Path: <linux-kernel-owner+w=401wt.eu-S932174AbZJ0UZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbZJ0UZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932133AbZJ0UZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:25:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46371 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129AbZJ0UZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:25:24 -0400
Subject: Re: [PATCH 4/9] tracing: recordmcount.pl Objcopy check should
 disable local reference correctly
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20091027070011.GD22032@uhli>
References: <20091027065421.GA22032@uhli>  <20091027070011.GD22032@uhli>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 27 Oct 2009 16:16:36 -0400
Message-Id: <1256674596.26028.436.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 15:00 +0800, Li Hong wrote:
> >From 580ea035d04d4ca58300423db3dd5b4c73c8d61c Mon Sep 17 00:00:00 2001
> From: Li Hong <lihong.hi@gmail.com>
> Date: Tue, 27 Oct 2009 12:41:22 +0800
> Subject: [PATCH] tracing: recordmcount.pl Objcopy check should disable local reference correctly
> 
> Use a function to do objcopy version check. Disable the local reference if
> copy can't support it. Remove some unused variables.
> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 94daf9e..970c6d6 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -155,6 +155,28 @@ my $function_regex;	# Find the name of a function
>  my $mcount_regex;	# Find the call site to mcount (return offset)
>  my $alignment;		# The .align value to use for $mcount_section
>  my $section_type;	# Section header plus possible alignment command
> +my $can_use_local = 0; 	# If we can use local function references
> +
> +##
> +# check_objcopy - whether objcopy supports --globalize-symbols
> +#
> +#  --globalize-symbols came out in 2.17, we must test the version
> +#  of objcopy, and if it is less than 2.17, then we can not
> +#  record local functions.
> +sub check_objcopy
> +{
> +    open (IN, "$objcopy --version |") or die "error running $objcopy";
> +    while (<IN>) {
> +        if (/objcopy.*\s(\d+)\.(\d+)/) {
> +            $can_use_local = 1 if ($1 > 2 || ($1 == 2 && $2 >= 17)); 
> +            last;
> +        }
> +    }
> +    close (IN);
> +
> +    print STDERR "WARNING: could not find objcopy version or version is less than 2.17.\n" .
> +	"\tLocal function references is disabled.\n" if !$can_use_local; 

Please use C like if's. This tricked even me. I looked at it, and said
to myself, "Wait, this prints an error every time... oh wait!".

There are some cases where I don't mind the perl if style, and used it
for assigning defaults. But this just makes it more difficult to
understand.

The rest of the patch looks good.

-- Steve

> +}
>  
>  if ($arch eq "x86") {
>      if ($bits == 64) {
> @@ -289,34 +311,7 @@ if ($filename =~ m,^(.*)(\.\S),) {
>  my $mcount_s = $dirname . "/.tmp_mc_" . $prefix . ".s";
>  my $mcount_o = $dirname . "/.tmp_mc_" . $prefix . ".o";
>  
> -#
> -# --globalize-symbols came out in 2.17, we must test the version
> -# of objcopy, and if it is less than 2.17, then we can not
> -# record local functions.
> -my $use_locals = 01;
> -my $local_warn_once = 0;
> -my $found_version = 0;
> -
> -open (IN, "$objcopy --version |") || die "error running $objcopy";
> -while (<IN>) {
> -    if (/objcopy.*\s(\d+)\.(\d+)/) {
> -	my $major = $1;
> -	my $minor = $2;
> -
> -	$found_version = 1;
> -	if ($major < 2 ||
> -	    ($major == 2 && $minor < 17)) {
> -	    $use_locals = 0;
> -	}
> -	last;
> -    }
> -}
> -close (IN);
> -
> -if (!$found_version) {
> -    print STDERR "WARNING: could not find objcopy version.\n" .
> -	"\tDisabling local function references.\n";
> -}
> +check_objcopy();
>  
>  #
>  # Step 1: find all the local (static functions) and weak symbols.
> @@ -363,7 +358,7 @@ sub update_funcs
>      if (defined $locals{$ref_func}) {
>  
>  	# only use locals if objcopy supports globalize-symbols
> -	if (!$use_locals) {
> +	if (!$can_use_local) {
>  	    return;
>  	}
>  	$convert{$ref_func} = 1;

