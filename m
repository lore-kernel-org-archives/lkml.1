Return-Path: <linux-kernel-owner+w=401wt.eu-S1030363AbXBZRr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030363AbXBZRr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030382AbXBZRr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:47:56 -0500
Received: from gundega.hpl.hp.com ([192.6.19.190]:56211 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030381AbXBZRrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:47:53 -0500
Date: Mon, 26 Feb 2007 09:45:53 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Jiri Slaby <jirislaby@gmail.com>,
       Uwe Bugla <uwe.bugla@gmx.de>, akpm@linux-foundation.org, bunk@stusta.de,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Stephane Eranian <eranian@hpl.hp.com>, venkatesh.pallipadi@intel.com
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot be mounted without hanging up the whole system
Message-ID: <20070226174553.GD19403@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070224175424.176030@gmx.net> <45E2B88B.1090706@gmail.com> <45E2F8C5.3080905@gmail.com> <Pine.LNX.4.64.0702260741040.12485@woody.linux-foundation.org> <20070226163429.GL26583@kvack.org> <Pine.LNX.4.64.0702260906540.12485@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702260906540.12485@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Mon, Feb 26, 2007 at 09:10:22AM -0800, Linus Torvalds wrote:
> > 
> > Side note: this patch adds several function calls (4), several additional 
> > L1 cache touches and a generally inefficient code path to *every single 
> > interrupt that exits from the idle poll*, not to mention the extra (useless, 
> > as it doesn't get used on 99.9% of deployed systems) function call and cache 
> > touches to every single interrupt.
> 
> It is in fact possible that the floppy failure might just be from some 
> timing-dependent thing, and the slowdown itself is the problem.
> 
> Although I do find that a bit unlikely, since machines these days are 
> about a million times faster than they used to be, so even if it's 
> unnecessarily slow, it shouldn't be noticeable for a floppy drive.
> 
I don't know enough about the floppy driver to comment on this but I would
agree with you here.

> >  Keep in mind that systems acting as routers will often be sitting in 
> > the idle loop when processing interrupts.  At the very least this 
> > overhead (which is noticable on profiles) should be configurable.  I 
> > don't think that my 586 class embedded routers really need this crap to 
> > be going into the kernel.
> 
> I'm inclined to agree. Considering that the patch is known to cause 
> problems, and that it's apparently broken on x86 *anyway* (the 
> idle_notifier_register function isn't even exported), and considering that 
> it's clearly bad for interrupt performance and could have been done a lot 
> better, I would suggest just ripping it all out.
> 
The notifier was exported initially but then some people argued I should take
this out because there was no actual users just yet.

As for the performance impact, for non idle tasks, this translates into an
if() return. For the idle, if this is not used, you have a bitop + call
to notifier call chain with empty chain.

With perfmon, we would like to exclude useless kernel execution from being
monitored. That means poll_idle(), default_idle(), mwait_idle(). Yet we
want to capture interrupt handler execution by the idle thread because this
represents useful execution.

The notifier is one mechanism whereby we can dynamically register a callback
to start/stop monitoring to achieve our goal. One could argue the mechanism
is heavy for the usage we make of it. We could certainly add two more
perfmon hooks in the idle code and we would save the atomic call chain notifier
altogether.

Another solution would be to just rely on firmware to stop/restart performance
counters when using mwait or hlt. But we would need something for poll_idle().
An issue with this solution is that it depends on the processor architecture or
implementation, some may not always stop the counters. Yet, we would like to
provide for 'useless execution exclusion' at the interface level for all
architectures. Explicit code may be the only way to provide such guarantee.

If you think there maybe a better way to do this, I am certainly open to suggestions.

Thanks.

-- 
-Stephane
