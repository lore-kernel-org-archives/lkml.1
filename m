Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0CCGvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:51:43 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:45234 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab0CCGvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:51:41 -0500
Message-ID: <4B8E06F6.2040103@linux.vnet.ibm.com>
Date: Wed, 03 Mar 2010 07:51:34 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, gregkh@novell.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when	__GFP_COLD is
 set"
References: <4B7BBCFC.4090101@linux.vnet.ibm.com> <20100218114310.GC32626@csn.ul.ie> <4B7D664C.20507@linux.vnet.ibm.com> <4B7E73BF.5030901@linux.vnet.ibm.com> <20100219151934.GA1445@csn.ul.ie> <20100302065225.GC8653@laptop> <20100302100402.GH3852@csn.ul.ie> <20100302103646.GF8653@laptop> <20100302110149.GI3852@csn.ul.ie> <20100302111827.GI8653@laptop> <20100302112448.GJ3852@csn.ul.ie>
In-Reply-To: <20100302112448.GJ3852@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Mel Gorman wrote:
> On Tue, Mar 02, 2010 at 10:18:27PM +1100, Nick Piggin wrote:
>> On Tue, Mar 02, 2010 at 11:01:50AM +0000, Mel Gorman wrote:
>>> On Tue, Mar 02, 2010 at 09:36:46PM +1100, Nick Piggin wrote:
>>>> On Tue, Mar 02, 2010 at 10:04:02AM +0000, Mel Gorman wrote:
>>>>> On Tue, Mar 02, 2010 at 05:52:25PM +1100, Nick Piggin wrote:
[...]
>>>>> We could check further in the
>>>>> slow-path but I bet it'd be very rare that the logic would be triggered. For
>>>>> a process to enter the FIFO due to waiters that were not yet woken up, the
>>>>> system would have to be a) under heavy memory pressure b) reclaim taking such
>>>>> a long time that check_zone_pressure() is not being called in time and c)
>>>>> a process exiting or otherwise freeing memory such that the watermarks are
>>>>> cleared without reclaim being involved.
>>>> I don't think it would be too rare. Things can get freed up and
>>>> other allocations come in while reclaim is happening. But anyway
>>>> the nasty thing about the "rare" events is that they do add a
>>>> rare source of unexpected latency or starvation.
>>>>
>>> If processes are asleep on the waitqueue, reclaim must be active (by kswapd
>>> if nothing else). If pages are getting freed above the necessary watermark,
>>> then the processes will be woken up when the current shrink_zone() finished
>>> unless unfair processes are keeping the zone below watermarks.  But unless
>>> reclaim is taking an extraordinary long length of time, there would be little
>>> difference between waking the queue in the free path and waking it in the
>>> reclaim path.
 >>
>> Reclaim can take quite a while, yes.
>>

On one Hand the question if "waiter A is not yet awoken after 
shrink_zone(), but greedy B just drained pages under the water mark 
again" is good to make these new waitqueue approach as good as it can be.
On the other Hand you can see it this way - it is now at least waiting 
for the right thing "the related watermark being restored", which will 
in any way be better than waiting for writes who might or might not free 
enough pages or as in my case might not even be there :-)
And additionally its timing even if it could be a bit racy as you 
described will be much better than it is at the moment.

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance
