Return-Path: <linux-kernel-owner+w=401wt.eu-S933560AbZHDW6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560AbZHDW6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933363AbZHDW6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:58:34 -0400
Received: from claw.goop.org ([74.207.240.146]:49150 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933380AbZHDW6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:58:33 -0400
Message-ID: <4A78BD1A.9050001@goop.org>
Date: Tue, 04 Aug 2009 15:58:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Problem with percpu values when bringing up second CPU?
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just tracked down a bug I was having to a change where I changed one
of my Xen event channel variables to a percpu variable, relating to
masking an event channel.

The symptom was that shortly after bringing up the second CPU, the first
CPU's timer events stopped arriving, apparently because they had become
masked.

The event channels masks are declared as:

#define NR_EVENT_CHANNEL_LONGS (NR_EVENT_CHANNELS/BITS_PER_LONG)
static DEFINE_PER_CPU(unsigned long,
                     cpu_evtchn_mask[NR_EVENT_CHANNEL_LONGS]) =
       {[0 ... NR_EVENT_CHANNEL_LONGS-1] = ~0ul };	/* everything masked by default */


My theory about what's happening is that when the second CPU comes up,
it allocates separate percpu areas for each CPU, but it is somehow
failing to accurately copy CPU 0's percpu data over; either it isn't
copying it all (ie, using the initialized values rather than the current
values), or failing to copy the values in an interrupt-atomic way.

Does this sound plausible?

When I convert this back to an ad-hoc percpu variable (an array indexed
by cpu number), it goes back to working.  Also, if I boot with maxcpus=1
it also works with percpu data.

Also, because we don't have large pages under Xen, it always allocates
percpu as 4k pages:

PERCPU: Allocated 21 4k pages, static data 82080 bytes

Thanks,
    J
