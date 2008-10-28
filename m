Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbYJ1VIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbYJ1VIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbYJ1VIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:08:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50620 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbYJ1VIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:08:15 -0400
Date: Tue, 28 Oct 2008 19:09:47 -0200
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, aliguori@codemonkey.ws,
       npiggin@suse.de, Jeremy Fitzhardinge <jeremy@goop.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] regression: vmalloc easily fail.
Message-ID: <20081028210947.GA4269@poweredge.glommer>
References: <1225234513-3996-1-git-send-email-glommer@redhat.com> <49077E1A.5080105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49077E1A.5080105@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 11:03:22PM +0200, Avi Kivity wrote:
> Glauber Costa wrote:
>> Commit db64fe02258f1507e13fe5212a989922323685ce broke
>> KVM (the symptom) for me. The cause is that vmalloc
>> allocations fail, despite of the fact that /proc/meminfo
>> shows plenty of vmalloc space available.
>>
>> After some investigation, it seems to me that the current
>> way to compute the next addr in the rb-tree transversal
>> leaves a spare page between each allocation. After a few
>> allocations, regardless of their size, we run out of vmalloc
>> space.
>>
>>   		while (addr + size >= first->va_start && addr + size <= vend) {
>> -			addr = ALIGN(first->va_end + PAGE_SIZE, align);
>> +			addr = ALIGN(first->va_end, align);
>>   			n = rb_next(&first->rb_node);
>>  			if (n)
>>   
>
> I'm guessing that the missing comment explains that this is intentional,  
> to trap buffer overflows?
>
> (okay that was a cheap shot.  I don't comment nearly enough either)
>
> Even if you leave a page between allocations, I don't see how you can  
> fail a one page allocation, unless you've allocated at least N/2 pages  
> (where N is the size of the vmalloc space in pages).

I'm hoping Nick will comment on it. I might well be wrong.
but it nicely fixes the problem for me, and actually, you don't need 
"at least N/2 pages". The size of the allocations hardly matters, just
the amount of allocations we did. Since kvm does some small
vmalloc allocations, that may be the reason for we triggering it.


