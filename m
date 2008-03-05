Return-Path: <linux-kernel-owner+w=401wt.eu-S1762895AbYCEVlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895AbYCEVlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762521AbYCEVlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:41:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:25878 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762302AbYCEVlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:41:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,452,1199692800"; 
   d="scan'208";a="350416151"
Message-ID: <47CF136A.8070202@intel.com>
Date: Wed, 05 Mar 2008 13:40:58 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Todd Tomaino <ttomaino@rivulet.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: E1000:   e1000_update_stats()
References: <67F3071335CB9945A6047FE06957E0240D6D94CE93@exchange.rivulet.com> <47CF0F1F.1080402@nortel.com>
In-Reply-To: <47CF0F1F.1080402@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2008 21:41:14.0951 (UTC) FILETIME=[A332D570:01C87F09]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Todd Tomaino wrote:
> 
>> Reading the comments in the code it appeared that updating
>> adapter->net_stats and adapter->stat required interrupts to be turned
>> off to prevent the e1000_adjust_tbi_stats() function from modifying
>> these structures from interrupt context.  In order to reduce the
>> amount of time spent with interrupts disabled I separated the
>> register reads from updating adapter->stat counters.  The register
>> reads take up the bulk of the 57 usec and shouldn't require
>> protection (I could be wrong).  The new operation looks like this and
>> reduces the amount of time spent with interrupts turned off by 1/2:
>>
>> 1. read registers 2. acquire spinlock 3. update adapter->stat
>> counters 4. update OS adapter->net_stats statistics 5. update phy
>> stats. 6. release spinlock.
> 
> One potential problem with this is that the stats can be further out of
> date.
> 
> Consider this case:
> 
> cpu0 reads some of the registers, then gets preempted/interrupted
> cpu1 reads all the registers, updates the stats, then dumps the data
> 
> 
> At this point cpu1 dumped information that doesn't include the registers
> that cpu0 was in the middle of updating.  Eventually cpu0 will run again
> and the stats will be accurate, but there is a window where the stats
> may be self-inconsistent and the various counts may not add up.

the update_stats function is only called every two seconds, and scheduled once. I
think that the chance that two of these functions run in contention in the way you
point out are practically zero, and if they do then we have much bigger problems
than just counters being wrong...

the lock is there to prevent an mii-tool PHY read from interfering with the
regularly scheduled PHY reads, so we might want to keep those reads locked
together as Todd suggests himself, but not the bulk MAC reads.

Auke
