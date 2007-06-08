Return-Path: <linux-kernel-owner+w=401wt.eu-S938063AbXFHIjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938063AbXFHIjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932842AbXFHIj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 04:39:29 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1455 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763664AbXFHIj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 04:39:28 -0400
Message-ID: <466915A6.2030607@shadowen.org>
Date: Fri, 08 Jun 2007 09:39:02 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 9/36] drivers edac new intel 5000X mc driver
References: <404349.85191.qm@web50103.mail.re2.yahoo.com>	<20070607143840.d259a4c1.akpm@linux-foundation.org> <20070607151012.e4145965.rdunlap@xenotime.net>
In-Reply-To: <20070607151012.e4145965.rdunlap@xenotime.net>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 7 Jun 2007 14:38:40 -0700 Andrew Morton wrote:
> 
>> On Sun, 3 Jun 2007 07:40:26 -0700 (PDT)
>> Doug Thompson <norsk5@yahoo.com> wrote:
>>
>>> +static void i5000_process_nonfatal_error_info(struct mem_ctl_info
>>> *mci,
>>> +					      struct i5000_error_info * info,
>> ditto (please check whole patch)
>>
>> (I thought checkpatch.pl would catch this, but it doesn't?)
> 
> Here's a small patch against v.3 that will catch this.
> 
> ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Catch "struct * blah" by allowing spaces preceding the '*'.
> Bah.  Maybe the error string needs a small change also.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  scripts/checkpatch.pl |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- scripts.orig/checkpatch-v3.pl
> +++ scripts/checkpatch-v3.pl
> @@ -393,7 +393,7 @@ sub process {
>  		}
>  
>  # * goes on variable not on type
> -		if ($line=~/[A-Za-z\d_]+\* [A-Za-z\d_]+/) {
> +		if ($line=~/[\sA-Za-z\d_]+\* [A-Za-z\d_]+/) {
>  			print "\"foo* bar\" should be \"foo *bar\"\n";
>  			print "$herecurr";
>  			$clean = 0;
> -

0.04 already has checks for reporting the foo ** bar style cast format
where there are two or more '*'s:

"foo ** bar" should be "foo **bar"
#12: FILE: Z4.c:9:
+       struct i5000_error_info ** foo;

The declaration forms (just for a single *) are unfortunately ambiguous,
it is hard to tell them from the foo * foo multiply form, for example if
we relax this test to include one '*':

"foo * bar" should be "foo *bar"
#19: FILE: Z4.c:16:
+       int a = this * info;

[/me pokes at it for a bit.]

Ok so the key here is that we should only be applying these foo* bar
checks to types.  What we can do is cook up a match for the standard
type forms, char, short ..., struct foo etc and use that to disambiguate
the single '*' form:

"foo * bar" should be "foo *bar"
#10: FILE: Z4.c:7:
+       struct i5000_error_info * foo;

We will miss those which are not obviously types, basically typedefs but
as we already are hot against those we should be pretty close to 100%
coverage.

-apw
