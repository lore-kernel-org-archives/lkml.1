Return-Path: <linux-kernel-owner+w=401wt.eu-S1760768AbXJaPee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768AbXJaPee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758831AbXJaPeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:34:24 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:46613 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757645AbXJaPeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:34:23 -0400
Message-ID: <47289EE3.8080706@student.ltu.se>
Date: Wed, 31 Oct 2007 16:27:31 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Paul Jimenez <pj@place.org>
CC: rgooch@atnf.csiro.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtrr use type bool
References: <20071031035718.A1D9E8B2A@place.org>
In-Reply-To: <20071031035718.A1D9E8B2A@place.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jimenez wrote:
> This is a janitorish patch to 1) remove private TRUE/FALSE #def's in
> favor of using the standard enum from linux/stddef.h and 2) switch the
> variables holding those values to type 'bool' (from linux/types.h)
> since it both seems more appropriate and allows for potentially better
> optimization.
>
> As a truly minor aside, I removed a couple of comments documenting
> a 'do_safe' parameter that seems to no longer exist.
>
> Signed-off-by: Paul Jimenez <pj@place.org>
>
>
>   
<snip>
> diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
> index 9abbdf7..591bd96 100644
> --- a/arch/x86/kernel/cpu/mtrr/main.c
> +++ b/arch/x86/kernel/cpu/mtrr/main.c
> @@ -313,7 +313,7 @@ static void set_mtrr(unsigned int reg, unsigned long base,
>   */
>  
>  int mtrr_add_page(unsigned long base, unsigned long size, 
> -		  unsigned int type, char increment)
> +		  unsigned int type, bool increment)
>  {
>  	int i, replace, error;
>  	mtrr_type ltype;
> @@ -396,7 +396,7 @@ int mtrr_add_page(unsigned long base, unsigned long size,
>  		if (likely(replace < 0))
>  			usage_table[i] = 1;
>  		else {
> -			usage_table[i] = usage_table[replace] + !!increment;
> +			usage_table[i] = usage_table[replace] + increment;
>   
This seems a bit strange, using a boolean as an integer (yes I know, it 
works but semantically...). What about:

+			usage_table[i] = usage_table[replace];
+			usage_table[i] += increment ? 1 : 0;
? 

>  			if (unlikely(replace != i)) {
>  				set_mtrr(replace, 0, 0, 0);
>  				usage_table[replace] = 0;
> @@ -462,7 +462,7 @@ static int mtrr_check(unsigned long base, unsigned long size)
>  
>  int
>  mtrr_add(unsigned long base, unsigned long size, unsigned int type,
> -	 char increment)
> +	 bool increment)
>  {
>  	if (mtrr_check(base, size))
>  		return -EINVAL;
> diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
> index 289dfe6..54347e9 100644
> --- a/arch/x86/kernel/cpu/mtrr/mtrr.h
> +++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
> @@ -2,10 +2,8 @@
>   * local mtrr defines.
>   */
>  
> -#ifndef TRUE
> -#define TRUE  1
> -#define FALSE 0
> -#endif
> +#include <linux/types.h>
> +#include <linux/stddef.h>
>   
Isn't those included by default?
>  
>  #define MTRRcap_MSR     0x0fe
>  #define MTRRdefType_MSR 0x2ff
> diff --git a/include/asm-x86/mtrr.h b/include/asm-x86/mtrr.h
> index e8320e4..262670e 100644
> --- a/include/asm-x86/mtrr.h
> +++ b/include/asm-x86/mtrr.h
> @@ -89,9 +89,9 @@ struct mtrr_gentry
>  extern void mtrr_save_fixed_ranges(void *);
>  extern void mtrr_save_state(void);
>  extern int mtrr_add (unsigned long base, unsigned long size,
> -		     unsigned int type, char increment);
> +		     unsigned int type, bool increment);
>  extern int mtrr_add_page (unsigned long base, unsigned long size,
> -		     unsigned int type, char increment);
> +		     unsigned int type, bool increment);
>  extern int mtrr_del (int reg, unsigned long base, unsigned long size);
>  extern int mtrr_del_page (int reg, unsigned long base, unsigned long size);
>  extern void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi);
> @@ -101,12 +101,12 @@ extern void mtrr_bp_init(void);
>  #define mtrr_save_fixed_ranges(arg) do {} while (0)
>  #define mtrr_save_state() do {} while (0)
>  static __inline__ int mtrr_add (unsigned long base, unsigned long size,
> -				unsigned int type, char increment)
> +				unsigned int type, bool increment)
>  {
>      return -ENODEV;
>  }
>  static __inline__ int mtrr_add_page (unsigned long base, unsigned long size,
> -				unsigned int type, char increment)
> +				unsigned int type, bool increment)
>  {
>      return -ENODEV;
>  }
> -
The rest looks good :)

Richard Knutsson

