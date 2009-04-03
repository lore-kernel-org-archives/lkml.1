Return-Path: <linux-kernel-owner+w=401wt.eu-S935205AbZDCSTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935205AbZDCSTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 14:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763055AbZDCSTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 14:19:30 -0400
Received: from gw.goop.org ([64.81.55.164]:43794 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757719AbZDCST3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 14:19:29 -0400
Message-ID: <49D6532C.6010804@goop.org>
Date: Fri, 03 Apr 2009 11:19:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Rik van Riel <riel@redhat.com>, akpm@osdl.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, frankeh@watson.ibm.com,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
       hugh@veritas.com, Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [patch 0/6] Guest page hinting version 7.
References: <20090327150905.819861420@de.ibm.com>	<200903281705.29798.rusty@rustcorp.com.au>	<20090329162336.7c0700e9@skybase>	<200904022232.02185.nickpiggin@yahoo.com.au>	<20090402175249.3c4a6d59@skybase>	<49D50CB7.2050705@redhat.com>	<49D518E9.1090001@goop.org>	<49D51CA9.6090601@redhat.com>	<49D5215D.6050503@goop.org> <20090403104913.29c62082@skybase>
In-Reply-To: <20090403104913.29c62082@skybase>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> This is the basic idea of guest page hinting. Let the host memory
> manager make it decision based on the data it has. That includes page
> age determined with a global LRU list, page age determined with a
> per-guest LRU list, i/o rates of the guests, all kind of policy which
> guest should have how much memory.

Do you look at fault rates?  Refault rates?

>  The page hinting comes into play
> AFTER the decision has been made which page to evict. Only then the host
> should look at the volatile vs. stable page state and decide what has
> to be done with the page. If it is volatile the host can throw the page
> away because the guest can recreate it with LESS effort. That is the
> optimization.
>   

Yes, and its good from that perspective.   Do you really implement it 
purely that way, or do you bias the LRU to push volatile and free pages 
down the end of the LRU list in preference to pages which must be 
preserved?  If you have a small bias then you can prefer to evict easily 
evictable pages compared to their near-equivalents which require IO.

> But with page hinting you don't have to even ask. Just take the pages
> if you need them. The guest already told you that you can have them by
> setting the unused state.
>   

Yes.  But it still depends on the guest.  A very helpful guest could 
deliberately preswap pages so that it can mark them as volatile, whereas 
a less helpful one may keep them persistent and defer preswapping them 
until there's a good reason to do so.  Host swapping and page hinting 
won't put any apparent memory pressure on the guest, so it has no reason 
to start preswapping even if the overall system is under pressure.  
Ballooning will expose each guest to its share of the overall system 
memory pressure, so they can respond appropriately (one hopes).

    J
