Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab0BLRc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 12:32:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57409 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757319Ab0BLRc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 12:32:57 -0500
Message-ID: <4B758FC0.1020600@zytor.com>
Date: Fri, 12 Feb 2010 09:28:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Borislav Petkov <petkovbb@googlemail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for hweight_long(CONSTANT)
References: <1265299457.22001.72.camel@laptop> <20100205121139.GA9044@aftab> <4B6C93A2.1090302@zytor.com> <20100206093659.GA28326@aftab> <4B6E1DA3.50204@zytor.com> <20100208092845.GB12618@a1.tnic> <4B6FDAED.9060204@zytor.com> <20100208095945.GA14740@a1.tnic> <20100211172424.GB19779@aftab> <4B743F7D.3090605@zytor.com> <20100212170649.GC3114@aftab>
In-Reply-To: <20100212170649.GC3114@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 09:06 AM, Borislav Petkov wrote:
> On Thu, Feb 11, 2010 at 09:33:49AM -0800, H. Peter Anvin wrote:
>> You don't do the push/pop inline -- if you're going to take the hit of
>> pushing this into the caller, it's better to list them as explicit
>> clobbers and let the compiler figure out how to do it.  The point of
>> doing an explicit push/pop is that it can be pushed into the out-of-line
>> subroutine.
> 
> Doh! Of course, this was wrong. See below.
> 
> diff --git a/arch/x86/lib/hweight.c b/arch/x86/lib/hweight.c
> new file mode 100644
> index 0000000..9b4bfa5
> --- /dev/null
> +++ b/arch/x86/lib/hweight.c
> @@ -0,0 +1,72 @@
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/bitops.h>
> +
> +#ifdef CONFIG_64BIT
> +/* popcnt %rdi, %rax */
> +#define POPCNT ".byte 0xf3\n\t.byte 0x48\n\t.byte 0x0f\n\t.byte 0xb8\n\t.byte 0xc7"
> +#define REG_IN "D"
> +#define REG_OUT "a"
> +#else
> +/* popcnt %eax, %eax */
> +#define POPCNT ".byte 0xf3\n\t.byte 0x0f\n\t.byte 0xb8\n\t.byte 0xc0"
> +#define REG_IN "a"
> +#define REG_OUT "a"
> +#endif
> +
> +/*
> + * Those are called out-of-line in the alternative below and are added here only
> + * so that gcc is able to figure out which registers have been clobbered by
> + * __sw_hweightXX so that it could restore their values before returning from
> + * the __arch_hweightXX versions. See also <arch/x86/lib/Makefile>.
> + */
> +unsigned int _sw_hweight32(unsigned int w)
> +{
> +	return __sw_hweight32(w);
> +}
> +
> +unsigned long _sw_hweight64(__u64 w)
> +{
> +	return __sw_hweight64(w);
> +}
> +
> +unsigned int __arch_hweight32(unsigned int w)
> +{
> +	unsigned int res = 0;
> +
> +	asm (ALTERNATIVE("call _sw_hweight32", POPCNT, X86_FEATURE_POPCNT)
> +		     : "="REG_OUT (res)
> +		     : REG_IN (w));
> +

Now you have no clobbers and no assembly wrapper.  That really doesn't work.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

