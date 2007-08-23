Return-Path: <linux-kernel-owner+w=401wt.eu-S1765802AbXHWVux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765802AbXHWVux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 17:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761493AbXHWVup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 17:50:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51356 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760979AbXHWVuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 17:50:44 -0400
Date: Thu, 23 Aug 2007 14:50:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org
Subject: Re: [-mm patch] enforce noreplace-smp in alternative_instructions()
Message-Id: <20070823145038.9895784f.akpm@linux-foundation.org>
In-Reply-To: <20070822202551.GB31846@slug>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<20070822202551.GB31846@slug>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 22:25:51 +0200
Frederik Deweerdt <deweerdt@free.fr> wrote:

> On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> > 
> Hi Jeremy,
> 
> arch/i386/kernel/alternative.c:alternative_instructions() doesn't
> check for noreplace-smp before setting capability bits and freeing the
> __smp_locks section.

umm, so?  What happens then?  What bug is being fixed here, and what are
its consequences?

> Every call to alternatives_smp_unlock() checks for noreplace-smp
> beforehand, so remove the check from there.
> 
> Boot tested on i386 with UP+noreplace-smp (lguest) and SMP (real hardware)
> 
> Regards,
> Frederik
> 
> Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
> 
> diff --git a/arch/i386/kernel/alternative.c b/arch/i386/kernel/alternative.c
> index 9f4ac8b..7c5af80 100644
> --- a/arch/i386/kernel/alternative.c
> +++ b/arch/i386/kernel/alternative.c
> @@ -221,9 +221,6 @@ static void alternatives_smp_unlock(u8 **start, u8 **end, u8 *text, u8 *text_end
>  	u8 **ptr;
>  	char insn[1];
>  
> -	if (noreplace_smp)
> -		return;
> -
>  	add_nops(insn, 1);
>  	for (ptr = start; ptr < end; ptr++) {
>  		if (*ptr < text)
> @@ -406,7 +403,7 @@ void __init alternative_instructions(void)
>  #endif
>  
>  #ifdef CONFIG_SMP
> -	if (smp_alt_once) {
> +	if (smp_alt_once && !noreplace_smp) {
>  		if (1 == num_possible_cpus()) {
>  			printk(KERN_INFO "SMP alternatives: switching to UP code\n");
>  			set_bit(X86_FEATURE_UP, boot_cpu_data.x86_capability);

You refer to rc3-mm1 and this is described as a "-mm patch" but it seems to
also be applicable to mainline?
