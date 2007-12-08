Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbXLHWcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbXLHWcI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 17:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbXLHWb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 17:31:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41218 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbXLHWbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 17:31:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: bbpetkov@yahoo.de
Subject: Re: [RFC] swap image signature check upon resume
Date: Sat, 8 Dec 2007 23:50:33 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
References: <20071206211335.GA4923@gollum.tnic> <200712072119.09836.rjw@sisk.pl> <20071208113306.GA7573@gollum.tnic>
In-Reply-To: <20071208113306.GA7573@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712082350.33626.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 8 of December 2007, Borislav Petkov wrote:
> On Fri, Dec 07, 2007 at 09:19:09PM +0100, Rafael J. Wysocki wrote:
> 
> ...
> 
> > > > Well, there's a patchset in the current mainline that allows you to use
> > > > arbitrary (sufficiently new) kernel to load the image and then restore the
> > > > image kernel.  So, you can hibernate 2.6.24-rc3 and use 2.6.24-rc2 to restore
> > > > it, for example.
> > > > 
> > > > I'm going to do that for i386 too.
> > > right, this is d307c4a8e826c44f9633bd3f7e60d0491e7d885a (Hibernation: Arbitrary
> > > boot kernel support - generic code), i should've seen that. What's the status of
> > > those bits, from a quick scan it seems they need some rewiring (Kconfig, e.g.
> > > CONFIG_ARCH_HIBERNATION_HEADER etc..) and arch-specific save and restore
> > > functions?
> > 
> > No, this code is fully functional. :-)
> > 
> > The arch save and restore functions are in arch/x86/kernel/suspend_64.c .
> > 
> > As I said, i386 is not yet supported.
> 
> nice, holler if you need a tester when you have some prototypes ready. By the way,
> what do you do when the suspend image header mismatches and it is unsafe to continue booting?

If the image header doesn't match, we don't load it and return an error code,
which usually results in the boot kernel continuing to boot.

> Also, there's a freakishly long comment in suspend_64.c, might wanna shorten it:

Ah, OK.

I'll take your patch for 2.6.25, thanks.


> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> 
> diff --git a/arch/x86/kernel/suspend_64.c b/arch/x86/kernel/suspend_64.c
> index db284ef..0a23e5f 100644
> --- a/arch/x86/kernel/suspend_64.c
> +++ b/arch/x86/kernel/suspend_64.c
> @@ -118,7 +118,12 @@ void fix_processor_context(void)
>  	int cpu = smp_processor_id();
>  	struct tss_struct *t = &per_cpu(init_tss, cpu);
>  
> -	set_tss_desc(cpu,t);	/* This just modifies memory; should not be necessary. But... This is necessary, because 386 hardware has concept of busy TSS or some similar stupidity. */
> +	/*
> +	 * This just modifies memory; should not be necessary. But... This
> +	 * is necessary, because 386 hardware has concept of busy TSS or some
> +	 * similar stupidity.
> +	 */
> +	set_tss_desc(cpu,t);
>  
>  	cpu_gdt(cpu)[GDT_ENTRY_TSS].type = 9;
>  
> @@ -138,7 +143,6 @@ void fix_processor_context(void)
>                  loaddebug(&current->thread, 6);
>                  loaddebug(&current->thread, 7);
>  	}
> -
>  }
>  
>  #ifdef CONFIG_HIBERNATION
> 
