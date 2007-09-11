Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbXIKVuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbXIKVuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbXIKVt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:49:57 -0400
Received: from www.osadl.org ([213.239.205.134]:54747 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755558AbXIKVt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:49:56 -0400
Subject: Re: clockevents: fix resume logic
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <1189540321.5235.21.camel@chaos>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	 <200709111323.56030.rjw@sisk.pl>
	 <20070911042228.1ef690e0.akpm@linux-foundation.org>
	 <200709111409.13796.rjw@sisk.pl>
	 <20070911112531.80bac380.akpm@linux-foundation.org>
	 <1189535883.5235.13.camel@chaos>
	 <20070911114417.3f6e9e1b.akpm@linux-foundation.org>
	 <1189540321.5235.21.camel@chaos>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 23:49:47 +0200
Message-Id: <1189547387.5235.69.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 21:52 +0200, Thomas Gleixner wrote:
> >     C1:                  type[C1] promotion[C2] demotion[--] latency[001] usage[00000010] duration[00000000000000000000]
> >    *C2:                  type[C2] promotion[--] demotion[C1] latency[001] usage[00008316] duration[00000000000170717293]
> 
> Ok, here we are. The bad one uses C2 which stops the local apic on the
> VAIO. I suspect we end up in the suspend/resume with going into C2
> without the broadcast active.
> 
> Can you try to get the output of SysRq-Q during the "it needs help from
> keyboard" period ?

Summary of the oddities we are seing:

1.) disabling local apic timer makes the problem go away
2.) disabling nohz and highres makes the problem go away
3.) adding the cpuidle patches from the acpi tree makes the problem go
away

The obvious conclusion is, that in all other cases we run into a state,
where the local apic timer is not working.

1) we do not use it
2) it is used in periodic mode
3) the cpu does not enter C2 (which turns the lapic timer off on the
VAIO)

While 1) and 3) are understandable, the reason why 2) is working is a
mystery because the periodic mode is affected by the C state as well.

Andrew, can you please provide the output of /proc/timer_list when you
boot the kernel with "nohz=off highres=off", but honestly I do not
expect a lot of enlightenment from it.

The Sysrq-Q output from the point where the box is stuck without
keystrokes might give us more information.

	tglx


