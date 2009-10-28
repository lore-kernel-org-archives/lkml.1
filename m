Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbZJ1U7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbZJ1U7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZJ1U7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:59:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35404 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbZJ1U7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:59:18 -0400
Subject: Re: [PATCH v3 4/8] tracing: recordmcount.pl Objcopy check should
 disable local reference correctly
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20091028050421.GD30758@uhli>
References: <20091028045532.GA30036@uhli>  <20091028050421.GD30758@uhli>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 28 Oct 2009 16:59:20 -0400
Message-Id: <1256763560.26028.1825.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 13:04 +0800, Li Hong wrote:
> >From ceb80d8ba4fc55916c5f88d8c0a7655b869702cf Mon Sep 17 00:00:00 2001
> From: Li Hong <lihong.hi@gmail.com>
> Date: Tue, 27 Oct 2009 12:41:22 +0800
> Subject: [PATCH] tracing: recordmcount.pl Objcopy check should disable local reference correctly
> 
> Use a function to do objcopy version check. Disable the local reference if
> copy can't support it. Remove some unused variables.

Note, a lot of your patches have whitespace issues (white space at the
end of the line, etc). I've cleaned them up, but you want to be more
careful next time.

> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>
> ---
>  scripts/recordmcount.pl |   55 ++++++++++++++++++++++------------------------
>  1 files changed, 26 insertions(+), 29 deletions(-)
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 8ff9eab..1de9826 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -158,6 +158,30 @@ my $function_regex;	# Find the name of a function
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
> +    if (!$can_use_local) {
> +        print STDERR "WARNING: could not find objcopy version or version is less than 2.17.\n" .
> +	"\tLocal function references is disabled.\n"  

Missing a ';' above. I've fixed this too, and broke the first line up
too, to be less than 80 characters.

Thanks,

-- Steve



> +    }
> +}
>  
>  if ($arch eq "x86") {
>      if ($bits == 64) {


