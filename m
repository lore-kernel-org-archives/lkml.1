Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbYCANxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbYCANxm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 08:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbYCANxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 08:53:31 -0500
Received: from neuf-infra-smtp-out-sp604006av.neufgp.fr ([84.96.92.121]:42227
	"EHLO neuf-infra-smtp-out-sp604006av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756379AbYCANxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 08:53:30 -0500
Message-ID: <47C95FBC.1010703@cosmosbay.com>
Date: Sat, 01 Mar 2008 14:53:00 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       yanmin_zhang@linux.intel.com, travis@sgi.com
Subject: Re: [PATCH] alloc_percpu() fails to allocate percpu data
References: <47BDBC23.10605@cosmosbay.com>	<Pine.LNX.4.64.0802271158100.1790@schroedinger.engr.sgi.com> <20080227122451.6a3b5565.akpm@linux-foundation.org>
In-Reply-To: <20080227122451.6a3b5565.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton a écrit :
> On Wed, 27 Feb 2008 11:59:32 -0800 (PST)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
>> Any decision made on what to do about this one? Mike or I can 
>> repost the per cpu allocator against mm? The fix by Eric could be used 
>> in the interim for 2.6.24?
>>
> 
> I suppose I'll merge Eric's patch when I've tested it fully (well, as fully
> as I test stuff).
> 
> It'd be nice to get that cache_line_size()/L1_CACHE_BYTES/L1_CACHE_ALIGN()
> mess sorted out.  If it's a mess - I _think_ it is?

Just coming back from hollidays, sorry for the delay.

I can provide a patch so that L1_CACHE_BYTES is not anymore a compile time 
constant if you want, but I am not sure it is worth the trouble ? (and this 
certainly not 2.6.{24|25} stuff :) )

Current situation :

L1_CACHE_BYTES is known at compile time, and can be quite large (128 bytes), 
while cache_line_size() gives the real cache line size selected at boot time 
given the hardware capabilities.

If L1_CACHE_BYTES is not anymore a constant, compiler will also uses plain 
divides to compute L1_CACHE_ALIGN()

Maybe uses of L1_CACHE_ALIGN() in fastpath would 'force' us to not only 
declare a cache_line_size() but also a cache_line_size_{mask|shift}() so that 
x86 could use :

#define L1_CACHE_ALIGN(x) ((((x)+cache_line_mask())) >> cache_line_shift())

#define L1_CACHE_BYTES (cache_line_size())

But I am not sure we want to play these games (we must also make sure nothing 
in the tree wants a constant L1_CACHE_BYTES and replace by SMP_CACHE_BYTES)


