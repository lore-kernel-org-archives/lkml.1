Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbZINOl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbZINOl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbZINOl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:41:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755602AbZINOl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:41:27 -0400
Date: Mon, 14 Sep 2009 07:40:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Eric Paris <eparis@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Jens Axboe <jens.axboe@oracle.com>, James Morris <jmorris@namei.org>,
       Thomas Liu <tliu@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [origin tree SLAB corruption] BUG kmalloc-64: Poison overwritten,
 INFO: Allocated in bdi_alloc_work+0x2b/0x100 age=175 cpu=1 pid=3514
In-Reply-To: <20090914071631.GA24801@elte.hu>
Message-ID: <alpine.LFD.2.01.0909140725470.3654@localhost.localdomain>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com> <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org> <20090912072450.GA6767@elte.hu> <1252808939.13780.30.camel@dhcp231-106.rdu.redhat.com>
 <20090914071631.GA24801@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Sep 2009, Ingo Molnar wrote:
> 
> BUG kmalloc-64: Poison overwritten
> -----------------------------------------------------------------------------
> 
> INFO: 0xf498f6a0-0xf498f6a7. First byte 0x90 instead of 0x6b
> INFO: Allocated in bdi_alloc_work+0x2b/0x100 age=175 cpu=1 pid=3514
> INFO: Freed in bdi_work_free+0x45/0x60 age=9 cpu=1 pid=3509
> INFO: Slab 0xc3257d84 objects=36 used=11 fp=0xf498f690 flags=0x400000c3
> INFO: Object 0xf498f690 @offset=1680 fp=0xf498fe00
> 
> Bytes b4 0xf498f680:  ab 0d 00 00 9c 27 ff ff 5a 5a 5a 5a 5a 5a 5a 5a ?....'??ZZZZZZZZ
>   Object 0xf498f690:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xf498f6a0:  90 f3 98 f4 60 3c 11 c1 6b 6b 6b 6b 6b 6b 6b 6b .?.?`<.?kkkkkkkk

That's 8 bytes of 0xf498f398 and 0xc1113c60. Doesn't look like much, but 
they're both valid kernel pointers, and the 0xf498f398 one is actually 
into the same page as the corruption, so it's a pointer to the same slab 
type (or at least same size). Which is a good hint in itself: we're 
looking at a list or something.

And it's at offset 16 in the structure. 

That's almost certainly a "struct bdi_work", and the use-aftr-free thing 
is the "struct rcu_head rcu_head" part of it. That first thing (pointer to 
the same page) is 'next', and the second thing is a pointer to kernel text 
(and I can pretty much guarantee that 0xc1113c60 is 'bdi_work_free').

So this is either a fs/fs-writeback.c bug, or it's a problem with RCU. 
Both of them are new or hugely changed since 2.6.31.

			Linus
