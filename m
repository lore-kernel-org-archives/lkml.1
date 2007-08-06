Return-Path: <linux-kernel-owner+w=401wt.eu-S1765321AbXHFRdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765321AbXHFRdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbXHFRd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:33:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60020 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664AbXHFRd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:33:28 -0400
Date: Mon, 6 Aug 2007 10:33:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
Message-Id: <20070806103317.5688d6df.akpm@linux-foundation.org>
In-Reply-To: <46B72E2E.5040906@gmx.net>
References: <200708031903.10063.jimis@gmx.net>
	<200708051903.12414.jimis@gmx.net>
	<20070805182811.a8992126.akpm@linux-foundation.org>
	<46B72E2E.5040906@gmx.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Aug 2007 16:20:30 +0200 Dimitrios Apostolou <jimis@gmx.net> wrote:

> Andrew Morton wrote:
> > On Sun, 5 Aug 2007 19:03:12 +0300 Dimitrios Apostolou <jimis@gmx.net> wrote:
> > 
> >> was my report so complicated?
> > 
> > We're bad.
> > 
> > Seems that your context switch rate when running two instances of
> > badblocks against two different disks went batshit insane.  It doesn't
> > happen here.
> > 
> > Please capture the `vmstat 1' output while running the problematic
> > workload.
> > 
> > The oom-killing could have been unrelated to the CPU load problem.  iirc
> > badblocks uses a lot of memory, so it might have been genuine.  Keep an eye
> > on the /proc/meminfo output and send the kernel dmesg output from the
> > oom-killing event.
> 
> Please see the attached files. Unfortunately I don't see any useful info 
> in them:
> 	*_before: before running any badblocks process
> 	*_while: while running badblocks process, but without any cron job 
> having kicked in
> 	*_bad: 5 minutes later that some cron jobs kicked in
> 
> About the OOM killer, indeed I believe that it is unrelated. It started 
> killing after about 2 days, that hundreds of processes were stuck as 
> running and taking up memory, so I suppose the 256 MB RAM were truly 
> filled. I just mentioned it because its behaviour is completely 
> non-helpful. It doesn't touch the badblocks process, it rarely touches 
> the stuck as running cron jobs, but it kills other irrelevant processes. 
> If you still want the killing logs, tell me and I'll search for them.

ah.  Your context-switch rate during the dual-badblocks run is not high at
all.

I suspect I was fooled by the oprofile output, which showed tremendous
amounts of load in schedule() and switch_to().  The percentages which
opreport shows are the percentage of non-halted CPU time.  So if you have a
function in the kernel which is using 1% of the total CPU, and the CPU is
halted for 95% of the time, it appears that the function is taking 20% of
CPU!

The fix for that is to boot with the "idle=poll" boot parameter, to make
the CPU spin when it has nothing else to do.

I'm suspecting that your machine is just stuck in D state waiting for disk.
 Did we have a sysrq-T trace? 
