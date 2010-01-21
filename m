Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642Ab0AUArT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab0AUArT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 19:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524Ab0AUArS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 19:47:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240Ab0AUArR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 19:47:17 -0500
Date: Wed, 20 Jan 2010 16:46:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Lameter <cl@linux-foundation.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [x86] Unify semaphore_32.S and rwlock_64.S
In-Reply-To: <alpine.LFD.2.00.1001201546330.13231@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001201637320.13231@localhost.localdomain>
References: <alpine.DEB.2.00.1001191616280.28622@router.home> <4B56328E.9080108@zytor.com> <alpine.DEB.2.00.1001201333430.15175@router.home> <4B57641E.5060303@zytor.com> <alpine.DEB.2.00.1001201443340.17915@router.home>
 <alpine.LFD.2.00.1001201546330.13231@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Jan 2010, Linus Torvalds wrote:
> 
> 	#define RWSEM_UNLOCKED_VALUE            0x00000000
> 	#define RWSEM_ACTIVE_BIAS               0x00000001
> 	#define RWSEM_ACTIVE_MASK               0x3fffffff
> 	#define RWSEM_WAITING_BIAS              (~RWSEM_ACTIVE_MASK)
> 	#define RWSEM_ACTIVE_READ_BIAS          RWSEM_ACTIVE_BIAS
> 	#define RWSEM_ACTIVE_WRITE_BIAS         (RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)

Btw, doing that RWSEM_WAITING_BIAS cleanup (we currently have it as an 
independent constant) means that now all constants are shared except for 
that RWSEM_ACTIVE_MASK. So it ends up being something like this:

	#ifdef CONFIG_RWSEM_64bit
	  typedef __s64 rwsem_count_t;
	  #define RWSEM_ACTIVE_MASK	0x3fffffff
	#else
	  typedef __s32 rwsem_count_t;
	  #define RWSEM_ACTIVE_MASK     0xffff
	#endif

	#define RWSEM_UNLOCKED_VALUE	0x00000000
	#define RWSEM_ACTIVE_BIAS	0x00000001
	#define RWSEM_WAITING_BIAS	(~RWSEM_ACTIVE_MASK)
	#define RWSEM_ACTIVE_READ_BIAS	RWSEM_ACTIVE_BIAS   
	#define RWSEM_ACTIVE_WRITE_BIAS	(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)

with just that two-line difference for the 32-bit/64-bit case.

At least I _think_ so.

And it's worth noting (again) that I didn't actually push the 
twsem_count_t changes down into the slow-path code in lib/rwsem.c. There's 
a few variables there that might need looking at too. I _think_ they are 
all ok as-is (unlike the header file, lib/rwsem.c seems to consistently 
use 'signed long' rather than mix 32-bit and 64-bit types), but it migh be 
cleaner to make them rwsem_count_t's too.

			Linus
