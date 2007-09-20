Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbXITVmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbXITVmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbXITVmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:42:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40516 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbXITVl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:41:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when booted, USB-related WARNING
Date: Thu, 20 Sep 2007 23:54:41 +0200
User-Agent: KMail/1.9.5
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, miklos@szeredi.hu,
       Len Brown <len.brown@intel.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <1190322532.3085.42.camel@chaos> <alpine.LFD.0.999.0709201420231.16478@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709201420231.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709202354.42557.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 20 September 2007 23:35, Linus Torvalds wrote:
> 
> On Thu, 20 Sep 2007, Thomas Gleixner wrote:
> > 
> > In meantime I figured out what's happening. The ordering in
> > hibernate_snapshot() is wrong. It does:

Actually, this is incorrect.  Please read my reply to Thomas, just sent. 

> Hmm. This is close to the ordering we have in STR too.
> 
> I have some dim memory of there being some ACPI reason why it had to be 
> done that way.

Yes.  We're executing _INI from the CPU initialization code and that shouldn't
be done after _WAK, which is called from platform_finish().

> In fact, this was done in commit e3c7db621bed4afb8e231cb005057f2feb5db557, 
> long ago, by Rafael:
> 
>     As indicated in a recent thread on Linux-PM, it's necessary to call
>     pm_ops->finish() before devce_resume(), but enable_nonboot_cpus() has to be
>     called before pm_ops->finish() (cf.
>     http://lists.osdl.org/pipermail/linux-pm/2006-November/004164.html).  For
>     consistency, it seems reasonable to call disable_nonboot_cpus() after
>     device_suspend().
> 
>     This way the suspend code will remain symmetrical with respect to the resume
>     code and it may allow us to speed up things in the future by suspending and
>     resuming devices and/or saving the suspend image in many threads.
> 
>     The following series of patches reorders the suspend and resume code so that
>     nonboot CPUs are disabled after devices have been suspended and enabled before
>     the devices are resumed.  It also causes pm_ops->finish() to be called after
>     enable_nonboot_cpus() wherever necessary.
> 
> Hmm?
> 
> It's entirely possible that that commit was simply just buggy, and we 
> should indeed move the CPU down/up to be early/late - we've fixed other 
> ordering issues since that commit went in. But this whole area is very 
> murky.
> 
> (Btw, the above commit message points to just my response with a testing 
> patch to the real email: the actual explanation of the INSANE ordering is 
> from Len Brown in
> 
> 	https://lists.linux-foundation.org/pipermail/linux-pm/2006-November/004161.html
> 
> and there Len claims that we *must* wake up CPU's early).
> 
> I personally think that the whole ACPI ordering requirements are just 
> insane, but the point of this email is to point these different 
> requirements out, and hopefully we can get something that works for 
> everybody.

Sure.

Greetings,
Rafael
