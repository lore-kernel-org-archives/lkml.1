Return-Path: <linux-kernel-owner+w=401wt.eu-S1757738AbYBORWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbYBORWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYBORWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:22:00 -0500
Received: from xenotime.net ([66.160.160.81]:37663 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752547AbYBORV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:21:59 -0500
Date: Fri, 15 Feb 2008 09:21:54 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel-doc : possible fix for non-fatal perl errors when
 parsing some function pointers
Message-Id: <20080215092154.4a8cbba7.rdunlap@xenotime.net>
In-Reply-To: <1203095592.2929.54.camel@castor.localdomain>
References: <1203095592.2929.54.camel@castor.localdomain>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 17:13:12 +0000 Richard Kennedy wrote:

> When running "make htmldocs" I'm seeing some non-fatal perl errors
> caused by trying to parse the callback function definitions in
> blk-core.c.
> 
> The errors are "Use of uninitialized value in concatenation (.)..."
> 
> The function pointers are defined without a * i.e. 
> int (drv_callback)(struct request *)
> 
> The compiler is happy with them, but kernel-doc isn't. 
> 
> This patch teaches create_parameterlist in kernel-doc to parse this type
> of function pointer definition, but is it the right way to fix the
> problem ? The problem only seems to occur in blk-core.c.
> 
> However with the patch applied, kernel-doc finds the correct parameter
> description for the callback in blk_end_request_callback, which is
> doesn't normally.
> (the patch is against v2.6.25-rc1)
> 
> I thought it would be a bit odd to change to code to use the more normal
> form of function pointers just to get the documentation to work, so I
> fixed kernel-doc instead - even though this is teaching it to understand
> code that might go away (The comment for blk_end_request_callback says
> that it should not be used and will removed at some point). 
> 
> Any ideas on which is the best way to fix this?

Hi Richard,
Thanks for the patch.  I was planning to look into this problem
this weekend.

I think that changing scripts/kernel-doc to accept the current
kernel source tree usage is the right thing to do, even if the
block/blk code is a bit different.  I'll test it a bit and then
push it.

I appreciate the patch.

> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index 26146cb..68b2e4e 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -1512,13 +1512,13 @@ sub create_parameterlist($$$) {
>  	    # corresponding data structures "correctly". Catch it later in
>  	    # output_* subs.
>  	    push_parameter($arg, "", $file);
> -	} elsif ($arg =~ m/\(.*\*/) {
> +	} elsif ($arg =~ m/\(.+\)\s*\(/) {
>  	    # pointer-to-function
>  	    $arg =~ tr/#/,/;
> -	    $arg =~ m/[^\(]+\(\*\s*([^\)]+)\)/;
> +	    $arg =~ m/[^\(]+\(\*?\s*(\w*)\s*\)/;
>  	    $param = $1;
>  	    $type = $arg;
> -	    $type =~ s/([^\(]+\(\*)$param/$1/;
> +	    $type =~ s/([^\(]+\(\*?)$param/$1/;
>  	    push_parameter($param, $type, $file);
>  	} elsif ($arg) {
>  	    $arg =~ s/\s*:\s*/:/g;
> --  

---
~Randy
