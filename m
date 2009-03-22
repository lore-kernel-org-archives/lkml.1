Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZCVIRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZCVIRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 04:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZCVIR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 04:17:28 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:34696 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbZCVIR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 04:17:26 -0400
Message-ID: <49C5F3FD.9010606@cosmosbay.com>
Date: Sun, 22 Mar 2009 09:17:01 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shai@scalex86.org
Subject: Re: [rfc] [patch 1/2 ] Process private hash tables for private	futexes
References: <20090321044637.GA7278@localdomain> <49C4AE64.4060400@cosmosbay.com> <20090322045414.GD7278@localdomain>
In-Reply-To: <20090322045414.GD7278@localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 22 Mar 2009 09:17:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ravikiran G Thirumalai a écrit :
>>
>> Did you tried to change FUTEX_HASHBITS instead, since current value is really really
>> ridiculous ?
> 
> We tried it in the past and I remember on a 16 core machine, we had to
> use 32k hash slots to avoid false sharing.
> 
> 
> Yes, dynamically changing the hash table is better (looking at the patch you
> have posted), but still there are no locality guarantees here.  A process
> pinned to node X may still end up accessing remote memory locations while
> accessing the hash table.  A process private table on the other hand should
> not have this problem. I think using a global hash for entirely process local
> objects is bad design wise here.
> 
> 


Bad design, or bad luck... considering all kernel already use such global tables
(dentries, inodes, tcp, ip route cache, ...).

Problem is to size this hash table, being private or not. You said hou had
to have a 32768 slots to avoid false sharing on a 16 core machine. This seems
strange to me, given we use jhash. What is the size of the cache line on your
platforms ???

Say we have 32768 slots for the global hash table, and 256 slots for a private one,
you probably can have a program running slowly with this private 256 slots table,
if this program uses all available cores.

If we use large private hash table, the setup cost is higher (need to initialize
all spinlocks and plist heads at each program startup), unless we use a dedicate
kmem_cache to keep a pool of preinitialized priv hash tables...


