Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbZEKHY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbZEKHY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 03:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbZEKHYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 03:24:09 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:39805 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbZEKHYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 03:24:08 -0400
Date: Mon, 11 May 2009 09:23:57 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       michael@araneidae.co.uk
Subject: Re: /proc/uptime idle counter remains at 0
Message-ID: <20090511092357.482ae8e9@skybase>
In-Reply-To: <alpine.LSU.2.00.0905110237310.17675@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr>
	<20090510191229.71f43f3c@skybase>
	<alpine.LSU.2.00.0905110237310.17675@fbirervta.pbzchgretzou.qr>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 02:46:03 +0200 (CEST)
Jan Engelhardt <jengelh@medozas.de> wrote:

> 
> On Sunday 2009-05-10 19:12, Martin Schwidefsky wrote:
> >> 
> >> So, were the updates to uptime.c missed, or do we now live on with
> >> /proc/uptime constantly having 0?
> >
> >The second paragraph from git commit 79741dd tells you more about this:
> >
> >In addition idle time is no more added to the stime of the idle
> >process. This field now contains the system time of the idle process as
> >it should be. On systems without VIRT_CPU_ACCOUNTING this will always
> >be zero as every tick that occurs while idle is running will be
> >accounted as idle time.
> >
> >The point is the semantics of the stime field for the idle process. The
> >stime field used to contain the real system time (cpu really did
> >something) of the idle process plus the idle time (cpu is stopped).
> >After the change the field only contains the real system time. Which is
> >ihmo much more useful, no?
> 
> Actually doing something while idle would then probably be limited to
> CPUs that have no HLT instruction/state, like ancient i386, right?
> 
> Are the semantics of /proc/uptime (more-or-less standardsly) defined
> somewhere, e.g. written down into a manual page?

Not really, the second field is the stime of the idle process for the
boot cpu. This is a mixture of the time spent in idle doing work and
waiting on hlt. In an smp system with multiple task_structs with stime
fields it makes even less sense. The field is ill defined.
 
> Nevertheless, one could argue that, hypothetically, some people or
> their scripts interpreted the second field as the time that there was
> no process running; sort of a minimalistic way to tell the average
> system use in % beyond the 1/5/15-loadavg counters. So the field could be
> kept, or now that 2nd place displays 0.00, be re-added. Depending on
> how “standardized” /proc/uptime's format is, the 0.00 could either
> stay as second position or move to third position.
> 
> > cat /proc/uptime
> 496468.50 432205.41
> > bc -l <<<'100-(432205.41*100/496468.50)' 
> 12.94 (%)

That would work on a uni-processor. On an smp with cpu hotplug you'll
get interesting results..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

