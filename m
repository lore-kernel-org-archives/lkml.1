Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbXLCLnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbXLCLnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 06:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbXLCLnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 06:43:32 -0500
Received: from il.qumranet.com ([82.166.9.18]:47972 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbXLCLnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 06:43:32 -0500
Message-ID: <4753ECA5.2010604@argo.co.il>
Date: Mon, 03 Dec 2007 13:46:45 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Kyle Moffett <mrmacman_g4@mac.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
References: <474EAD18.6040408@stellatravel.co.uk> <20071130143445.GA2310@csclub.uwaterloo.ca> <53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com> <4751BE0D.3050609@argo.co.il> <p733aukyl8n.fsf@bingen.suse.de> <47539030.10600@argo.co.il> <20071203095022.GA28560@one.firstfloor.org>
In-Reply-To: <20071203095022.GA28560@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Even these (with the exception of the page fault path) are hardly "we 
>> care about a single instruction" material suggested above.  Even with a 
>>     
>
> With 10Gbit/s ethernet working you start to care about every cycle.
>   

If you have 10M packets/sec no amount of cycle-saving will help you.  
You need high level optimizations like TSO.  I'm not saying we should 
sacrifice cycles like there's no tomorrow, but the big wins are elsewhere.

> Similar with highend routing or in some latency sensitive network
> applications (e.g. in HPC). 

True.  And here, the hardware can cut hundreds of cycles by avoiding the 
kernel completely for the fast path.

> Another simple noticeable case is Unix
> sockets and your X server communication.

Your reflexes are *much* better than mine if you can measure half a 
nanosecond on X.

Here, it's scheduling that matters, avoiding large transfers, and 
avoiding ping-pongs, not some cycles on the unix domain socket.  You 
already paid 150 cycles or so by issuing the syscall and thousands for 
copying the data, 50 more won't be noticeable except in nanobenchmarks.

>  
>
> And there are some special cases where block IO is also pretty critical.
> A popular one is TPC-* benchmarking, but there are also others and it 
> looks likely in the future that this will become more critical
> as block devices become faster (e.g. highend SSDs) 
>   

And again the key is batching, improving cpu affinity, and caching, not 
looking for a faster instruction sequence.

>   
>> The real benefits aren't in keeping close to the metal, but in high 
>> level optimizations.  Ironically, these are easier when the code is a 
>> little more abstracted.  You can add quite a lot of instructions if it 
>> allows you not to do some of the I/O at all.
>>     
>
> While that's partly true -- cache misses are good for a lot of cycles --
> it is not the whole truth and at some point raw code efficiency matters
> too.
>
> For example there are some CPUs who are relatively slow at indirect
> function calls and there are actually cases where this can be measured.
>
>   

That is true.  But any self-respecting systems language will let you 
choose between direct and indirect calls.

If adding an indirect call allows you to avoid even 1% of I/O, you save 
much more than you lose, so again the high level optimizations win.

Nanooptimizations are fun (I do them myself, I admit) but that's not 
where performance as measured by the end user lies.

-- 
error compiling committee.c: too many arguments to function

