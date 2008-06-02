Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYFBWbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYFBWbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 18:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYFBWbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 18:31:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbYFBWbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 18:31:40 -0400
Date: Mon, 2 Jun 2008 15:30:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, davej@codemonkey.org.uk,
       andi@firstfloor.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: aperture_64.c: corner case wrong
Message-Id: <20080602153033.2d1672f0.akpm@linux-foundation.org>
In-Reply-To: <20080526191730.GA18425@elf.ucw.cz>
References: <20080526191730.GA18425@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 21:17:30 +0200
Pavel Machek <pavel@suse.cz> wrote:

> 
> If 
> 
> fix == 0, aper_enabled == 1, gart_fix_e820 == 0
> 
> 	if (!fix && !aper_enabled)
> 		return;
> 
> 	if (gart_fix_e820 && !fix && aper_enabled) {
> 		if (e820_any_mapped(aper_base, aper_base + aper_size,
> 				    E820_RAM)) {
> 			/* reserve it, so we can reuse it in second
> kernel */
> 			printk(KERN_INFO "update e820 for GART\n");
> 			add_memory_region(aper_base, aper_size,
> E820_RESERVED);
> 			update_e820();
> 		}
> 		return;
> 	}
> 
> 	/* different nodes have different setting, disable them all atfirst*/
> 
> we'll fall back here and disable all the settings, even when they were
> all consistent.
> 
> What about this? (I hope it compiles...)
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> 
> diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> index 02f4dba..aa4876a 100644
> --- a/arch/x86/kernel/aperture_64.c
> +++ b/arch/x86/kernel/aperture_64.c
> @@ -344,14 +323,16 @@ out:
>  	if (gart_fix_e820 && !fix && aper_enabled) {
>  		if (!e820_all_mapped(aper_base, aper_base + aper_size,
>  				    E820_RESERVED)) {
>  			/* reserve it, so we can reuse it in second kernel */
>  			printk(KERN_INFO "update e820 for GART\n");
>  			add_memory_region(aper_base, aper_size, E820_RESERVED);
>  			update_e820();
>  		}
> -		return;
>  	}
>  
> +	if (!fix)
> +		return;
> +
>  	/* different nodes have different setting, disable them all at first*/
>  	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
>  		int bus;
> 

So what happened with this?  Thomas has merged an "x86: aperture_64.c:
cleanups" from yourself but it appears that half of this bugfix got
applied somewhere and the below part did not?


diff -puN arch/x86/kernel/aperture_64.c~aperture_64c-corner-case-wrong arch/x86/kernel/aperture_64.c
--- a/arch/x86/kernel/aperture_64.c~aperture_64c-corner-case-wrong
+++ a/arch/x86/kernel/aperture_64.c
@@ -331,6 +331,9 @@ out:
 		return;
 	}
 
+	if (!fix)
+		return;
+
 	/* different nodes have different setting, disable them all at first*/
 	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
 		int bus;
_

