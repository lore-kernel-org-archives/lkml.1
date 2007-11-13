Return-Path: <linux-kernel-owner+w=401wt.eu-S1763637AbXKMV7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763637AbXKMV7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761987AbXKMV7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:59:00 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:52280 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761749AbXKMV67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:58:59 -0500
Message-ID: <473A1DEA.7000307@cosmosbay.com>
Date: Tue, 13 Nov 2007 22:58:02 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
References: <20071106195144.983665861@sgi.com> <20071106195157.878563669@sgi.com> <20071113.031510.151440585.davem@davemloft.net> <Pine.LNX.4.64.0711131339240.3714@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711131339240.3714@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 13 Nov 2007 22:58:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> On Tue, 13 Nov 2007, David Miller wrote:
> 
>> One thing you could do is simply use a vmalloc allocation in the
>> non-virtualized case.
> 
> Yuck. Meaning to add more crappy code. The bss limitations to 8M is a bit 
> strange though. Do other platforms have the same issues? 

Maybe not so crappy, because even for i386 code, you might use not a strict 
vmalloc() implementation but at least reserving percpu space inside the 
vmalloc range. (ie not use a dedicated area as your current patchset does)

This is because NR_CPUS is defaulted to 32 on i386 (with a limit of 256), so 
reserving 256*256KB = 64 MB of virtual space might be too much. (this is half 
the typical vmalloc area)

The idea would be :

- Reserving an area of NR_CPUS*256KB inside vmalloc() space (but of course not 
allocating pages)

- Then for each non possible cpu, 'release' its 256KB area and give it back to 
vmalloc free areas pool.

Once you add in mm/vmalloc.c all needed helpers, no need to use BSS Megablob 
anymore ?
