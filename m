Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbYKQQfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbYKQQfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYKQQfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:35:23 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:48764 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbYKQQfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:35:22 -0500
Message-ID: <49219D36.5020801@cosmosbay.com>
Date: Mon, 17 Nov 2008 17:35:02 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [Bug #11308] tbench regression on each kernel release from	2.6.22
 -&gt; 2.6.28
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera> <NjF0-fuClJC.A.73B.cLHIJB@chimera> <20081117090648.GG28786@elte.hu> <20081117.011403.06989342.davem@davemloft.net> <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu>
In-Reply-To: <20081117161135.GE12081@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 17 Nov 2008 17:35:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>>> It all looks like pure old-fashioned straight overhead in the 
>>> networking layer to me. Do we still touch the same global cacheline 
>>> for every localhost packet we process? Anything like that would 
>>> show up big time.
>> Yes we do, I find strange we dont see dst_release() in your NMI 
>> profile
>>
>> I posted a patch ( commit 5635c10d976716ef47ae441998aeae144c7e7387 
>> net: make sure struct dst_entry refcount is aligned on 64 bytes) (in 
>> net-next-2.6 tree) to properly align struct dst_entry refcounter and 
>> got 4% speedup on tbench on my machine.
> 
> Ouch, +4% from a oneliner networking change? That's a _huge_ speedup 
> compared to the things we were after in scheduler land. A lot of 
> scheduler folks worked hard to squeeze the last 1-2% out of the 
> scheduler fastpath (which was not trivial at all). The _full_ 
> scheduler accounts for only about 7% of the total system overhead here 
> on a 16-way box...

4% on my machine, but apparently my machine is sooooo special (see oprofile thread),
so maybe its cpus have a hard time playing with a contended cache line.

It definitly needs more testing on other machines.

Maybe you'll discover patch is bad on your machines, this is why it's in
net-next-2.6

> 
> So why should we be handling this anything but a plain networking 
> performance regression/weakness? The localhost scalability bottleneck 
> has been reported a _long_ time ago.
> 

struct dst_entry problem was already discovered a _long_ time ago
and probably solved at this time.

(commit f1dd9c379cac7d5a76259e7dffcd5f8edc697d17
Thu, 13 Mar 2008 05:52:37 +0000 (22:52 -0700)
[NET]: Fix tbench regression in 2.6.25-rc1)

Then, a gremlin came and broke the thing.

They are many contended cache lines in the system, we can do our
best to try to make them disappear. Thats not always possible.

Another contended cache line is the rwlock in iptables.
I remember Stephen had a patch to make the thing use RCU.

