Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713Ab0AUACd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0AUACd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 19:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044Ab0AUACd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 19:02:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59467 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab0AUACc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 19:02:32 -0500
Message-ID: <4B579985.8040504@zytor.com>
Date: Wed, 20 Jan 2010 16:02:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [x86] Unify semaphore_32.S and rwlock_64.S
References: <alpine.DEB.2.00.1001191616280.28622@router.home> <4B56328E.9080108@zytor.com> <alpine.DEB.2.00.1001201333430.15175@router.home> <4B57641E.5060303@zytor.com> <alpine.DEB.2.00.1001201443340.17915@router.home> <alpine.LFD.2.00.1001201546330.13231@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001201546330.13231@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 03:57 PM, Linus Torvalds wrote:
> 
> 
> On Wed, 20 Jan 2010, Christoph Lameter wrote:
>>
>> Well 2^32 readers is a bit large anyways. If we are satisifed with 2^30
>> (only a billion) then it works with the same code.
> 
> Yes, that's what I would suggest. Make the constants be (for the 64-bit 
> case)
> 
> 	#define RWSEM_UNLOCKED_VALUE            0x00000000
> 	#define RWSEM_ACTIVE_BIAS               0x00000001
> 	#define RWSEM_ACTIVE_MASK               0x3fffffff
> 	#define RWSEM_WAITING_BIAS              (~RWSEM_ACTIVE_MASK)
> 	#define RWSEM_ACTIVE_READ_BIAS          RWSEM_ACTIVE_BIAS
> 	#define RWSEM_ACTIVE_WRITE_BIAS         (RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
> 	
> and now all the constants should be expressable as 32-bit (signed) values.
> 
> Side note: it might be interesting to keep the rwsem_count_t be a config 
> option on x86-64 too, so this would _not_ necessarily always be a "x86-32" 
> vs "x86-64" issue. A raw spinlock is 32-bit, which together with a 32-bit 
> rwsem_count would make the resem's smaller. Does it matter? Maybe not. But 
> we might at some point decide that it's worth limiting number of threads 
> to 32k in certain configurations, so I'd keep my options open.
> 
> So make the size of the counter be a CONFIG_RWSEM_LARGE thing, rather than 
> a 32-bit vs 64-bit thing. And just start out with making x86-64 select it, 
> but leaving the option open to use the 32-bit version on x86-64 too?
> 

I'm somewhat unhappy about that notion, mostly because it means Yet
Another Thing To Verify[TM].  I would like to look at the relative code
sizes of 2^31 and 2^30, however, if all it means is that *one*
instruction in *one* asm has to be different, I'd rather leave it at 2^31.

	-hpa

