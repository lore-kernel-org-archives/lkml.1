Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab0BLRA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 12:00:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398Ab0BLRAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 12:00:23 -0500
Date: Fri, 12 Feb 2010 11:59:20 -0500
From: Don Zickus <dzickus@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 0/3 v2] new nmi_watchdog using perf events
Message-ID: <20100212165920.GB3062@redhat.com>
References: <bd4cb8901002120812n7da16b6k29dd9b950ac68f25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4cb8901002120812n7da16b6k29dd9b950ac68f25@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 05:12:38PM +0100, Stephane Eranian wrote:
> Don,
> 
> How is this new NMI watchdog code going to work when you also have OProfile
> enabled in your kernel?
> 
> Today, perf_event disables the NMI watchdog while there is at least one event.
> By releasing the PMU registers, it also allows for Oprofile to work.
> 
> But now with this new NMI watchdog code, perf_event never releases the PMU.
> Thus, I suspect Oprofile will not work anymore, unless the NMI watchdog is
> explicitly disabled. Up until now OProfile could co-exist with the NMI watchdog.

You are right.  Originally when I read the code I thought perf_event just
grabbed all the PMUs in reserve_pmc_init().  But I see that only happens
when someone actually creates a PERF_TYPE_HARDWARE event, which the new
nmi watchdog does.  Those PMUs only get released when the event is
destroyed which my new code only does when the cpu disappears.

So yeah, I have effectively blocked oprofile from working.  I can change
my code such that when you disable the nmi_watchdog, you can release the
PMUs and let oprofile work.

But then I am curious, considering that perf and oprofile do the same
thing, how much longer do we let competing subsystems control the same
hardware?  I thought the point of the perf_event subsystem was to have a
proper framework on top of the PMUs such that anyone who wants to use it
just registers themselves, which is what the new nmi_watchdog is doing.

I can add code that allows oprofile and the new nmi watchdog to coexist,
but things get a little ugly to maintain.  Just wondering what the
gameplan is here?

Cheers,
Don

