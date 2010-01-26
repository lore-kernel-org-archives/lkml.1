Return-Path: <linux-kernel-owner+w=401wt.eu-S1752058Ab0AZAmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab0AZAmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084Ab0AZAl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:41:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745Ab0AZAl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:41:57 -0500
Date: Mon, 25 Jan 2010 16:40:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 22/37] move round_up/down to kernel.h
Message-Id: <20100125164032.330be0e6.akpm@linux-foundation.org>
In-Reply-To: <4B57675E.7070309@kernel.org>
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
	<1263611228-6751-23-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.00.1001191155540.22304@router.home>
	<4B57675E.7070309@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010 12:28:14 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> On 01/19/2010 09:57 AM, Christoph Lameter wrote:
> > On Fri, 15 Jan 2010, Yinghai Lu wrote:
> > 
> >>
> >>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
> >>
> >> +/*
> >> + * This looks more complex than it should be. But we need to
> >> + * get the type for the ~ right in round_down (it needs to be
> >> + * as wide as the result!), and we want to evaluate the macro
> >> + * arguments just once each.
> >> + */
> >> +#define __round_mask(x,y) ((__typeof__(x))((y)-1))
> >> +#define round_up(x,y) ((((x)-1) | __round_mask(x,y))+1)
> >> +#define round_down(x,y) ((x) & ~__round_mask(x,y))
> >> +
> >>  #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
> >>  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> >>  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
> > 
> > Note the last two lines! We already have roundup(), DIV_ROUND_UP and
> > DIV_ROUND_CLOSEST. Please integrate them properly. Maybe extract
> > __round_mask() from all of them.
> 
> like this, using DIVIDE for all ?
> 
> ---
>  include/linux/kernel.h |   14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6/include/linux/kernel.h
> ===================================================================
> --- linux-2.6.orig/include/linux/kernel.h
> +++ linux-2.6/include/linux/kernel.h
> @@ -44,19 +44,13 @@ extern const char linux_proc_banner[];
>  
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
>  
> -/*
> - * This looks more complex than it should be. But we need to
> - * get the type for the ~ right in round_down (it needs to be
> - * as wide as the result!), and we want to evaluate the macro
> - * arguments just once each.
> - */

umph.  It would have been better to read that comment, rather than
delete it!

> +#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))

This references its second argument three times.

> +#define rounddown(x, y) (((x) / (y)) * (y))
> +#define round_up(x,y) roundup(x,y)
> +#define round_down(x,y) rounddown(x,y)

Please use checkpatch.pl.  Always.

>  #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
>  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> -#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
>  #define DIV_ROUND_CLOSEST(x, divisor)(			\
>  {							\
>  	typeof(divisor) __divisor = divisor;		\

This patch doesn't seem very good.  Nor does "[PATCH 24/38] move
round_up/down to kernel.h".

The problem is that arch/x86/include/asm/proto.h implements private
rounding macros.  The right way to fix that is to convert each x86
"call site" over to using the standard macros from kernel.h, then
finally remove the private definitions from
arch/x86/include/asm/proto.h.  Don't just copy them over to kernel.h
and make things muddier than they already are!

If during that conversion it is found that the standard macros for some
reason don't suit the x86 usage sites then please propose
enhancements/fixes to the existing kernel.h facilities.

And any such changes to kernel.h affect the whole world, so they
shouldn't be buried in the middle of some huge x86-specific patch
series which everyone sleeps through.  They can be _merged_ via the x86
tree - that doesn't matter much.  But it should be made clear to
everyone that these are changes which potentially affect every piece
of code in the tree.

