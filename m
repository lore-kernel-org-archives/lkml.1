Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbYBFS52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbYBFS52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYBFS5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:57:18 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:37847 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbYBFS5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:57:16 -0500
X-Greylist: delayed 138926 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2008 13:57:16 EST
Message-ID: <47AA02C6.9070807@qualcomm.com>
Date: Wed, 06 Feb 2008 10:56:06 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Jackson <pj@sgi.com>, Mark Hounschell <markh@compro.net>,
       linux-rt-users@vger.kernel.org
Subject: Re: cpuisol: CPU isolation extensions (take 2)
References: <47A8E977.3040500@qualcomm.com> <47A9A823.8020902@cfl.rr.com>
In-Reply-To: <47A9A823.8020902@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing linux-rt-users because I think my explanation below may be interesting for the 
RT folks.

Mark Hounschell wrote:
> Max Krasnyanskiy wrote:
> 
>> With CPU isolation
>> it's very easy to achieve single digit usec worst case and around 200
>> nsec average response times on off-the-shelf
>> multi- processor/core systems (vanilla kernel plus these patches) even
>> under exteme system load. 
> 
> Hi Max, could you elaborate on what sort events your response times are
> from?

Sure. As I mentioned before I'm working with our legal team on releasing hard RT engine 
that uses isolated CPUs. You can think of that engine as a giant SW PLL. 
It requires a time source that it locks on to. For example the time source can be the 
kernel clock (gtod), some kind of memory mapped counter, or some external event. 
In my case the HW sends me an Ethernet packet every 24 millisecond. 
Once the PLL locks onto the timesource the engine executes a predefined "timeline". 
The timeline basically specifies tasks with offsets in nanoseconds from the start of 
the cycle (ie "at 100 nsec run task1", "at 15000 run task2", etc). The tasks are just 
callbacks.
The jitter in running those tasks is what I meant by "response time". Essentially it's 
a polling design where SW knows precisely when to expect an event. It's not a general
purpose solution but works beautifully for things like wireless PHY/MAC layers were the
framing structure is very deterministic and must be strictly enforced. It works for other 
applications as well once you get your head wrapped around the idea :). ie That you do 
not get interrupts for every single event, the SW already knows when that even will come.
btw The engine also enforces the deadlines. For example it knows right away if a task is
late and it knows exactly how late. That helps in debugging, a lot :).

The other option is to run normal pthreads on the isolated CPUs. As long as the threads
are carefully designed not to do certain things you can get very decent worst case latencies 
(10-12 usec on Opterons and Core2) even with vanilla kernels (patched with the isolation 
patches of course) because all the latency sources have been removed from those CPUs.

Max
