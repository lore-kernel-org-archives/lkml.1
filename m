Return-Path: <linux-kernel-owner+w=401wt.eu-S1030396AbXBUR05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030396AbXBUR05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030573AbXBUR05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:26:57 -0500
Received: from main.gmane.org ([80.91.229.2]:52745 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030396AbXBUR04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:26:56 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Michael Richardson <mcr@sandelman.ca>
Subject: Re: Expertise required:USB bulk-throughput and memory leak detection
Date: Wed, 21 Feb 2007 12:21:45 -0500
Message-ID: <45DC7FA9.3050107@sandelman.ca>
References: <24ED22E506B5A042BF5B05B6B017D86C0A9016@PNE-HJN-MBX01.wipro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: desk.marajade.sandelman.ca
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061219 Iceape/1.0.7 (Debian-1.0.7-3)
In-Reply-To: <24ED22E506B5A042BF5B05B6B017D86C0A9016@PNE-HJN-MBX01.wipro.com>
Cc: kernelnewbies@nl.linux.org, kernel-mentors@selenic.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

bhuvan.kumarmital@wipro.com wrote:
> 1.) detecting memory leaks caused by our driver code. 

Your code will of course be allocating buffers. If you are allocating
from a specific slab, if you have leaks, they will show up in /proc/slabinfo

I wrote some code last month, which I called slabwatch, to track each
item from slabinfo over time and let me plot it. I knew I had a memory leak
which under heavy (network) test loads eventually brought down the kernel,
and I was able to determine what was leaking, and eventually where the leak was.

http://www.sandelman.ca/software/slabwatch-1.3.tgz

It's very rudamentary.

> 2.) Neither have we been able to find a tool which shows % 
> utilisation of kernel memory used by our driver.(kernel 
> memory monitoring)

if you know what pools you are allocating from, then you should be able
to see what is going on. If you are able to, you may want to allocate
(at least experimentally), your own slab, because then you can see precisely
what is going on. This isn't trivial for skb allocations, because you have
to use a custom destructor for the skb, as kfree_skb() otherwise would free
things into the wrong slab.

I wouldn't have minded having a per-interface pool of memory
(and I can see a lot of uses where it would be valuable to limit skb's
allocated to the capture port of a snort sensor, for instance, while not
starving the management port), but I don't know if the skb->destructor is sufficient
under-used to permit such a thing to be trivially implemented.

I don't know the situation with USB drivers.

