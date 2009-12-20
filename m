Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbZLTNgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbZLTNgp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 08:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZLTNgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 08:36:44 -0500
Received: from mx01.qsc.de ([213.148.129.14]:51606 "EHLO mx01.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbZLTNgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 08:36:43 -0500
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Dec 2009 08:36:43 EST
Message-ID: <4B2E264E.4090805@googlemail.com>
Date: Sun, 20 Dec 2009 14:27:42 +0100
From: =?ISO-8859-1?Q?Holger_Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [stable] Regression in 2.6.32.2: segfault on halt
References: <pan.2009.12.19.15.10.48.851500@googlemail.com> <20091220054847.GF32739@1wt.eu> <4B2E10C6.7050304@googlemail.com> <20091220130616.GC9719@1wt.eu>
In-Reply-To: <20091220130616.GC9719@1wt.eu>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> Hi Holger,
> 
> On Sun, Dec 20, 2009 at 12:55:50PM +0100, Holger Hoffstätte wrote:
>> Willy Tarreau wrote:
>>> On Sat, Dec 19, 2009 at 04:10:49PM +0100, Holger Hoffstaette wrote:
>>>> After updating to 2.6.32.2 last night (using same config from .32.1) I
>>>> noticed that "halt" now trips during shutdown and won't power the
>>>> machine down any longer. This happens reproducibly on two completely
>>>> different machines, so it looks like a generic problem and regression,
>>>> since it did not happen in .32.1. Note that "reboot" works as expected -
>>>> only "halt" crashes.
>>> I have it working fine here. So your config helps to reproduce the issue.
>>> Care to post it ?
>> Attached, if it matters. However I managed to find some time with a spare
>> machine and always wanted to try bisect, so that's what I did - apparently
>> successfully:
>>
>> root>git bisect bad
>> 37ed2d7007a65874850f3e357c095806c3756330 is the first bad commit
>> commit 37ed2d7007a65874850f3e357c095806c3756330
>> Author: Mike Galbraith <efault@gmx.de>
>> Date:   Wed Nov 4 17:53:50 2009 +0100
>>
>>     sched: Rate-limit newidle
> 
> Interesting, because I saw this one too while digging the patch preview
> for the word "migration" which appeared in your trace. But these changes
> did not look suspicious (no obvious invalid pointer dereference for
> instance).
> 
> CCing Mike who may have an idea.

Took me some time (still learning git - I usually use hg) but I just
managed to fix it by reverting not the bisected revision (won't compile
any longer), but the follow-up "cleanup & fix":

>From 35c1ee3e78766d5666f418af638def9c67e63ecb Mon Sep 17 00:00:00 2001
From: Mike Galbraith <efault@gmx.de>
Date: Tue, 10 Nov 2009 03:50:02 +0100
Subject: [PATCH] sched: Fix and clean up rate-limit newidle code

commit eae0c9dfb534cb3449888b9601228efa6480fdb5 upstream.

Commit 1b9508f, "Rate-limit newidle" has been confirmed to fix
the netperf UDP loopback regression reported by Alex Shi.

This is a cleanup and a fix:

 - moved to a more out of the way spot

 - fix to ensure that balancing doesn't try to balance
   runqueues which haven't gone online yet, which can
   mess up CPU enumeration during boot.

Reported-by: Alex Shi <alex.shi@intel.com>
Reported-by: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1257821402.5648.17.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

aka:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=commit;h=35c1ee3e78766d5666f418af638def9c67e63ecb

Reverting this from a clean 32.2 tree results in a kernel with newidle
fix, but still working halt/reboot. The only difference between this and
the bisected one is the additional change in cpumask handling.

That was more fun than expected :)

Holger
