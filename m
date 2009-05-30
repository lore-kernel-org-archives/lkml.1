Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbZE3IUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbZE3IUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 04:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZE3IUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 04:20:01 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:36338 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZE3IT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 04:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=M2JqON5PN7aB+aeSsI+wYGDjr8PwyqpTKpjJsJ+cSnDQUY05TW9PBMC2xfQ86+D/dy
         uqw3YDhFFmJhhBMzHae0eQAymHiB+ooinLbMd7Akw+TuZ/hsNMlkBj0RBr5MYSTNwLIz
         nKIVb9aSTEAuTbSgaseNurtGt/vvR6g2bZz8g=
Date: Sat, 30 May 2009 10:19:54 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com, mingo@elte.hu,
       norsk5@yahoo.com, tglx@linutronix.de, hpa@zytor.com, mchehab@redhat.com,
       aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 0/4] amd64_edac: misc fixes
Message-ID: <20090530081954.GA21954@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com,
	mingo@elte.hu, norsk5@yahoo.com, tglx@linutronix.de, hpa@zytor.com,
	mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
	linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com> <20090528164720.0af5752b.akpm@linux-foundation.org> <20090529103329.GB23530@aftab> <20090529130115.a44efaee.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090529130115.a44efaee.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 01:01:15PM -0700, Andrew Morton wrote:
> gcc-4.0.2, gas-2.16.1

yep, just as I thought. binutils got the Fam10h support around July 2006
and yours are from June 2005.

> Here's your sent-off-list patch (please don't do that):

Ups, sorry. This wasn't meant to be a patch but only to show the
functional change. I'll integrate it as such in the patchset and rebase
the whole thing next week.

> diff -puN drivers/edac/amd64_edac.c~edac-build-fix drivers/edac/amd64_edac.c
> --- a/drivers/edac/amd64_edac.c~edac-build-fix
> +++ a/drivers/edac/amd64_edac.c
> @@ -1419,7 +1419,7 @@ static u32 f10_determine_channel(struct 
>  		if (dct_sel_interleave_addr(pvt) == 0)
>  			cs = sys_addr >> 6 & 1;
>  		else if ((dct_sel_interleave_addr(pvt) >> 1) & 1) {
> -			temp = popcnt((u32) ((sys_addr >> 16) & 0x1F)) % 2;
> +			temp = hweight_long((u32) ((sys_addr >> 16) & 0x1F)) % 2;
>  
>  			if (dct_sel_interleave_addr(pvt) & 1)
>  				cs = (sys_addr >> 9 & 1) ^ temp;
> diff -puN drivers/edac/amd64_edac.h~edac-build-fix drivers/edac/amd64_edac.h
> --- a/drivers/edac/amd64_edac.h~edac-build-fix
> +++ a/drivers/edac/amd64_edac.h
> @@ -443,19 +443,6 @@ enum {
>  #define K8_MSR_MC4STAT			0x0411
>  #define K8_MSR_MC4ADDR			0x0412
>  
> -/*
> - * popcnt - count the set bits in a bit vector.
> - * @vec - bit vector
> - *
> - * This instruction is supported only on F10h and later CPUs.
> - */
> -#define popcnt(x)						\
> -({								\
> -	typeof(x) __ret;					\
> -	__asm__("popcnt %1, %0" : "=r" (__ret) : "r" (x));	\
> -	__ret;							\
> -})
> -
>  /* AMD sets the first MC device at device ID 0x18. */
>  static inline int get_mc_node_id_from_pdev(struct pci_dev *pdev)
>  {
> _
> 
> That'll work.
> 
> A suitable way to solve all this would be to arrange for x86's hweight()
> to use the popcnt instruction, where that makes sense.

That's funny, actually we _have_ _been_ experimenting here with
replacing hweight with popcnt and there's only a minor speedup. We
originally thought it might be a good idea to do the Hamming weight
calculation in hardware, especially when this is used in hot paths like
the scheduler but the bitmask counting is not being done enough times
to actually notice any significant improvement. Besides, the hweight_*
thingies are quite fast the way they are.

But sure, I could dig out my patchset and rediff it for review - it is
pretty small, actually. Also, I've been thinking about how the old(er)
toolchain problem can be addressed and one fairly doable thing would be
if I'd query the gas version in the kernel Makefile and define popcnt
dependent on it and for older assemblers simply slap in the opcode and
fixate the operands in an inline assembly so that it works.

Possible issues with that would be if someone uses a different toolchain
but do we support that at all? I'm guessing distro-patched bintuils
won't be a problem since even if they introduced popcnt support earlier,
the opcode would still be correct.

Opinions? Comments?

-- 
Regards/Gruss,
    Boris.
