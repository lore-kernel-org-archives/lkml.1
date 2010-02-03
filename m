Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab0BCM3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 07:29:11 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:42296 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab0BCM3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 07:29:08 -0500
Message-ID: <4B696B91.4030405@monstr.eu>
Date: Wed, 03 Feb 2010 13:26:57 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: steve@digidescorp.com
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][NOMMU] microblaze: fix interrupt state restore
References: <1265027685-8990-1-git-send-email-steve@digidescorp.com>
In-Reply-To: <1265027685-8990-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

steve@digidescorp.com wrote:
> Interrupts must be disabled while an interrupt state restore 
> (prep for interrupt return) is in progress.
> Code to do this was lost in the port to the mainline kernel.

nice catch. I tried to find out why I used this change and it was in any 
ancient version which were used as . John did this change 2 years ago 
and I haven't found that change description.

Can you please setup your name in email with patches? (From line should 
  contains your full name and email - you have just email there).
I had to change it manually. Your first patches has correct setting and 
I see that the later one not.

Documentation/SubmittingPatches.

The "from" line must be the very first line in the message body,
and has the form:

         From: Original Author <author@example.com>


Thanks,
Michal


> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/arch/microblaze/kernel/entry-nommu.S b/arch/microblaze/kernel/entry-nommu.S
> --- a/arch/microblaze/kernel/entry-nommu.S	2010-01-31 23:28:45.000000000 -0600
> +++ b/arch/microblaze/kernel/entry-nommu.S	2010-01-31 23:31:35.000000000 -0600
> @@ -122,7 +122,7 @@ ENTRY(_interrupt)
>  
>  ret_from_intr:
>  	lwi	r11, r1, PT_MODE
> -	bneid	r11, 3f
> +	bneid	r11, no_intr_resched
>  
>  	lwi	r6, r31, TS_THREAD_INFO	/* get thread info */
>  	lwi	r19, r6, TI_FLAGS	/* get flags in thread info */
> @@ -133,16 +133,18 @@ ret_from_intr:
>  	bralid	r15, schedule
>  	nop
>  1:	andi	r11, r19, _TIF_SIGPENDING
> -	beqid	r11, no_intr_reshed
> +	beqid	r11, no_intr_resched
>  	addk	r5, r1, r0
>  	addk	r7, r0, r0
>  	bralid	r15, do_signal
>  	addk	r6, r0, r0
>  
> -no_intr_reshed:
> +no_intr_resched:
> +	/* Disable interrupts, we are now committed to the state restore */
> +	disable_irq
> +
>  	/* save mode indicator */
>  	lwi	r11, r1, PT_MODE
> -3:
>  	swi	r11, r0, PER_CPU(KM)
>  
>  	/* save r31 */
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
