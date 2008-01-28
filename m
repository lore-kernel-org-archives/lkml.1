Return-Path: <linux-kernel-owner+w=401wt.eu-S1759613AbYA1Riv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbYA1Riv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYA1Rim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:38:42 -0500
Received: from ns.suse.de ([195.135.220.2]:42249 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbYA1Ril (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:38:41 -0500
Date: Mon, 28 Jan 2008 09:37:06 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jacob Shin <jacob.shin@amd.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 2/5] x86: fix runtime error in
	arch/x86/kernel/cpu/mcheck/mce_amd_64.c
Message-ID: <20080128173706.GA17495@suse.de>
References: <20080127233751.GA4524@kroah.com> <1201477122-4541-2-git-send-email-gregkh@suse.de> <20080128122434.GA24757@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128122434.GA24757@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 01:24:34PM +0100, Ingo Molnar wrote:
> 
> * Greg Kroah-Hartman <gregkh@suse.de> wrote:
> 
> > This problem is due to the kobject rework recently done in this file.
> > 
> > The mce_amd_64.c code uses some wierd forward calls to back out of the 
> > recursive way the code creates kobjects.  Because of this, we need to 
> > verify that we have really created a kobject before calling 
> > kobject_uevent().
> > 
> > Many thanks to Yinghai Lu <yhlu.kernel@gmail.com> for reporting the 
> > problem and testing.
> 
> > -	kobject_uevent(&b->kobj, KOBJ_ADD);
> > +	if (b)
> > +		kobject_uevent(&b->kobj, KOBJ_ADD);
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> and please let me insert a minor kobject rant here: i do think it's way 
> too hard to figure out relatively minor-looking kobj bugs like this. It 
> took serious dedication from Yinghai Lu and yourself to nail this down, 
> and we wont always have that much luck in the future.
> 
> CONFIG_DEBUG_KOBJECT is way too feeble and does not actually attempt to 
> catch bugs like this. The effects of the bug were quite serious, and 
> this hasnt been the first time such hard-to-find kobj bugs occured - 
> every one of those incidents was in essence unnecessary.
> 
> Couldnt DEBUG_KOBJECT do better than this - just like we have list 
> debugging, PAGEALLOC and all the other debug checks?

In fact, it is exactly what enabled me to catch this bug.  The fact that
the kobject_uevent() debugging statment did not print out anything, and
oopsed, showed me that this was a simpler problem than I was originally
thinking it was.

Problem was we were passing in 0x18 for a kobject pointer to the
kobject_uevent() function.  Even checking for NULL there would not have
caught this.

I have added a lot more "robustness" checks to the kobject core now, see
the lkml messages about the maple bus for examples of where it is
catching real problems already.  And the kobject debugging code is now
"unified", printing out everything in a standard, easy to understand
manner.

I really don't want to get into adding a "magic value" to a kobject
field, and then checking it for every call, that too would have died on
this kind of bug, just like the debug printk did :)

But if there's anything that you think I can add to make it easier to
understand, please let me know.

The root problem of this bug was us using a goto to call forward into a
major code block within a function.  Not just using a goto for error
cleanup, like the kernel code "normally" does.  Because of that, I
totally missed this code path when reading the function many times.
It's nasty code complexity for no reason at all that causes more
problems than is needed, combined with a total lack of documentation for
how this kobject userspace interface is supposed to be used, that needs
to be fixed.

thanks,

greg k-h
