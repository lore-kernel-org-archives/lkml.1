Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbZHCL6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbZHCL6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 07:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbZHCL6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 07:58:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39854 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbZHCL6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 07:58:34 -0400
Subject: Re: [PATCH 1/2] Create a DIV_ROUND_CLOSEST macro to do division
 with rounding
From: Peter Zijlstra <peterz@infradead.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>, Julia Lawall <julia@diku.dk>
In-Reply-To: <20081111010132.1730.76566.stgit@elm3a70.beaverton.ibm.com>
References: <20081111010132.1730.76566.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 03 Aug 2009 13:57:52 +0200
Message-Id: <1249300672.7924.53.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-10 at 17:01 -0800, Darrick J. Wong wrote:
> Create a helper macro to divide two numbers and round the result to the
> nearest whole number.  This is a helper macro for hwmon drivers that
> want to convert incoming sysfs values per standard hwmon practice, though
> the macro itself can be used by anyone.

Its too late to rename this now isn't it :-/

DIV_ROUND_{UP,CEIL}
DIV_ROUND_{DOWN,FLOOR}

I get.

The proposed thing is simply DIV_ROUND, but this DIV_ROUND_CLOSEST name
is just wonky.

Also, shouldn't it be something like ?

  DIV_ROUND(x, y) (((x) + (((y)+1)/2)) / (y))

Also, do we want the default rounding to be symmetric or asymmetric?

I think round to half even or something would be nice, but would add an
extra conditional, not sure its worth it (round away from zero only
works for signed numbers and it would also cost one conditional).

> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  include/linux/kernel.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index fba141d..fb02266 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -48,6 +48,12 @@ extern const char linux_proc_banner[];
>  #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
>  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
>  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
> +#define DIV_ROUND_CLOSEST(x, divisor)(			\
> +{							\
> +	typeof(divisor) __divisor = divisor;		\
> +	(((x) + ((__divisor) / 2)) / (__divisor));	\
> +}							\
> +)
>  
>  #define _RET_IP_		(unsigned long)__builtin_return_address(0)
>  #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })


