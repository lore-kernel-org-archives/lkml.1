Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbYIAN1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbYIAN1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbYIAN1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:27:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:15503 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbYIAN1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:27:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Eh38LEn7egJLH7EDgvZUVbdMUWI0kRy8ybq5Im8CVSSsgWCSV7lUvpLUG2Nup8zcId
         hCkMeuwSOu+ound/DytNf50gYe5WRvf6jaCkiJz2VDNFM/x/5H6lFZxgxddJK9gWMIpk
         ipGY8tq1BloQNdhndtavlA83eziD8e392+C3M=
Message-ID: <a32f33a40809010627m1a030307y84d54182203c6efd@mail.gmail.com>
Date: Mon, 1 Sep 2008 15:27:01 +0200
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Boaz Harrosh" <bharrosh@panasas.com>
Subject: Re: [PATCH 4/5] rt2x00: Compiler warning unmasked by fix of BUILD_BUG_ON
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Theodore Tso" <tytso@mit.edu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jan Beulich" <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48BBEC6C.1050301@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48BBE77D.7070007@panasas.com> <48BBEC6C.1050301@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2008 at 3:21 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>
> A "Set" of the sign-bit in an "&" operation causes a compiler warning.
> Make calculations unsigned.
>
> [ The warning was masked by the use of (void)() cast in the old
>  BUILD_BUG_ON() ]
>
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> TO: Ivo van Doorn <IvDoorn@gmail.com>
> TO: John W. Linville <linville@tuxdriver.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/net/wireless/rt2x00/rt2x00reg.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
> index 7e88ce5..c0e8706 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00reg.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
> @@ -134,8 +134,8 @@ struct rt2x00_field32 {
>  * Note that we cannot use the is_power_of_2() function since this
>  * check must be done at compile-time.
>  */
> -#define is_power_of_two(x)     ( !((x) & ((x)-1)) )
> -#define low_bit_mask(x)                ( ((x)-1) & ~(x) )
> +#define is_power_of_two(x)     ( !((unsigned)(x) & ((x)-1)) )
> +#define low_bit_mask(x)                ( ((unsigned)(x)-1) & ~(x) )
>  #define is_valid_mask(x)       is_power_of_two(1 + (x) + low_bit_mask(x))

Could the patch not become a lot easier (and perhaps cleaner) when the
only change is:
#define is_valid_mask(x)       is_power_of_two(1 + (x) +
low_bit_mask((unsigned)x))
that way all instances of x will be cast to unsigned...

Ivo
