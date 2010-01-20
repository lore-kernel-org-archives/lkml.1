Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679Ab0ATX51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0ATX51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446Ab0ATX50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:57:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754620Ab0ATX5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:57:25 -0500
Date: Wed, 20 Jan 2010 15:57:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Lameter <cl@linux-foundation.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [x86] Unify semaphore_32.S and rwlock_64.S
In-Reply-To: <alpine.DEB.2.00.1001201443340.17915@router.home>
Message-ID: <alpine.LFD.2.00.1001201546330.13231@localhost.localdomain>
References: <alpine.DEB.2.00.1001191616280.28622@router.home> <4B56328E.9080108@zytor.com> <alpine.DEB.2.00.1001201333430.15175@router.home> <4B57641E.5060303@zytor.com> <alpine.DEB.2.00.1001201443340.17915@router.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Jan 2010, Christoph Lameter wrote:
> 
> Well 2^32 readers is a bit large anyways. If we are satisifed with 2^30
> (only a billion) then it works with the same code.

Yes, that's what I would suggest. Make the constants be (for the 64-bit 
case)

	#define RWSEM_UNLOCKED_VALUE            0x00000000
	#define RWSEM_ACTIVE_BIAS               0x00000001
	#define RWSEM_ACTIVE_MASK               0x3fffffff
	#define RWSEM_WAITING_BIAS              (~RWSEM_ACTIVE_MASK)
	#define RWSEM_ACTIVE_READ_BIAS          RWSEM_ACTIVE_BIAS
	#define RWSEM_ACTIVE_WRITE_BIAS         (RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
	
and now all the constants should be expressable as 32-bit (signed) values.

Side note: it might be interesting to keep the rwsem_count_t be a config 
option on x86-64 too, so this would _not_ necessarily always be a "x86-32" 
vs "x86-64" issue. A raw spinlock is 32-bit, which together with a 32-bit 
rwsem_count would make the resem's smaller. Does it matter? Maybe not. But 
we might at some point decide that it's worth limiting number of threads 
to 32k in certain configurations, so I'd keep my options open.

So make the size of the counter be a CONFIG_RWSEM_LARGE thing, rather than 
a 32-bit vs 64-bit thing. And just start out with making x86-64 select it, 
but leaving the option open to use the 32-bit version on x86-64 too?

			Linus
