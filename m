Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYCNUv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYCNUv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYCNUvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:51:49 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:27367 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYCNUvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:51:48 -0400
X-Spam-Flag: NO
X-Spam-Score: -6.389
Message-ID: <47DAE55C.3080506@tremplin-utc.net>
Date: Fri, 14 Mar 2008 21:51:40 +0100
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.12) Gecko/20080305 Mandriva/2.0.0.12-3mdv2008.1 (2008.1) Thunderbird/2.0.0.12 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Tilman Schmidt <tilman@imap.cc>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Len Brown <len.brown@intel.com>, Linus Torvalds <torvalds@osdl.org>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>	 <47D86D43.2060108@imap.cc> <1205441216.4971.65.camel@nimitz.home.sr71.net>	 <47D9C853.3040701@imap.cc> <1205517802.12763.18.camel@nimitz.home.sr71.net> <1205525184.12763.32.camel@nimitz.home.sr71.net>
In-Reply-To: <1205525184.12763.32.camel@nimitz.home.sr71.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> For those of you new to this thread, here's the initial report:
> 
> 	http://marc.info/?t=120536629300001&r=1&w=2
> 
> I'm pretty sure the root cause of this bug is this commit:
> 
> 	ACPI: basic initramfs DSDT override support
> 	71fc47a9adf8ee89e5c96a47222915c5485ac437
> 
> Which did this hunk:
>         
>         @@ -648,6 +654,7 @@ asmlinkage void __init start_kernel(void)
>          
>                 check_bugs();
>          
>         +       populate_rootfs(); /* For DSDT override from initramfs
>         */
>                 acpi_early_init(); /* before LAPIC and SMP init */
>          
>                 /* Do the rest non-__init'ed, we're now alive */
>         	rest_init();
>         ...
> 
> Well, the fs initcalls aren't actually done until during rest_init(),
> including initializing my mnt_writer[] spinlocks.  I guess I could
> statically initialize them, but that's not the root of the problem, it's
> just the canary in the coal mine.
> 
> I think the populate_rootfs() call is completely bogus and certainly
> can't be done before the initcalls.  But, I don't immediately have any
> better suggestions for you.  Can you delay the ACPI init until after the
> fs initcalls are made?
Hi,

I have made a patch to fix problems with regards to early userspace 
calls (http://lkml.org/lkml/2008/2/23/306) but I don't think it will 
solve this bug. So far I had not heard of problems with filesystem 
initialization.

I'm not sure it would be possible to delay acpi_early_init() until after 
the fs initcalls. Maybe Len knows. How about trying the opposite: what 
is the barely minimum to initialize so that the rootfs can be populated 
and read? Would it be possible to have a kind of 
early_mnt_writer_initialize() that would do that?

See you,
Eric
