Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbYJ1VD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbYJ1VD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYJ1VDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:03:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49617 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbYJ1VDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:03:19 -0400
Message-ID: <49077E1A.5080105@redhat.com>
Date: Tue, 28 Oct 2008 23:03:22 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, aliguori@codemonkey.ws,
       npiggin@suse.de, Jeremy Fitzhardinge <jeremy@goop.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] regression: vmalloc easily fail.
References: <1225234513-3996-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1225234513-3996-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> Commit db64fe02258f1507e13fe5212a989922323685ce broke
> KVM (the symptom) for me. The cause is that vmalloc
> allocations fail, despite of the fact that /proc/meminfo
> shows plenty of vmalloc space available.
>
> After some investigation, it seems to me that the current
> way to compute the next addr in the rb-tree transversal
> leaves a spare page between each allocation. After a few
> allocations, regardless of their size, we run out of vmalloc
> space.
>
>  
>  		while (addr + size >= first->va_start && addr + size <= vend) {
> -			addr = ALIGN(first->va_end + PAGE_SIZE, align);
> +			addr = ALIGN(first->va_end, align);
>  
>  			n = rb_next(&first->rb_node);
>  			if (n)
>   

I'm guessing that the missing comment explains that this is intentional, 
to trap buffer overflows?

(okay that was a cheap shot.  I don't comment nearly enough either)

Even if you leave a page between allocations, I don't see how you can 
fail a one page allocation, unless you've allocated at least N/2 pages 
(where N is the size of the vmalloc space in pages).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

