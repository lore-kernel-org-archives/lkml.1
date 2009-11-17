Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbZKQSQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbZKQSQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZKQSQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:16:40 -0500
Received: from bu3sch.de ([62.75.166.246]:46971 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbZKQSQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:16:40 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] strcmp: fix overflow error
Date: Tue, 17 Nov 2009 19:16:40 +0100
User-Agent: KMail/1.9.9
Cc: Uwe =?utf-8?q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1258476700-21323-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.01.0911170922190.9384@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0911170922190.9384@localhost.localdomain>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200911171916.41727.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009 18:41:58 Linus Torvalds wrote:
> 
> On Tue, 17 Nov 2009, Uwe Kleine-König wrote:
> >
> > strcmp("\x01", "\xef") returns 18 but it should return something < 0.
> > The reason is that the variable holding the result of the subtraction is
> > too small and overflows.
> 
> No. The reason is that whoever wrote that function is a moron and doesn't 
> know the standard. And your fix is not correct _either_
> 
> The comparison should be done as *unsigned char*. As specified by POSIX
> 
>   "The sign of a non-zero return value shall be determined by the sign of 
>    the difference between the values of the first pair of bytes (both 
>    interpreted as type unsigned char) that differ in the strings being 
>    compared."
> 
> and both the original code and your change gets it wrong in different 
> ways.
> 
> >  int strcmp(const char *cs, const char *ct)
> >  {
> > -	signed char __res;
> > +	int __res;
> >  
> >  	while (1) {
> >  		if ((__res = *cs - *ct++) != 0 || !*cs++)
> 
> So this is fundamentally incorrect both with "signed char __res" _and_ 
> with "int __res", because '*cs' and '*ct' are both (possibly - it depends 
> on the compiler and architecture) signed chars.
> 
> So in the case you mention, strcmp() _should_ return a negative value, 
> because "\x01" is smaller than "\xef", but you have:
> 
>  - *cs = 1, *ct = (char) 0xef = -17 _OR_ 239 depending on sign of 'char'
> 
> and as a result:
> 
>  - signed char __res = 18 (incorrect, regardless: ct is larger)
> 
>  - int __res = 18 (incorrect) or -238 (correct) depending on sign of char
> 
> so your patch doesn't actually help at all.
> 
> What would help is something like the appended, but I have not tested it 
> AT ALL. It may be total and utter crap too. Maybe it doesn't compile, 
> maybe it buggers your pet hedgehog. I just don't know.
> 
> 		Linus
> 
> ---
>  lib/string.c |   20 ++++++++++++++------
>  1 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/string.c b/lib/string.c
> index b19b87a..e96421a 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -246,13 +246,17 @@ EXPORT_SYMBOL(strlcat);
>  #undef strcmp
>  int strcmp(const char *cs, const char *ct)
>  {
> -	signed char __res;
> +	unsigned char c1, c2;
>  
>  	while (1) {
> -		if ((__res = *cs - *ct++) != 0 || !*cs++)
> +		c1 = *cs++;
> +		c2 = *ct++;
> +		if (c1 != c2)
> +			return c1 < c2 ? -1 : 1;
> +		if (!c1)
>  			break;
>  	}
> -	return __res;
> +	return 0;
>  }

Well, that doesn't actually return the difference at all. Is that allowed?

What about this? (Manually hacked pseudo patch)

diff --git a/lib/string.c b/lib/string.c
index b19b87a..661ff06 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -246,7 +246,7 @@ EXPORT_SYMBOL(strlcat);
 #undef strcmp
 int strcmp(const char *cs, const char *ct)
 {
-       signed char __res;
+       int __res;
 
        while (1) {
-                if ((__res = *cs - *ct++) != 0 || !*cs++)
+                if ((__res = (unsigned char)(*cs) - (unsigned char)(*ct++)) != 0 || !*cs++)
@@ -266,7 +266,7 @@ EXPORT_SYMBOL(strcmp);
  */

-- 
Greetings, Michael.
