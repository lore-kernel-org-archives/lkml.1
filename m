Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbYDEHh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbYDEHh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 03:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYDEHhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 03:37:20 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51317
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYDEHhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 03:37:19 -0400
Message-ID: <47F72C12.9020701@qumranet.com>
Date: Sat, 05 Apr 2008 10:36:50 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pekka Paalanen <pq@iki.fi>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com
Subject: Re: mmiotrace bug: recursive probe hit
References: <20080309164050.2194461e@daedalus.pq.iki.fi>	<20080328222500.21863a44@daedalus.pq.iki.fi>	<20080330202608.054702a4@daedalus.pq.iki.fi> <20080404000701.70bbc1a4@daedalus.pq.iki.fi>
In-Reply-To: <20080404000701.70bbc1a4@daedalus.pq.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Paalanen wrote:
> On Sun, 30 Mar 2008 20:26:08 +0300
> Pekka Paalanen <pq@iki.fi> wrote:
>
>   
>> C) Vegard mentioned something about per-cpu page tables for kmemcheck.
>> This would be the ultimate solution, because it would solve two problems:
>> - recursive probe hits
>> - missed events due to another cpu disarming the page for single stepping
>> Would it be possible to have a single temporary per-cpu pte?
>>
>> I understood kmemcheck has similar issues. Of course, one could force the
>> system down to a single running CPU, but that feels nasty.
>>     
>
> One more idea:
>
>
> The catch is the instruction emulation. I see KVM has some emulation code,
> but I cannot understand it without a deep study that would take me weeks.
> Is that general enough to be used, or could it be generalized?
> Mmiotrace, apart from executing the instruction with a modified address,
> would need to extract the type of IO memory access, width and the data
> read/written. And since it is dealing with IO memory, the emulation
> should be very careful to access the hardware exactly like the original
> instruction would have.
>
> Maybe also kmemcheck could use this approach, since the current approach
> is very much like in mmiotrace: #pf, show page, single step, #db trap,
> hide page.
>
> Are there other x86(_64) instruction emulation facilities in the kernel
> I might use?
>
> Or, if the emulation cannot be used, what would it take to make at least
> instruction decoding general enough so that mmiotrace could use that instead
> of its own decoding?
>
> I fear modifying KVM emulation code is a too heavy job for me personally.
>   

It should not be too difficult to modify x86_emulate.c to do everything 
through a function vector.  However there is a simpler (for you) 
solution: run the driver-to-be-reverse-engineered in a kvm guest, and 
modify kvm userspace to log accesses to mmio regions.  This requires the 
not-yet-merged pci passthrough support.  You can reverse engineer 
Windows drivers with this as well.

This won't work for kmemcheck smp though.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

