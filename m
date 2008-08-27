Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbYH0V2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbYH0V2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYH0V2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:28:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:34828 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbYH0V2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:28:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ih1+A3eADEIq2y4fLrs4BZQi6d2sDGSSeQdtgSvYhBaL5HOKJxsLOCnLk3uSKb0nJj
         06N0mlKY9ahUGM2shIVl3g8Hh+aZYHSC7CicFWOvNT5Xjm1DiFM05Z9C6nKf4FJDBx01
         BAQoTCXqU6gPQl6XHpAKcg7z5hOPyN4Wvpkuk=
Date: Wed, 27 Aug 2008 23:27:25 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: disable tracing for suspend to ram
Message-ID: <20080827212719.GA5531@joi>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <20080822104610.GA3482@elf.ucw.cz> <alpine.DEB.1.10.0808221632410.14231@gandalf.stny.rr.com> <200808222252.12547.rjw@sisk.pl> <alpine.DEB.1.10.0808221651350.15941@gandalf.stny.rr.com> <alpine.DEB.1.10.0808270844500.7871@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808270844500.7871@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 09:14:40AM -0400, Steven Rostedt wrote:
> 
> I've been painstakingly debugging the issue with suspend to ram and 
> ftraced. The 2.6.28 code does not have this issue, but since the mcount 
> recording is not going to be in 27, this must be solved for the ftrace 
> daemon version.
> 
> The resume from suspend to ram would reboot because it was triple 
> faulting. Debugging further, I found that calling the mcount function 
> itself was not an issue, but it would fault when it incremented 
> preempt_count. preempt_count is on the tasks info structure that is on the 
> low memory address of the task's stack.  For some reason, it could not 
> write to it. Resuming out of suspend to ram does quite a lot of funny 
> tricks to get to work, so it is not surprising at all that simply doing a 
> preempt_disable() would cause a fault.
> 
> Thanks to Rafael for suggesting to add a "while (1);" to find the place in 
> resuming that is causing the fault. I would place the loop somewhere in 
> the code, compile and reboot and see if it would either reboot (hit the 
> fault) or simply hang (hit the loop).  Doing this over and over again, I 
> narrowed it down that it was happening in enable_nonboot_cpus.
> 
> At this point, I found that it is easier to simply disable tracing around 
> the suspend code, instead of searching for the particular function that 
> can not handle doing a preempt_disable.
> 
> This patch disables the tracer as it suspends and reenables it on resume.
> 
> I tested this patch on my Laptop, and it can resume fine with the patch.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

You can add my:
Tested-by: Marcin Slusarz <marcin.slusarz@gmail.com>

Thanks!

Marcin
