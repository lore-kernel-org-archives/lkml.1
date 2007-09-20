Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbXITV5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbXITV5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbXITV45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:56:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56932 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbXITV45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:56:57 -0400
Date: Thu, 20 Sep 2007 14:55:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, miklos@szeredi.hu,
       Len Brown <len.brown@intel.com>,
       David Shaohua Li <shaohua.li@intel.com>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
 booted, USB-related WARNING
In-Reply-To: <alpine.LFD.0.999.0709201420231.16478@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0709201437310.16478@woody.linux-foundation.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> 
 <1190299841.3481.37.camel@chaos> <1190303393.3639.0.camel@chaos> 
 <200709202239.11070.rjw@sisk.pl> <1190322532.3085.42.camel@chaos>
 <alpine.LFD.0.999.0709201420231.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Sep 2007, Linus Torvalds wrote:
> 
> (Btw, the above commit message points to just my response with a testing 
> patch to the real email: the actual explanation of the INSANE ordering is 
> from Len Brown in
> 
> 	https://lists.linux-foundation.org/pipermail/linux-pm/2006-November/004161.html
> 
> and there Len claims that we *must* wake up CPU's early).

..and points to commit 1a38416cea8ac801ae8f261074721f35317613dc which in 
turn talks about http://bugzilla.kernel.org/show_bug.cgi?id=5651 

Howerver, it seems that bugzilla entry may just be bogus. It talks about 
"it appears that some firmware in the future may depend on that sequence 
for correction operation"

Len, Shaohua, what are the real issues here? 

It would indeed be nice if we could just take CPU's down early (while 
everything is working), and run the whole suspend code with just one CPU, 
rather than having to worry about the ordering between CPU and device 
takedown.

That said, at least with STR, the situation is:

 1) suspend_console
 2)   device_suspend(PMSG_SUSPEND)	  (==   ->suspend)
 3)     disable_nonboot_cpus()
 4)       device_power_down(PMSG_SUSPEND) (==   ->suspend_late)
 5)         pm_ops->enter()
 6)       device_power_up()		  (==   ->resume_early)
 7)     enable_nonboot_cpus()
 8)     pm_finish()
 9)   device_resume()		          (==   ->resume
10) resume_console

So if we agree that things like timers etc should *never* be suspended by 
the early suspend, and *always* use "suspend_late/resume_early", then at 
least STR should be ok.

And I think that's a damn reasonable thing to agree on: timers (and 
anything else that CPU shutdown/bringup could *possibly* care about) 
should be considered core enough that they had better be on the 
suspend_late/resume_early list.

Thomas, Rafael, can you verify that at least STR is ok in this respect?

		Linus
