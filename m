Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbYE1Ciz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbYE1Ciz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 22:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYE1Cio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 22:38:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47188 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbYE1Cio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 22:38:44 -0400
Date: Wed, 28 May 2008 04:47:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miquel van Smoorenburg <mikevs@xs4all.net>,
       Andi Kleen <andi@firstfloor.org>, Glauber Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] 2.6.26-rc: x86: pci-dma.c: use __GFP_NO_OOM instead of __GFP_NORETRY
Message-ID: <20080528024727.GB20824@one.firstfloor.org>
References: <20080526234940.GA1376@xs4all.net> <20080527014720.6db68517.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527014720.6db68517.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So...  why not just remove the setting of __GFP_NORETRY?  Why is it
> wrong to oom-kill things in this case?

When the 16MB zone overflows (which can be common in some workloads)
calling the OOM killer is pretty useless because it has barely any 
real user data [only exception would be the "only 16MB" case Alan
mentioned]. Killing random processes in this case is bad. 

I think for 16MB __GFP_NORETRY is ok because there should be 
nothing freeable in there so looping is useless. Only exception would be the 
"only 16MB total" case again but I'm not sure 2.6 supports that at all
on x86.

On the other hand d_a_c() does more allocations than just 16MB, especially
on 64bit and the other zones need different strategies.


> But this change increases the chances of a caller getting stuck in the
> page allocator for ever, unable to make progress?

At least for much longer, yes I am somewhat worried about this too.

Sometimes a OOM regression test suite would be really nice.

-Andi
