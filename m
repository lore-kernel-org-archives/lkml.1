Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYIQWv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYIQWv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 18:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYIQWvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 18:51:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48118 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbYIQWvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:51:48 -0400
Message-ID: <48D18919.9060808@redhat.com>
Date: Wed, 17 Sep 2008 15:47:53 -0700
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Populating multiple ptes at fault time
References: <48D142B2.3040607@goop.org> <48D17E75.80807@redhat.com> <48D1851B.70703@goop.org>
In-Reply-To: <48D1851B.70703@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>> One problem is the accessed bit.  If it's unset, the shadow code
>> cannot make the pte present (since it has to trap in order to set the
>> accessed bit); if it's set, we're lying to the vm.
>>     
>
> So even if the guest pte were present but non-accessed, the shadow pte
> would have to be non-present and you'd end up taking the fault anyway?
>
>   

Yes.

> Hm, that does undermine the benefits.  Does that mean that when the vm
> clears the access bit, you always have to make the shadow non-present? 
> I guess so.  And similarly with dirty and writable shadow.
>
>   

Yes.

> The counter-argument is that something has gone wrong if we start
> populating ptes that aren't going to be used in the near future anyway -
> if they're never used then any effort taken to populate them is wasted. 
> Therefore, setting accessed on them from the outset isn't terribly bad.
>
>   

We don't know whether the page will be used or not.  Keeping the 
accessed bit clear allows the vm to reclaim it early, and in preference 
to the pages it actually used.

We could work around it by having a hypercall to read and clear accessed 
bits.  If we know the guest will only do that via the hypercall, we can 
keep the accessed (and dirty) bits in the host, and not update them in 
the guest at all.  Given good batching, there's potential for a large 
win there.

(If the host throws away a shadow page, it could sync the bits back into 
the guest pte for safekeeping)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

