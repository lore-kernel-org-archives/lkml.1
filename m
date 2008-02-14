Return-Path: <linux-kernel-owner+w=401wt.eu-S1765481AbYBNTq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765481AbYBNTq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758891AbYBNTqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:46:13 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:60861 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765221AbYBNTqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:46:10 -0500
Date: Thu, 14 Feb 2008 20:46:05 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 12/14] fs/binfmt_aout.c: Use time_* macros
In-Reply-To: <1203003412-11594-13-git-send-email-caglar@pardus.org.tr>
Message-ID: <Pine.LNX.4.64.0802142044470.12316@anakin>
References: y <1203003412-11594-13-git-send-email-caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808512-737208374-1203018365=:12316"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808512-737208374-1203018365=:12316
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 14 Feb 2008, S.Ã~GaÄ~_lar Onur wrote:
> The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.
> 
> So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly
> 
> Cc: linux-arch@vger.kernel.org
> Signed-off-by: S.Ã‡aÄŸlar Onur <caglar@pardus.org.tr>
> ---
>  fs/binfmt_aout.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
> index a1bb224..72757fe 100644
> --- a/fs/binfmt_aout.c
> +++ b/fs/binfmt_aout.c
> @@ -6,6 +6,7 @@
>  
>  #include <linux/module.h>
>  
> +#include <linux/jiffies.h>
>  #include <linux/time.h>
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
> @@ -374,14 +375,14 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
>  	} else {
>  		static unsigned long error_time, error_time2;
>  		if ((ex.a_text & 0xfff || ex.a_data & 0xfff) &&
> -		    (N_MAGIC(ex) != NMAGIC) && (jiffies-error_time2) > 5*HZ)
> +		    (N_MAGIC(ex) != NMAGIC) && time_after(jiffies, error_time2 + 5 * HZ))
>  		{
>  			printk(KERN_NOTICE "executable not page aligned\n");
>  			error_time2 = jiffies;
>  		}
>
>  
>  		if ((fd_offset & ~PAGE_MASK) != 0 &&
> -		    (jiffies-error_time) > 5*HZ)
> +		    time_after(jiffies, error_time + 5 * HZ))
>  		{
>  			printk(KERN_WARNING 
>  			       "fd_offset is not page aligned. Please convert program: %s\n",
> @@ -498,7 +499,7 @@ static int load_aout_library(struct file *file)
>  		static unsigned long error_time;
>  		loff_t pos = N_TXTOFF(ex);
>  
> -		if ((jiffies-error_time) > 5*HZ)
> +		if (time_after(jiffies ,error_time + 5 * HZ))
>  		{
>  			printk(KERN_WARNING 
>  			       "N_TXTOFF is not page aligned. Please convert library: %s\n",

To me these constructs look like good candidates for replacement by
printk_ratelimit()?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808512-737208374-1203018365=:12316--
