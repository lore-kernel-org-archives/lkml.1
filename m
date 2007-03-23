Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbXCVXvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbXCVXvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 19:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbXCVXvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 19:51:41 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:44417 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784AbXCVXvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 19:51:41 -0400
Message-ID: <460324A7.3010604@vmware.com>
Date: Thu, 22 Mar 2007 16:51:51 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dan Hecht <dhecht@vmware.com>, Thomas Gleixner <tglx@linutronix.de>,
       Akinobu Mita <mita@miraclelinux.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH RFC] Change softlockup watchdog to ignore stolen time
References: <460311FA.6070400@goop.org>
In-Reply-To: <460311FA.6070400@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> The softlockup watchdog is currently a nuisance in a virtual machine,
> since the whole system could have the CPU stolen from it for a long
> period of time.  While it would be unlikely for a guest domain to be
> denied timer interrupts for over 10s, it could happen and any softlockup
> message would be completely spurious.
>   

No, it is not unlikely.  4-way SMP VMs idling exhibit this behavior with 
NO_HZ or NO_IDLE_HZ because they get quiet enough to schedule nothing on 
the APs.

And that can happen on native hardware as well.

> Earlier I proposed that sched_clock() return time in unstolen
> nanoseconds, which is how Xen and VMI currently implement it.  If the
> softlockup watchdog uses sched_clock() to measure time, it would
> automatically ignore stolen time, and therefore only report when the
> guest itself locked up.  When running native, sched_clock() returns
> real-time nanoseconds, so the behaviour would be unchanged.
>
> Does this seem sound?
>
> Also, softlockup.c's use of jiffies seems archaic now.  Should it be
> converted to use timers?  Mightn't it report lockups just because there
> was no timer event?
>   

This looks good to me, as a first order approximation.  But on native 
hardware, with NO_HZ, this is just broken to begin with.  Perhaps we 
should make SOFTLOCKUP depend on !NO_HZ.

Zach
