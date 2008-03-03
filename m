Return-Path: <linux-kernel-owner+w=401wt.eu-S1762656AbYCCVOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762656AbYCCVOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbYCCVOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:14:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:42718 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684AbYCCVOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:14:24 -0500
In-Reply-To: <47CC451A.2060501@linux.intel.com>
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu> <47CC451A.2060501@linux.intel.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <962471e5d2b8c88858dd5e0f50269751@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: hans.rosenfeld@amd.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
Date: Mon, 3 Mar 2008 22:13:24 +0100
To: Arjan van de Ven <arjan@linux.intel.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> hm. I suspect some gcc related difference related to the handling of 
>> this masking:
>>    pmd_val(x) & ~(PAGE_MASK | _PAGE_USER | _PAGE_PSE | _PAGE_NX)
>> versus:
>>    pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)
>> perhaps it will work if you change it to:
>>    pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER & ~_PAGE_PSE & ~_PAGE_NX)
>> ?
>> in any case, the commit has to be reverted as it clearly isnt a NOP 
>> on your box as it was intended to be. (it should only have made a 
>> difference in a rare hugetlbfs case)
>
> interesting observation: if I turn the macros into inlines... the 
> difference goes away.

include/asm-x86/pgtable.h has

	#define _PAGE_BIT_PSE           7

	#define _PAGE_PSE       (_AC(1, L)<<_PAGE_BIT_PSE)

and

	#define _PAGE_BIT_NX           63

	#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
	#define _PAGE_NX        (_AC(1, ULL) << _PAGE_BIT_NX)

so (on 32-bit) ~_PAGE_PSE is ~0x80L is 0xffffff7f, which when cast to
64-bit is 0x00000000ffffff7f, so in

	(~PAGE_MASK & ~_PAGE_USER & ~_PAGE_PSE & ~_PAGE_NX)

all the high bits are lost, while the original

	~(PAGE_MASK | _PAGE_USER | _PAGE_PSE | _PAGE_NX)

works as intended, since the bit inversion is done on a 64-bit number.


Maybe all those pagetable bit definitions should use 64-bit (ULL or a 
cast),
as it is now some dangerous detail is hidden behind the macros.  Using 
inline
functions for simple constants seems like overkill to me, but would 
also work
of course.


Segher

