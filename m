Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbXITXhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbXITXhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 19:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXITXhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 19:37:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:47680 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbXITXg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 19:36:59 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when booted, USB-related WARNING
Date: Thu, 20 Sep 2007 19:35:03 -0400
User-Agent: KMail/1.9.5
Cc: Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, miklos@szeredi.hu,
       Len Brown <len.brown@intel.com>,
       David Shaohua Li <shaohua.li@intel.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <alpine.LFD.0.999.0709201420231.16478@woody.linux-foundation.org> <alpine.LFD.0.999.0709201437310.16478@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709201437310.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201935.04400.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007 17:55, Linus Torvalds wrote:
> 
> On Thu, 20 Sep 2007, Linus Torvalds wrote:
> > 
> > (Btw, the above commit message points to just my response with a testing 
> > patch to the real email: the actual explanation of the INSANE ordering is 
> > from Len Brown in
> > 
> > 	https://lists.linux-foundation.org/pipermail/linux-pm/2006-November/004161.html
> > 
> > and there Len claims that we *must* wake up CPU's early).
> 
> ..and points to commit 1a38416cea8ac801ae8f261074721f35317613dc which in 
> turn talks about http://bugzilla.kernel.org/show_bug.cgi?id=5651 
> 
> Howerver, it seems that bugzilla entry may just be bogus. It talks about 
> "it appears that some firmware in the future may depend on that sequence 
> for correction operation"
> 
> Len, Shaohua, what are the real issues here? 

Intel's reference BIOS for Core Duo performs some re-initialization
in _WAK that will get blow away if INIT follows _WAK.
IIR, it is related to re-initializing the thermal sensors.
I opened bug 5651 when the BIOS team informed me of this issue.

Yes, bringing a processor offline and then online again w/o
an intervening suspend or reset would not evaluate _WAK,
and thus may still run into the issue.

I don't know if this is a widespread issue and a commonly
used BIOS hook, or if it is specific to certain processors.

-Len

> It would indeed be nice if we could just take CPU's down early (while 
> everything is working), and run the whole suspend code with just one CPU, 
> rather than having to worry about the ordering between CPU and device 
> takedown.
> 
> That said, at least with STR, the situation is:
> 
>  1) suspend_console
>  2)   device_suspend(PMSG_SUSPEND)	  (==   ->suspend)
>  3)     disable_nonboot_cpus()
>  4)       device_power_down(PMSG_SUSPEND) (==   ->suspend_late)
>  5)         pm_ops->enter()
>  6)       device_power_up()		  (==   ->resume_early)
>  7)     enable_nonboot_cpus()
>  8)     pm_finish()
>  9)   device_resume()		          (==   ->resume
> 10) resume_console
> 
> So if we agree that things like timers etc should *never* be suspended by 
> the early suspend, and *always* use "suspend_late/resume_early", then at 
> least STR should be ok.
> 
> And I think that's a damn reasonable thing to agree on: timers (and 
> anything else that CPU shutdown/bringup could *possibly* care about) 
> should be considered core enough that they had better be on the 
> suspend_late/resume_early list.
> 
> Thomas, Rafael, can you verify that at least STR is ok in this respect?
> 
> 		Linus
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
