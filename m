Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbYKQPRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbYKQPRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbYKQPRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:17:04 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:58373 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbYKQPRD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:17:03 -0500
Message-ID: <49218AC7.20202@cosmosbay.com>
Date: Mon, 17 Nov 2008 16:16:23 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: eranian@gmail.com
CC: Andi Kleen <andi@firstfloor.org>, Mikael Pettersson <mikpe@it.uu.se>,
       Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net,
       Ingo Molnar <mingo@elte.hu>, Jiri Kosina <jkosina@suse.cz>,
       Jiri Benc <jbenc@suse.cz>, Vilem Marsik <vmarsik@suse.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: Oprofile : need to adjust PC by 16 bytes
References: <alpine.LNX.1.10.0811132147030.19853@jikos.suse.cz>	 <alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz>	 <20081113213744.GA8429@elte.hu> <491CA0DC.8070405@cosmosbay.com>	 <491D987F.1000301@cosmosbay.com>	 <18717.44751.459961.277998@harpo.it.uu.se>	 <491DB391.2040701@cosmosbay.com>	 <20081114175056.GK3810@one.firstfloor.org>	 <491EF942.1090709@cosmosbay.com>	 <20081115183627.GL3810@one.firstfloor.org> <7c86c4470811170702y127c9249m9b86b65a38a3e05c@mail.gmail.com>
In-Reply-To: <7c86c4470811170702y127c9249m9b86b65a38a3e05c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 17 Nov 2008 16:16:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stephane eranian a écrit :
> Hello,
> 
> I have not seen the beginning of that discussion so my comments may be
> slightly off.
> It seems Eric has problems with accuracy of instruction addresses when
> sampling with the PMU.
> 
> This is an inherent limitation of the PMU. It can be mitigated but not
> completely eliminated. The core
> issue is that it takes several cycles between the moment a counter
> overflows and posting of the PMU
> interrupt. During that time, the CPU keeps on executing instructions.
> The interrupt IP you get, reflects
> the place you were when it triggered. That can be far away from where
> it was posted and where the
> counter actually overflowed. Of course, if you are stalled that
> distance is usually 0 or off by a small
> number of instructions. But it can be very large when overflow happens
> during a kernel critical section
> where interrupts are off. There is nothing SW can do about all of this.
> 
> Andi mentioned PEBS. I don't know if you are familiar with what it
> does. Let me summarize. This is
> a hardware/microcode feature which implements a hardware-managed
> buffer where samples are
> stored. The OS points the CPU to a memory region where PMU samples are
> stored. No PMU
> interrupt is generated until the buffer becomes full. That part
> addresses some of the overhead
> associated with interrupt-based sampling. Unfortunately, PEBS  does
> not point to the instruction where
> the counter overflowed, it will still be a few instructions off. But
> this time, you get the machine state at the
> last retired instruction. Furthermore, PEBS can record samples while
> in kernel critical sections. A limitation
> of PEBS is that it does not work with all the PMU events. Only a
> handful are available.
> 
> As for perfmon, if you pull from the perfmon2 GIT tree, this should
> work. Don't know what happen in
> you case.
> 
> Perfmon and the pfmon can do simple counting or also collect profiles.
> 
> $ pfmon date
> 
> Counts cycles at the user level only for the process date
> 
> $ pfmon --system-wide -t10
> 
> Counts elapsed cycles at user level for all CPU for 10s. Results are per-cpu
> 
> $ pfmon --long-smpl-periods=240000 date
> 
> Collect a flat profile of process date. Period is 240,000 elapsed user cycle
> 
> $ pfmon --system-wide --long-smpl-periods=240000 -t 10
> 
> Collect a flat profile on each online CPU during 10s. Period is
> 240,000 user elapsed cycles. Results are per-cpu
> 
> You have a lot  more examples on the perfmon web site, Following the
> documentation and pfmon users' guide.
> 
> Perfmon/pfmon can use PEBS on Intel Core processors. First step is to
> insert the kernel module for it:
>    # modprobe perfmon_pebs_core_smpl
> 
> Then use pfmon, we use instruction_retired because elapsed cycles does
> not support PEBS:
> 
>    $ pfmon --smpl-module=pebs -einstructions_retired
> --long-smpl-periods=120000 date
> 
> Hope this helps.
> 

Sure it does ! Thanks a lot Stephane, I am going to try all this stuff.


