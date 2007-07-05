Return-Path: <linux-kernel-owner+w=401wt.eu-S1760966AbXGEMMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbXGEMMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 08:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbXGEMMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 08:12:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2319 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756033AbXGEMMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 08:12:17 -0400
Date: Thu, 5 Jul 2007 12:12:03 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Andi Kleen <andi@firstfloor.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-ID: <20070705121203.GB5167@ucw.cz>
References: <200706251434.43863.jesse.barnes@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706251434.43863.jesse.barnes@intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On some machines, buggy BIOSes don't properly setup WB MTRRs to
> cover all available RAM, meaning the last few megs (or even gigs)
> of memory will be marked uncached.  Since Linux tends to allocate
> from high memory addresses first, this causes the machine to be
> unusably slow as soon as the kernel starts really using memory
> (i.e. right around init time).
> 
> This patch works around the problem by scanning the MTRRs at
> boot and figuring out whether the current end_pfn value (setup
> by early e820 code) goes beyond the highest WB MTRR range, and
> if so, trimming it to match.  A fairly obnoxious KERN_WARNING
> is printed too, letting the user know that not all of their
> memory is available due to a likely BIOS bug.
> 
> Something similar could be done on i386 if needed, but the boot
> ordering would be slightly different, since the MTRR code on i386
> depends on the boot_cpu_data structure being setup.
> 
> This patch fixes a bug in the last patch that caused the code to
> run on non-Intel machines (AMD machines apparently don't need it
> and it's untested on other non-Intel machines, so best keep it
> off).
> 
> akpm -- this one should replace all the mtrr patches currently
> in your tree.
> 
> Yinghai, maybe you can test this on one of your AMD machines to
> make sure I got the CPU code right?

> +	if ((highest_addr >> PAGE_SHIFT) != end_pfn) {
> +		printk(KERN_WARNING "***************\n");
> +		printk(KERN_WARNING "**** WARNING: likely BIOS bug\n");
> +		printk(KERN_WARNING "**** MTRRs don't cover all of "
> +		       "memory, trimmed %ld pages\n", end_pfn -
> +		       (highest_addr >> PAGE_SHIFT));
> +		printk(KERN_WARNING "***************\n");
> +		end_pfn = highest_addr >> PAGE_SHIFT;

I'd say using that many stars for KERN_WARNING printk is sign of
mental illness or something...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
