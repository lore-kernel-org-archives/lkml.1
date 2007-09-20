Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbXITVhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbXITVhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbXITVg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:36:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33224 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994AbXITVg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:36:57 -0400
Date: Thu, 20 Sep 2007 14:35:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, miklos@szeredi.hu,
       Len Brown <len.brown@intel.com>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
 booted, USB-related WARNING
In-Reply-To: <1190322532.3085.42.camel@chaos>
Message-ID: <alpine.LFD.0.999.0709201420231.16478@woody.linux-foundation.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> 
 <1190299841.3481.37.camel@chaos> <1190303393.3639.0.camel@chaos> 
 <200709202239.11070.rjw@sisk.pl> <1190322532.3085.42.camel@chaos>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Sep 2007, Thomas Gleixner wrote:
> 
> In meantime I figured out what's happening. The ordering in
> hibernate_snapshot() is wrong. It does:

Hmm. This is close to the ordering we have in STR too.

I have some dim memory of there being some ACPI reason why it had to be 
done that way.

In fact, this was done in commit e3c7db621bed4afb8e231cb005057f2feb5db557, 
long ago, by Rafael:

    As indicated in a recent thread on Linux-PM, it's necessary to call
    pm_ops->finish() before devce_resume(), but enable_nonboot_cpus() has to be
    called before pm_ops->finish() (cf.
    http://lists.osdl.org/pipermail/linux-pm/2006-November/004164.html).  For
    consistency, it seems reasonable to call disable_nonboot_cpus() after
    device_suspend().

    This way the suspend code will remain symmetrical with respect to the resume
    code and it may allow us to speed up things in the future by suspending and
    resuming devices and/or saving the suspend image in many threads.

    The following series of patches reorders the suspend and resume code so that
    nonboot CPUs are disabled after devices have been suspended and enabled before
    the devices are resumed.  It also causes pm_ops->finish() to be called after
    enable_nonboot_cpus() wherever necessary.

Hmm?

It's entirely possible that that commit was simply just buggy, and we 
should indeed move the CPU down/up to be early/late - we've fixed other 
ordering issues since that commit went in. But this whole area is very 
murky.

(Btw, the above commit message points to just my response with a testing 
patch to the real email: the actual explanation of the INSANE ordering is 
from Len Brown in

	https://lists.linux-foundation.org/pipermail/linux-pm/2006-November/004161.html

and there Len claims that we *must* wake up CPU's early).

I personally think that the whole ACPI ordering requirements are just 
insane, but the point of this email is to point these different 
requirements out, and hopefully we can get something that works for 
everybody.

Len added to Cc.

Len? Thomas wants to call 'disable_nonboot_cpus()' early, and 
'enable_nonboot_cpus()' late. Can you explain why that is wrong?

			Linus
