Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277Ab0AESiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab0AESiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136Ab0AESiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:38:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61437 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab0AESiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:38:00 -0500
X-Authority-Analysis: v=1.0 c=1 a=lN5U_OXkO8kA:10 a=7U3hwN5JcxgA:10 a=NJ_-846gYfVnATt3684A:9 a=p6H-GCihhoCAFDN3MG7d2Y3ahWUA:4 a=XNN-oNMjSfgA:10 a=ixd6uryaW8aaUtpN:21 a=I2y-Of9GV8QHU3m_:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/2] tracing/recordmount.pl: use apropriate
 perl-constructs
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1262716072-14414-3-git-send-email-w.sang@pengutronix.de>
References: <1262716072-14414-1-git-send-email-w.sang@pengutronix.de>
	 <1262716072-14414-2-git-send-email-w.sang@pengutronix.de>
	 <1262716072-14414-3-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 05 Jan 2010 13:37:55 -0500
Message-ID: <1262716675.28171.1612.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-05 at 19:27 +0100, Wolfram Sang wrote:
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
>  scripts/recordmcount.pl |   33 ++++++++++++---------------------
>  1 files changed, 12 insertions(+), 21 deletions(-)
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 5de12c7..59b73b9 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -136,13 +136,13 @@ my %text_sections = (
>       ".text.unlikely" => 1,
>  );
>  
> -$objdump = "objdump" if ((length $objdump) == 0);
> -$objcopy = "objcopy" if ((length $objcopy) == 0);
> -$cc = "gcc" if ((length $cc) == 0);
> -$ld = "ld" if ((length $ld) == 0);
> -$nm = "nm" if ((length $nm) == 0);
> -$rm = "rm" if ((length $rm) == 0);
> -$mv = "mv" if ((length $mv) == 0);
> +$objdump ||= 'objdump';
> +$objcopy ||= 'objcopy';
> +$cc ||= 'gcc';
> +$ld ||= 'ld';
> +$nm ||= 'nm';
> +$rm ||= 'rm';
> +$mv ||= 'mv';

I purposely did not do it this way (I need to add a comment about this),
because most kernel developers are not perl programmers, and I wanted
this to be as easy as possible for a non-perl programmer to understand.

Even as a perl programmer it still looks funny to me with the:


  $x ||= 'x';


So I will not accept this part.

>  
>  #print STDERR "running: $P '$arch' '$objdump' '$objcopy' '$cc' '$ld' " .
>  #    "'$nm' '$rm' '$mv' '$inputfile'\n";
> @@ -163,9 +163,8 @@ my $section_type;	# Section header plus possible alignment command
>  my $can_use_local = 0; 	# If we can use local function references
>  
>  # Shut up recordmcount if user has older objcopy
> -my $quiet_recordmcount = ".tmp_quiet_recordmcount";
> -my $print_warning = 1;
> -$print_warning = 0 if ( -f $quiet_recordmcount);
> +my $quiet_recordmcount = '.tmp_quiet_recordmcount';
> +my $print_warning = (! -f $quiet_recordmcount);

Again, this is just using perl obfuscation for most C programmers to
understand.

>  
>  ##
>  # check_objcopy - whether objcopy supports --globalize-symbols
> @@ -194,12 +193,8 @@ sub check_objcopy
>      }
>  }
>  
> -if ($arch eq "x86") {
> -    if ($bits == 64) {
> -	$arch = "x86_64";
> -    } else {
> -	$arch = "i386";
> -    }
> +if ($arch eq 'x86') {
> +    $arch = ($bits == 64) ? 'x86_64' : 'i386';
>  }

This part I like. It keeps to C constructs.

>  
>  #
> @@ -476,11 +471,7 @@ while (<IN>) {
>  	$read_headers = 0;
>  
>  	# Only record text sections that we know are safe
> -	if (defined($text_sections{$1})) {
> -	    $read_function = 1;
> -	} else {
> -	    $read_function = 0;
> -	}
> +	$read_function = defined($text_sections{$1});

I fine with this change too.

-- Steve

>  	# print out any recorded offsets
>  	update_funcs();
>  


