Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbZHaTbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbZHaTbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZHaTbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:31:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53670 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbZHaTbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:31:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: suspend race -next regression [Was: Power: fix suspend vt regression]
Date: Mon, 31 Aug 2009 21:32:10 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
References: <1249980093-16319-1-git-send-email-jirislaby@gmail.com> <4A81E073.5080703@gmail.com> <4A9B9C1C.9020506@gmail.com>
In-Reply-To: <4A9B9C1C.9020506@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908312132.10904.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 August 2009, Jiri Slaby wrote:
> On 08/11/2009 11:19 PM, Jiri Slaby wrote:
> > However there is still a race or something. Sometimes the suspend goes
> > through, sometimes it doesn't. I will investigate this further.
> 
> Hmm, this took a loong time to track down a bit. Code instrumentation by
> outb(XX, 0x80) usually caused the issue to disappear.
> 
> However I found out that it's caused by might_sleep() calls in
> flush_workqueue() and flush_cpu_workqueue(). I.e. it looks like there is
> a task which deadlocks/spins forever. If we won't reschedule to it,
> suspend proceeds.
> 
> I replaced the latter might_sleep() by show_state() and removed
> refrigerated tasks afterwards. The thing is that I don't know if the
> prank task is there. I need a scheduler to store "next" task pid or
> whatever to see what it picked as "next" and so what will run due to
> might_sched(). I can then show it on port 80 display and read it when
> the hangup occurs.
> 
> Depending on which might_sleep(), either flush_workqueue() never (well,
> at least in next 5 minutes) proceeds to for_each_cpu() or
> wait_for_completion() in flush_cpu_workqueue() never returns.
> 
> It's a regression against some -rc1 based -next tree. Bisection
> impossible, suspend needs to be run even 7 times before it occurs. Maybe
> a s/might_sleep/yield/ could make it happen earlier (going to try)?

If /sys/class/rtc/rtc0/wakealarm works on this box, you can use it to trigger
resume in a loop.

Basically, you can do

# echo 0 > /sys/class/rtc/rtc0/wakealarm
# date +%s -d "+60 seconds" > /sys/class/rtc/rtc0/wakealarm

then go to suspend and it will resume the box in ~1 minute.

Thanks,
Rafael
