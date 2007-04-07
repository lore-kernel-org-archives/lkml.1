Return-Path: <linux-kernel-owner+w=401wt.eu-S933617AbXDGRo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbXDGRo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966194AbXDGRo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:44:57 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:49431 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933617AbXDGRo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:44:57 -0400
Subject: Re: [PATCH] timekeeping: drop irq-context clocksource polling
From: Daniel Walker <dwalker@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, mingo@elte.hu
In-Reply-To: <20070407031922.ee49478f.akpm@linux-foundation.org>
References: <20070405210316.785839431@mvista.com>
	 <20070407031922.ee49478f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 07 Apr 2007 10:43:59 -0700
Message-Id: <1175967839.15973.156.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-07 at 03:19 -0700, Andrew Morton wrote:
> On Thu, 05 Apr 2007 14:03:16 -0700 Daniel Walker <dwalker@mvista.com> wrote:
> 
> > Before this change the timekeeping code would poll the clocksource
> > list every interrupt. This changes that so the clocksource list is
> > only checked when there has been and update, and no longer checks
> > in interrupt context.
> 
> I get a complete lockup on i386 SMP - before the kernel has printed anything.
> 
> I'm suspecting a recursive taking of xtime_lock.

Looks like this path ,

arch/i386/kernel/tsc.c: time_cpufreq_notifier(); <-- takes xtime_lock
			 mark_tsc_unstable();
            		  clocksource_change_rating(&clocksource_tsc, 0);
			   timekeeping_change_clocksource(); <-- takes xtime_lock


I'm not sure why the time_cpufreq_notifier is taking the xtime_lock tho .

Daniel

