Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbYIAQfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbYIAQfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYIAQew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:34:52 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:57786 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbYIAQev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:34:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=DtYNhvcHwOqBvQSZPnPZ+W57RUIk9ECxPGql9Hqwb5p3Q765cW9EU9fXOFcvhyy1wS
         UTasLJImTN+GrcscYf5np90XcrCOv/6QXul5BgmekPfmSbtC3zkMcSY5XgzoSEJfoRMY
         IkMJ2xXmZ9O8zolL4azbFom44isgg0Jj3qIaA=
To: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/5 ver2] rt2x00: Compiler warning unmasked by fix of BUILD_BUG_ON
Date: Mon, 1 Sep 2008 18:34:45 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <48BBE77D.7070007@panasas.com> <a32f33a40809010701o1069afdfuc2745f934753fb2e@mail.gmail.com> <48BC077A.9000106@panasas.com>
In-Reply-To: <48BC077A.9000106@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809011834.45856.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2008, Boaz Harrosh wrote:
> Ivo Van Doorn wrote:
> > On Mon, Sep 1, 2008 at 3:44 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> >> A "Set" of a sign-bit in an "&" operation causes a compiler warning.
> >> Make calculations unsigned.
> >>
> >> [ The warning was masked by the use of (void)() cast in the old
> >>  BUILD_BUG_ON() ]
> >>
> >> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> >> TO: Ivo van Doorn <IvDoorn@gmail.com>
> >> TO: John W. Linville <linville@tuxdriver.com>
> >> CC: Ingo Molnar <mingo@elte.hu>
> >> CC: Rusty Russell <rusty@rustcorp.com.au>
> >> ---
> >>  drivers/net/wireless/rt2x00/rt2x00reg.h |    4 ++--
> >>  1 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
> >> index 7e88ce5..e71b793 100644
> >> --- a/drivers/net/wireless/rt2x00/rt2x00reg.h
> >> +++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
> >> @@ -136,8 +136,8 @@ struct rt2x00_field32 {
> >>  */
> >>  #define is_power_of_two(x)     ( !((x) & ((x)-1)) )
> >>  #define low_bit_mask(x)                ( ((x)-1) & ~(x) )
> >> -#define is_valid_mask(x)       is_power_of_two(1 + (x) + low_bit_mask(x))
> >> -
> >> +#define is_valid_mask(x)       is_power_of_two(1 + (x) + \
> >> +                                       low_bit_mask((unsigned long)x))
> > 
> > I know I typed it wrong, but you are missing the unsigned long cast for the
> > is_power_of_two argument here (Which could also be done in the
> > is_valid_mask() definition).
> > 
> 
> I thought you suggested that on purpose. Since at the end it is all
> one expression, the compiler propagates the cast to all participants.
> 
> Do you want that I send a fix for readability's sake?

Yes, thanks.

> >>  /*
> >>  * Macro's to find first set bit in a variable.
> >>  * These macro's behaves the same as the __ffs() function with
> >> --
> >> 1.5.6.rc1.5.gadf6
> >>
> 
> Is below what you mean? but if so then perhaps my original one is
> clearer. Note that it compiles and works as is.

Below patch is good. Your original one would have had the same comment
as the original one, where the cast was only done on 1 x instead of both usages.

I think the below version is the most clear solution. :)

Ivo

> ---
> diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
> index 7e88ce5..e71b793 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00reg.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
> @@ -136,8 +136,8 @@ struct rt2x00_field32 {
>   */
>  #define is_power_of_two(x)	( !((x) & ((x)-1)) )
>  #define low_bit_mask(x)		( ((x)-1) & ~(x) )
> -#define is_valid_mask(x)	is_power_of_two(1 + (x) + low_bit_mask(x))
> -
> +#define is_valid_mask(x)	is_power_of_two(1LU + (unsigned long)(x) + \
> +					low_bit_mask((unsigned long)x))
>  /*
>   * Macro's to find first set bit in a variable.
>   * These macro's behaves the same as the __ffs() function with
> -- 1.5.6.rc1.5.gadf6 -- To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More majordomo info at http://vger.kernel.org/majordomo-info.html Please read the FAQ at http://www.tux.org/lkml/ 
> 
> 


