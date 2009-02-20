Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbZBTX7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbZBTX7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:59:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbZBTX6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:58:51 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54661 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZBTX6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:58:50 -0500
Message-ID: <499F43B6.5020007@linux.vnet.ibm.com>
Date: Fri, 20 Feb 2009 15:58:46 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
References: <20090121185021.GA8852@elte.hu> <499DD4BE.2000704@linux.vnet.ibm.com> <20090220081040.GA11490@elte.hu> <499F30F4.509@linux.vnet.ibm.com> <1235170078.4736.42.camel@laptop>
In-Reply-To: <1235170078.4736.42.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Fri, 2009-02-20 at 14:38 -0800, Corey Ashford wrote:
>> There may be other non-event-related changes that will not be handled 
>> quite as well in this way.  In the original email I hinted at that we 
>> may want an option for mmap'd sample buffers at some point, and so I'm 
>> not clear how you'd provide an ABI to request mmap'd buffers (you would 
>> probably need to be able to request the size and get back a pointer to 
>> the mmap'd buffer).  Would this be done through a special 
>> sys_perf_counter_open call?  Or through a subsequent ioctl call on the 
>> group leader after an open (which requires the counters to be initially 
>> disabled), etc.
> 
> What's stopping a regular mmap() call using the fd obtained from
> sys_perf_counter_open() ?

Thinking about this some more, I'm not sure it is the right model to be 
able to read a stream of records up from kernel space.

Let's say I want to read 1MB of records up at once, and then a bit later 
read another 1MB, and so on, all while the program is still running and 
counters are counting.  Is there a way to use mmap this way?  I think I 
would have to call mmap for each 1MB segment (if my buffer is 1MB). 
Also how do I indicate to the kernel that I've "consumed" each 1MB chunk 
and that the kernel buffers for it can be reused?  It's easy to 
understand how to do that with just a read() call, but with mmap'd 
memory, I don't know.

Another thing that concerns me is this statement in the mmap() man page: 
"If the size of the mapped file changes after the call to mmap() as a 
result of some other operation on the mapped file, the effect of 
references to portions of the mapped region that correspond to added or 
removed portions of the file is unspecified."  Would PCL guarantee the 
correct contents of memory, despite this caveat?

If you wait till after you've stopped the counters to read up the 
records, I can see where mmap would work fine.  But if you are trying to 
unload the data from the kernel's space efficiently, over the long 
execution time of the thread or process being analyzed, I don't see how 
mmap can be used in this way on PCL's file descriptors.

In perfmon, the model is different, because the mmap'd memory for the 
buffer is not streamed; it's just a block of memory full of records. 
Once one buffer fills up, user space is alerted and the kernel
inhibits adding new entries (in single-buffering mode), while user space 
accesses the filled buffer.  So the mmap call has to be done only once. 
  Double-buffering (or more) can be achieved by splitting the buffer 
into multiple pieces and filling them up separately and alerting user 
space when each are full.

Quite possibly I'm missing something obvious, but PCL may need an mmap 
behavior better suited for efficiently reading data up dynamically over 
the long run of the program being analyzed.

Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

