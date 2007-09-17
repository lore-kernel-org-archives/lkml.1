Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbXIQUFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbXIQUFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbXIQUFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:05:23 -0400
Received: from xenotime.net ([66.160.160.81]:42584 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753286AbXIQUFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:05:22 -0400
Date: Mon, 17 Sep 2007 13:05:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: crashme fault
Message-Id: <20070917130520.9939ae89.rdunlap@xenotime.net>
In-Reply-To: <alpine.LFD.0.999.0709170742540.16478@woody.linux-foundation.org>
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com>
	<alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org>
	<20070915183412.GA14501@one.firstfloor.org>
	<46EC2702.3090000@oracle.com>
	<alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org>
	<alpine.LFD.0.999.0709151508590.16478@woody.linux-foundation.org>
	<alpine.LFD.0.999.0709151542340.16478@woody.linux-foundation.org>
	<46EC6F2A.5090008@oracle.com>
	<alpine.LFD.0.999.0709151727180.16478@woody.linux-foundation.org>
	<20070916094001.d87ed0f0.randy.dunlap@oracle.com>
	<alpine.LFD.0.999.0709161004080.16478@woody.linux-foundation.org>
	<alpine.LFD.0.999.0709161055070.16478@woody.linux-foundation.org>
	<20070916220643.bea3e44f.randy.dunlap@oracle.com>
	<alpine.LFD.0.999.0709162224580.16478@woody.linux-foundation.org>
	<46EE8F63.3070108@oracle.com>
	<alpine.LFD.0.999.0709170742540.16478@woody.linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 07:53:50 -0700 (PDT) Linus Torvalds wrote:

> On Mon, 17 Sep 2007, Randy Dunlap wrote:
> > 
> > OK, I haven't done the microcode update yet.  I ran crashme overnight
> > with your newer patch and it crashed:
> 
> Well, duh.
> 
> That's because I forgot to do the "error_code & PF_USER" => 
> "user_mode_vm(regs)" thing in the most common case - the 
> "bad_area_nosemaphore" if-statement.
> 
> But thinking more about it, it's actually just easier and more 
> straightforward to just take the same approach that my original hack did, 
> namely to just set PF_USER if the register state implies it was in user  
> mode.
> 
> So ignore that patch. You're better off with my original one that also 
> gave debugging info, and if we decide that this really looks like a CPU 
> buglet, the patch to actually commit would be a simplified version of that 
> (appended, just FYI).

[switched email address due to some unknown problems]


Reverted that patch.  Loaded new microcode update file.
Ran test for 3 hours without a fault.

It all seems rather inconclusive to me, still, the new patch (below)
makes sense.

> Also, I changed my mind on the microcode update - if you have a newer 
> microcode, go ahead and try it, because if that fixes the issue, then we 
> can really just close this as a "unimportant CPU bug" with the patch 
> below.
> 
> 		Linus
> 
> ---
>  arch/x86_64/mm/fault.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
> index 327c9f2..54816ad 100644
> --- a/arch/x86_64/mm/fault.c
> +++ b/arch/x86_64/mm/fault.c
> @@ -374,6 +374,13 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
>  	if (unlikely(in_atomic() || !mm))
>  		goto bad_area_nosemaphore;
>  
> +	/*
> +	 * User-mode registers count as a user access even for any
> +	 * potential system fault or CPU buglet.
> +	 */
> +	if (user_mode_vm(regs))
> +		error_code |= PF_USER;
> +
>   again:
>  	/* When running in the kernel we expect faults to occur only to
>  	 * addresses in user space.  All other faults represent errors in the
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
