Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYGYIfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYGYIfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYGYIfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:35:07 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:53952 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750927AbYGYIfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:35:05 -0400
Date: Fri, 25 Jul 2008 09:34:48 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: David Miller <davem@davemloft.net>
Cc: bzolnier@gmail.com, harvey.harrison@gmail.com, linux-ide@kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: recent IDE regression
Message-ID: <20080725083448.GE8301@fluff.org.uk>
References: <20080724.233831.193691312.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724.233831.193691312.davem@davemloft.net>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 11:38:31PM -0700, David Miller wrote:
> 
> After today's IDE merge my sparc64 workstation stopped booting.
> 
> It's due to this change:
> 
> commit 7fa897b91a3ea0f16c2873b869d7a0eef05acff4
> Author: Harvey Harrison <harvey.harrison@gmail.com>
> Date:   Thu Jul 24 22:53:34 2008 +0200
> 
>     ide: trivial sparse annotations
>     
>     Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>     Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Heh, "trivial", indeed.
> 
> Specifically, this part of the change:
> 
> diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
> index 07da5fb..8aae917 100644
> --- a/drivers/ide/ide-iops.c
> +++ b/drivers/ide/ide-iops.c
> @@ -510,10 +510,8 @@ void ide_fixstring (u8 *s, const int bytecount, const int byteswap)
>  
>  	if (byteswap) {
>  		/* convert from big-endian to host byte order */
> -		for (p = end ; p != s;) {
> -			unsigned short *pp = (unsigned short *) (p -= 2);
> -			*pp = ntohs(*pp);
> -		}
> +		for (p = end ; p != s;)
> +			be16_to_cpus((u16 *)(p -= 2));

personally, i would much prefer to see the loop being less evil
like:

	for (p = s; p < end; p += 2)
		be16_to_cpus((u16 *)p);

is there an architecture/compiler combo which really makes this
evil worthwile? on arm (gcc 4.2), both evaluate to the same number of
instructions.

>  	}
>  	/* strip leading blanks */
>  	while (s != end && *s == ' ')
> 
> On big-endian, be16_to_cpus() (via __be16_to_cpus()) is:
> 
> 	do { } while (0)
> 
> which therefore does not evaluate the argument, and thus this loop
> will make no forward progress.
> 
> Probably the fix is in be16_to_cpus(), making it do something like
> "(void) (x);" in the do/while body.
> 
> Something like this:
> 
> endian: Always evaluate arguments.
> 
> Changeset 7fa897b91a3ea0f16c2873b869d7a0eef05acff4
> ("ide: trivial sparse annotations") created an IDE bootup
> regression on big-endian systems.  In drivers/ide/ide-iops.c,
> function ide_fixstring() we now have the loop:
> 
> 		for (p = end ; p != s;)
> 			be16_to_cpus((u16 *)(p -= 2));
> 
> which will never terminate on big-endian because in such
> a configuration be16_to_cpus() evaluates to "do { } while (0)"
> 
> Therefore, always evaluate the arguments to nop endian transformation
> operations.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/include/linux/byteorder/big_endian.h b/include/linux/byteorder/big_endian.h
> index 961ed4b..44f95b9 100644
> --- a/include/linux/byteorder/big_endian.h
> +++ b/include/linux/byteorder/big_endian.h
> @@ -94,12 +94,12 @@ static inline __u16 __be16_to_cpup(const __be16 *p)
>  #define __le32_to_cpus(x) __swab32s((x))
>  #define __cpu_to_le16s(x) __swab16s((x))
>  #define __le16_to_cpus(x) __swab16s((x))
> -#define __cpu_to_be64s(x) do {} while (0)
> -#define __be64_to_cpus(x) do {} while (0)
> -#define __cpu_to_be32s(x) do {} while (0)
> -#define __be32_to_cpus(x) do {} while (0)
> -#define __cpu_to_be16s(x) do {} while (0)
> -#define __be16_to_cpus(x) do {} while (0)
> +#define __cpu_to_be64s(x) do { (void)(x); } while (0)
> +#define __be64_to_cpus(x) do { (void)(x); } while (0)
> +#define __cpu_to_be32s(x) do { (void)(x); } while (0)
> +#define __be32_to_cpus(x) do { (void)(x); } while (0)
> +#define __cpu_to_be16s(x) do { (void)(x); } while (0)
> +#define __be16_to_cpus(x) do { (void)(x); } while (0)
>  
>  #ifdef __KERNEL__
>  #include <linux/byteorder/generic.h>
> diff --git a/include/linux/byteorder/little_endian.h b/include/linux/byteorder/little_endian.h
> index 05dc7c3..4cc170a 100644
> --- a/include/linux/byteorder/little_endian.h
> +++ b/include/linux/byteorder/little_endian.h
> @@ -88,12 +88,12 @@ static inline __u16 __be16_to_cpup(const __be16 *p)
>  {
>  	return __swab16p((__u16 *)p);
>  }
> -#define __cpu_to_le64s(x) do {} while (0)
> -#define __le64_to_cpus(x) do {} while (0)
> -#define __cpu_to_le32s(x) do {} while (0)
> -#define __le32_to_cpus(x) do {} while (0)
> -#define __cpu_to_le16s(x) do {} while (0)
> -#define __le16_to_cpus(x) do {} while (0)
> +#define __cpu_to_le64s(x) do { (void)(x); } while (0)
> +#define __le64_to_cpus(x) do { (void)(x); } while (0)
> +#define __cpu_to_le32s(x) do { (void)(x); } while (0)
> +#define __le32_to_cpus(x) do { (void)(x); } while (0)
> +#define __cpu_to_le16s(x) do { (void)(x); } while (0)
> +#define __le16_to_cpus(x) do { (void)(x); } while (0)
>  #define __cpu_to_be64s(x) __swab64s((x))
>  #define __be64_to_cpus(x) __swab64s((x))
>  #define __cpu_to_be32s(x) __swab32s((x))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
