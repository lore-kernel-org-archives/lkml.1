Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbZGWOuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbZGWOuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbZGWOuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:50:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62740 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbZGWOuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:50:03 -0400
Date: Thu, 23 Jul 2009 10:50:03 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Matt Fleming <matt@console-pimps.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] ftrace: Correctly calculate the first function in
 the .text section
In-Reply-To: <1248342703-15758-1-git-send-email-matt@console-pimps.org>
Message-ID: <alpine.DEB.2.00.0907231043330.20997@gandalf.stny.rr.com>
References: <1248342703-15758-1-git-send-email-matt@console-pimps.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 23 Jul 2009, Matt Fleming wrote:

> This patch fixes a bug whereby recordmcount.pl didn't stop searching
> once it had correctly detected the function at the beginning of the
> .text section. To stop it searching, I needed to reset $read_function.
> The effect of this bug was that some entries in __mcount_loc section
> were created with the negative reloc addends. The last text section
> found was used as the base and all mcount calls were at a relative
> offset to that, so at final link time the addresses were fixed up to
> point to somewhere completely bogus.
> 
> This all resulted in ftrace dynamically modifying addresses that weren't
> actually mcount callsites.
> 
> I also noticed another bug and fixed up the condition from,

Famous quote: "When the comment does not match the code, they
are most likely both wrong".


> 
> 	if (!defined($ref_func) || !defined($weak{$text})) {
> to
> 	if (!defined($ref_func) && !defined($weak{$text})) {
> 
> This now matches the comment above the conditional.

This is the true bug. But the previous is not.

> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>
> ---
>  scripts/recordmcount.pl |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 7109e2b..356ff6a 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -414,8 +414,9 @@ while (<IN>) {
>  	    $read_function = 0;
>  	} else {
>  	    # if we already have a function, and this is weak, skip it
> -	    if (!defined($ref_func) || !defined($weak{$text})) {
> +	    if (!defined($ref_func) && !defined($weak{$text})) {

Ack on the above change.

>  		$ref_func = $text;
> +		$read_function = 0;

Nope, this is wrong. The idea is that we are looking for a function that 
is not local. Here's the full condition (with the applied fix):

        if (!defined($locals{$text}) && !defined($weak{$text})) {
            $ref_func = $text;
            $read_function = 0;
        } else {
            # if we already have a function, and this is weak, skip it
            if (!defined($ref_func) && !defined($weak{$text})) {
                $ref_func = $text;
            }
        }

Ideally, we want a non local function to use. If the first function in the 
section is local (defined as static) we record it, but we continue to look 
for more functions (don't set $read_function to 0). The first function in 
the section can easily be a static function, and there my be a global one 
later. If we find a global one later, we rather use that one. By setting 
$read_function to zero here, we stop our search, and we will be using a 
local static function instead.

When ever we use a static function as are reference point, we need to go 
through the pain of converting it to a global function to link in our 
mcount section, and then converting it back to local after it is linked. 

Offsets should be fine when negative, what issues do you see? I will admit 
though, that the s/||/&&/ was a real bug.

Thanks,

-- Steve

>  	    }
>  	}
>      } elsif ($read_headers && /$mcount_section/) {
> -- 
> 1.6.4.rc0
> 
> 
