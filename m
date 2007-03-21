Return-Path: <linux-kernel-owner+w=401wt.eu-S1751696AbXCUKHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbXCUKHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 06:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXCUKHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 06:07:48 -0400
Received: from mx10.go2.pl ([193.17.41.74]:58642 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751571AbXCUKHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 06:07:14 -0400
Date: Wed, 21 Mar 2007 11:11:43 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com,
       Christoph Lameter <clameter@sgi.com>, "ast\@domdv\.de" <ast@domdv.de>,
       "linux-kernel\@vger\.kernel\.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Message-ID: <20070321101143.GB1939@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703200943430.3622@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-03-2007 08:47, Pekka J Enberg wrote:
> On 3/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
...
> On Tue, 20 Mar 2007, Eric Dumazet wrote:
>> CPU: AMD64 processors, speed 1992.52 MHz (estimated)
>> Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a unit
>> mask of 0x00 (No unit mask) count 100000
>> samples  %        symbol name
>> 1861563   4.7882  tg3_start_xmit_dma_bug
>> 1375727   3.5386  memcpy_c
>> 1166438   3.0002  tcp_v4_rcv
>> 1157334   2.9768  kmem_cache_free
>>
>> In this workload (real server), you can see kmem_cache_free() is number four.
> 
> Thanks for the profile. I still wonder where exactly thouse super-hot 
> call-sites are...
> 
> On Tue, 20 Mar 2007, Eric Dumazet wrote:
>> Adding one test and conditional branch in this super-hot function just to
>> correct a bug in a SCSI driver (or whatever) is not *SANE*.

Sure! My proposal is to remove a few more - so we could
transmit this data from mostly not buggy SCSI drivers
really fast!

> 
> Agreed. Unless we can get kmem_cache_free() out of those hot paths, of 
> course =).
> 
> 				Pekka

IMHO admins care far more about infallibility than speed. Every
such "saving" causes the bugs are harder to follow, it takes more 
time and people to find bug's paths and more bugs goes to stable.

I'm sure this admin with SCSI - st problem will next time think
3 times before upgrading to the next "stable" - and it'll be only
because of this one buggy driver. (Of course then we don't get his
next bug report, either - so the next SCSI bug will be diagnosed at
least one kernel version later.)

I think Pekka was right (it looks he changed his mind now) something
should be done here. I think something like this should be a minimum:

BUG_ON(!objp || virt_to_cache(objp) != cachep);

to show distinctly what's going on. (BTW, kfree isn't exceptional 
with NULL treatment - neighbouring slob.c works alike.)

Regards,
Jarek P.
