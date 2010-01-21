Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302Ab0AUA4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0AUA4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 19:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938Ab0AUA4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 19:56:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50072 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab0AUA4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 19:56:32 -0500
Message-ID: <4B57A60E.5030306@zytor.com>
Date: Wed, 20 Jan 2010 16:55:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [x86] Unify semaphore_32.S and rwlock_64.S
References: <alpine.DEB.2.00.1001191616280.28622@router.home> <4B56328E.9080108@zytor.com> <alpine.DEB.2.00.1001201333430.15175@router.home> <4B57641E.5060303@zytor.com> <alpine.DEB.2.00.1001201443340.17915@router.home> <alpine.LFD.2.00.1001201546330.13231@localhost.localdomain> <alpine.LFD.2.00.1001201637320.13231@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001201637320.13231@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 04:46 PM, Linus Torvalds wrote:
> 
> 
> On Wed, 20 Jan 2010, Linus Torvalds wrote:
>>
>> 	#define RWSEM_UNLOCKED_VALUE            0x00000000
>> 	#define RWSEM_ACTIVE_BIAS               0x00000001
>> 	#define RWSEM_ACTIVE_MASK               0x3fffffff
>> 	#define RWSEM_WAITING_BIAS              (~RWSEM_ACTIVE_MASK)
>> 	#define RWSEM_ACTIVE_READ_BIAS          RWSEM_ACTIVE_BIAS
>> 	#define RWSEM_ACTIVE_WRITE_BIAS         (RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
> 
> Btw, doing that RWSEM_WAITING_BIAS cleanup (we currently have it as an 
> independent constant) means that now all constants are shared except for 
> that RWSEM_ACTIVE_MASK. So it ends up being something like this:
> 
> 	#ifdef CONFIG_RWSEM_64bit
> 	  typedef __s64 rwsem_count_t;
> 	  #define RWSEM_ACTIVE_MASK	0x3fffffff
> 	#else
> 	  typedef __s32 rwsem_count_t;
> 	  #define RWSEM_ACTIVE_MASK     0xffff
> 	#endif
> 
> 	#define RWSEM_UNLOCKED_VALUE	0x00000000
> 	#define RWSEM_ACTIVE_BIAS	0x00000001
> 	#define RWSEM_WAITING_BIAS	(~RWSEM_ACTIVE_MASK)
> 	#define RWSEM_ACTIVE_READ_BIAS	RWSEM_ACTIVE_BIAS   
> 	#define RWSEM_ACTIVE_WRITE_BIAS	(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
> 
> with just that two-line difference for the 32-bit/64-bit case.
> 
> At least I _think_ so.
> 

Yes, I already had that change in my tree (or rather, I wrote it as
(-RWSEM_ACTIVE_MASK-1) to be consistent with what was previously there,
but (~RWSEM_ACTIVE_MASK) makes more sense.)

> And it's worth noting (again) that I didn't actually push the 
> twsem_count_t changes down into the slow-path code in lib/rwsem.c. There's 
> a few variables there that might need looking at too. I _think_ they are 
> all ok as-is (unlike the header file, lib/rwsem.c seems to consistently 
> use 'signed long' rather than mix 32-bit and 64-bit types), but it migh be 
> cleaner to make them rwsem_count_t's too.

Yes, if we have it we should it consistently.

	-hpa

