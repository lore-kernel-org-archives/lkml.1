Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292Ab0AESjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab0AESjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577Ab0AESjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:39:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54028 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab0AESjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:39:13 -0500
X-Authority-Analysis: v=1.0 c=1 a=CyHtllh5IIIA:10 a=7U3hwN5JcxgA:10 a=03O1acm3KVkBI7kddWEA:9 a=O10N9Dp_rVO_vxUfryQA:7 a=4RbZmn6kV3Sl2eRHi_wvXaUyWVEA:4 a=XNN-oNMjSfgA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/2] tracing/recordmount.pl: optimize offsets-handling
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1262716072-14414-2-git-send-email-w.sang@pengutronix.de>
References: <1262716072-14414-1-git-send-email-w.sang@pengutronix.de>
	 <1262716072-14414-2-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 05 Jan 2010 13:39:11 -0500
Message-ID: <1262716751.28171.1614.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-05 at 19:27 +0100, Wolfram Sang wrote:
> - move check for open file in front of the writing loop
> - use perl-constructs to access the array
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
>  scripts/recordmcount.pl |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 92f09fe..5de12c7 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -432,14 +432,14 @@ sub update_funcs
>  
>      # Loop through all the mcount caller offsets and print a reference
>      # to the caller based from the ref_func.
> -    for (my $i=0; $i <= $#offsets; $i++) {
> -	if (!$opened) {
> -	    open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
> -	    $opened = 1;
> -	    print FILE "\t.section $mcount_section,\"a\",$section_type\n";
> -	    print FILE "\t.align $alignment\n" if (defined($alignment));
> -	}
> -	printf FILE "\t%s %s + %d\n", $type, $ref_func, $offsets[$i] - $offset;
> +    if (!$opened) {
> +	open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
> +	$opened = 1;
> +	print FILE "\t.section $mcount_section,\"a\",$section_type\n";
> +	print FILE "\t.align $alignment\n" if (defined($alignment));
> +    }
> +    foreach my $cur_offset (@offsets) {
> +	printf FILE "\t%s %s + %d\n", $type, $ref_func, $cur_offset - $offset;
>      }
>  }
>  
> @@ -514,7 +514,7 @@ while (<IN>) {
>      }
>      # is this a call site to mcount? If so, record it to print later
>      if ($text_found && /$mcount_regex/) {
> -	$offsets[$#offsets + 1] = hex $1;
> +	push(@offsets, hex $1);
>      }
>  }
>  

OK, I like this patch. I'll pull it in.

Thanks!

-- Steve



