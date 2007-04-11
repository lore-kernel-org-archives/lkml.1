Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbXDKNLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbXDKNLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 09:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbXDKNLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 09:11:35 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:65498 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbXDKNLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 09:11:35 -0400
Date: Wed, 11 Apr 2007 06:09:39 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <ak@suse.de>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, lenb@kernel.org,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: 2.6.21-rc6-mm1
Message-ID: <20070411130939.GA24875@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <653FFBB4508B9042B5D43DC9E18836F539ADFB@scsmsx415.amr.corp.intel.com> <20070411001513.GA2975@linux-os.sc.intel.com> <20070411052007.GA24056@frankl.hpl.hp.com> <200704111239.06259.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704111239.06259.ak@suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Wed, Apr 11, 2007 at 12:39:05PM +0200, Andi Kleen wrote:
> 
> > The next kernel patch for Perfmon will not make use of the idle notification
> > anymore on any platform.
> 
> What do you use instead? 
> 
Nothing. I was using the idle notifier as a way to stop monitoring on entry and
restart on exit. That way you would only measure useful execution.

But there are issues with this approach. In particular, there are some events that
keep on counting during idle (in halted state). And you want to have those counting,
for instance if this is related to bus or caches. For cycle event, the x86 PMU
has CPU_CLK_UNHALTED, and as its name indicates it does not count during halted state,
the firmware shuts it off.

So if you do nothing, you leave it to the firmware to turn on/off certain counters
based on the event they measure. That is the best option. You cannot have
CPU_CLK_UNHALTED working in halted state.

So my point is that you cannot use the PMU to account for wall-clock time when you
go in halted state. Yet, you could use the idle notifier to compensate for it by
recording let's say TSC prior to entry and computing delta on exit. But then I am
not sure what you would do with it given that other events may or may not have
counted during that time, making scaling harder to do.

Once solution, implemented by Itanium Montecito processor, is to have a PMU event
that counts cycles spent in halted state. 

> I've been actually thinking to add idle notifier support to oprofile to correct
> for the "perfctr doesn't tick in idle" issue which makes numbers not add up to 100%. 
> A lot of people are currently running idle=poll to work around this and that is very
> wasteful.
> 
I agree but I believe that this is the only solution at this point.

-- 
-Stephane
