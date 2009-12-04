Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbZLDReT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbZLDReT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932235AbZLDReR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:34:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49916 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbZLDReR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:34:17 -0500
Message-ID: <4B194722.9020705@zytor.com>
Date: Fri, 04 Dec 2009 09:30:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: "Ahmed S. Darwish" <darwish.07@gmail.com>, x86@kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: x86: Is 'volatile' necessary for readb/writeb and friends?
References: <20091204092119.GA9707@laptop> <8B1FEF0C-5D71-4D64-ADC3-1EE60F50779F@kernel.crashing.org>
In-Reply-To: <8B1FEF0C-5D71-4D64-ADC3-1EE60F50779F@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 06:39 AM, Segher Boessenkool wrote:
>> x86 memory-mapped IO register accessors cast the memory mapped address
>> parameter to a one with the 'volatile' type qualifier. For example, here
>> is readb() after cpp processing
>>
>> --> arch/x86/include/asm/io.h:
>>
>> static inline unsigned char readb(const volatile void __iomem *addr) {
> 
> This "volatile" is meaningless.

Wrong.  "volatile" here is an assertion that it is safe to pass pointer
to a volatile object to this function.

>>     unsigned char ret;
>>     asm volatile("movb %1, %0"
> 
> This "volatile" is required; without it, if "ret" isn't used (or can
> be optimised away), the asm() could be optimised away.
> 
>>              :"=q" (ret)
>>              :"m" (*(volatile unsigned char __force *)addr)
> 
> This "volatile" has no effect, since the asm has a "memory" clobber.
> Without that clobber, this "volatile" would prevent moving the asm
> over other memory accesses.
> 
> If you want to get all language-lawyery, if the object pointed to by
> "addr" is volatile, the volatile here _is_ needed: accessing volatile
> objects via a not volatile-qualified lvalue is undefined.  But since
> this is GCC-specific code anyway, do you care?  :-)

Again, this comes from the prototype being volatile.

Either way, it works, it is guaranteed to be safe, and removing it can
only introduce bugs, not remove them.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

