Return-Path: <linux-kernel-owner+w=401wt.eu-S934493AbYETXBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934493AbYETXBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760425AbYETXBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:01:15 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:41868 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760135AbYETXBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:01:14 -0400
Date: Tue, 20 May 2008 15:55:46 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Scott Wood <scottwood@freescale.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, benh@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
In-Reply-To: <4833524C.3040207@freescale.com>
Message-ID: <Pine.LNX.4.64.0805201535290.7453@t2.domain.actdsltmp>
References: <1211316025-29069-1-git-send-email-tpiepho@freescale.com>
 <1211318219.8297.177.camel@pasglop> <483344C0.3020703@freescale.com>
 <20080520231516.76b924a2@core> <4833524C.3040207@freescale.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Scott Wood wrote:
> Alan Cox wrote:
>> >  It looks like we rely on -fno-strict-aliasing to prevent reordering 
>> >  ordinary memory accesses (such as to DMA descriptors) past the I/O
>>
>>  DMA descriptors in main memory are dependant on cache behaviour anyway
>>  and the dma_* operators should be the ones enforcing the needed behaviour.
>
> What about memory obtained from dma_alloc_coherent()?  We still need a sync 
> and a compiler barrier.  The current I/O accessors have the former, but not 
> the latter.

There doesn't appear to be any barriers to use for coherent dma other than
mb() and wmb().

Correct me if I'm wrong, but I think the sync isn't actually _required_ (by
memory-barriers.txt's definitions), and it would be enough to use eieio,
except there is code that doesn't use mmiowb() between I/O access and
unlocking.

So, as I understand it, the minimum needed is eieio.  To provide strict
ordering w.r.t. spin locks without using mmiowb(), you need sync.  To provide
strict ordering w.r.t. normal memory, you need sync and a compiler barrier.

Right now no archs provide the last option.  powerpc is currently the middle
option.  I don't know if anything uses the first option, maybe alpha?  I'm
almost certain x86 is the middle option (the first isn't possible, the arch
already has more ordering than that), which is probably why powerpc used that
option and not the first.
