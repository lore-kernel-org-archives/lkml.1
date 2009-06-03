Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbZFCXE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbZFCXE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbZFCXET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:04:19 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:5729 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZFCXET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:04:19 -0400
Message-ID: <4A26FF42.1020104@chelsio.com>
Date: Wed, 03 Jun 2009 15:54:58 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>, npiggin@suse.de,
       a.p.zijlstra@chello.nl, riel@redhat.com, mel@csn.ul.ie,
       cl@linux-foundation.org, dave@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 3/3 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
References: <alpine.DEB.2.00.0906011828040.6936@chino.kir.corp.google.com>	<alpine.DEB.2.00.0906011830490.6936@chino.kir.corp.google.com>	<20090601225602.3482cd0d.akpm@linux-foundation.org>	<alpine.DEB.2.00.0906020016060.24915@chino.kir.corp.google.com>	<1243928095.23657.5633.camel@twins>	<20090602075836.GB16201@wotan.suse.de>	<alpine.DEB.2.00.0906020104480.27792@chino.kir.corp.google.com>	<alpine.DEB.2.00.0906031507400.16042@chino.kir.corp.google.com> <20090603152616.ec5ba9af.akpm@linux-foundation.org>
In-Reply-To: <20090603152616.ec5ba9af.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2009 22:56:17.0421 (UTC) FILETIME=[80D57BD0:01C9E49E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 3 Jun 2009 15:10:38 -0700 (PDT)
> David Rientjes <rientjes@google.com> wrote:
>
>   
>> On Tue, 2 Jun 2009, David Rientjes wrote:
>>
>>     
>>> With my patch, we kill a memory hogging task that will free some memory so 
>>> the allocation will succeed (or multiple tasks if insufficient contiguous 
>>> memory is available).  Kernel allocations use __GFP_NOFAIL, so the fault 
>>> of this memory freeing is entirely on the caller, not the page allocator.
>>>
>>> My preference for handling this is to merge my patch (obviously :), and 
>>> then hopefully deprecate __GFP_NOFAIL as much as possible although I don't 
>>> suspect it could be eradicated forever.
>>>
>>>       
>> I really hope this patch isn't getting dropped because it fixes the 
>> possibility that a __GFP_NOFAIL allocation will fail when its definition 
>> is to the contrary.  Depending on the size of the allocation, that can 
>> cause a panic in at least the reiserfs, ntfs, cxgb3, and gfs2 cases.
>>
>> As I mentioned before, it's a noble goal to deprecate __GFP_NOFAIL as much 
>> as possible and (at the least) prevent it from trying high-order 
>> allocation attempts.  The current implementation of the flag is 
>> problematic, however, and this patch addresses it by attempting to free 
>> some memory when direct reclaim fails.
>>
>>     
>
> Sigh, all right, but we suck.
>
> Divy, could we please at least remove __GFP_NOFAIL from
> drivers/net/cxgb?  It's really quite inappropriate for a driver to
> assume that core VM can do magic.  Drivers should test the return value
> and handle the -ENOMEM in the old-fashioned way, please.
>   

We started working on it, and got to eliminate them out of 
cxgb3_main.c::init_tp_parity().
We're still looking at eliminating its use in 
cxgb3_offload.c::t3_process_tid_release_list().
I'll post the patches as soon as they are ready.

cheers,
Divy

