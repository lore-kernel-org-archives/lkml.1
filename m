Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbYG1TWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbYG1TWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 15:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYG1TWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 15:22:31 -0400
Received: from relay2.sgi.com ([192.48.171.30]:57137 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751431AbYG1TWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 15:22:30 -0400
Message-ID: <488E1C75.7060808@sgi.com>
Date: Mon, 28 Jul 2008 12:22:29 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [git pull] cpus4096 fixes
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org> <200807281042.12860.rusty@rustcorp.com.au> <488E06F0.4070404@sgi.com> <alpine.LFD.1.10.0807281127150.3486@nehalem.linux-foundation.org> <alpine.LFD.1.10.0807281135060.3486@nehalem.linux-foundation.org> <20080728185134.GA11664@elte.hu>
In-Reply-To: <20080728185134.GA11664@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>>
>> On Mon, 28 Jul 2008, Linus Torvalds wrote:
>>> Here's a trivial setup, that is even tested. It's _small_ too.
>>>
>>> 	/* cpu_bit_bitmap[0] is empty - so we can back into it */
>>> 	#define MASK_DECLARE_1(x) [x+1][0] = 1ul << (x)
>>> 	#define MASK_DECLARE_2(x) MASK_DECLARE_1(x), MASK_DECLARE_1(x+1)
>>> 	#define MASK_DECLARE_4(x) MASK_DECLARE_2(x), MASK_DECLARE_2(x+2)
>>> 	#define MASK_DECLARE_8(x) MASK_DECLARE_4(x), MASK_DECLARE_4(x+4)
>>>
>>> 	static const unsigned long cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)] = {
>>> 		MASK_DECLARE_8(0), MASK_DECLARE_8(8),
>>> 		MASK_DECLARE_8(16), MASK_DECLARE_8(24),
>>> 	#if BITS_PER_LONG > 32
>>> 		MASK_DECLARE_8(32), MASK_DECLARE_8(40),
>>> 		MASK_DECLARE_8(48), MASK_DECLARE_8(56),
>>> 	#endif
>>> 	};
>>>
>>> 	static inline const cpumask_t *get_cpu_mask(unsigned int nr)
>>> 	{
>>> 		const unsigned long *p = cpu_bit_bitmap[1 + nr % BITS_PER_LONG];
>>> 		p -= nr / BITS_PER_LONG;
>>> 		return (const cpumask_t *)p;
>>> 	}
>> Btw, Ingo, can we get this issue resolved asap, please?
>>
>> I was planning on doing -rc1 today, but this kind of hangs over me. 
>> The above three lines of code (and more lines of macro initializers) 
>> obviously does need some more testing, but if you hook it into the 
>> other changes you already had, maybe we can get it done.
>>
>> Hmm?
> 
> yeah, i'm on it. If everything goes well hopefully i'll have something 
> pullable in 1-2 hours, if that's ok as a timeframe.
> 
> 	Ingo

One problem is that the current api is cpumask_t cpumask_of_cpu(x), so
all ref's would have to be changed.  (Unless there's some clever way of
defining "&cpumask_of_cpu(x)" to be get_cpu_mask(x) ...?)

Do you want me to do these changes?

Thanks,
Mike
