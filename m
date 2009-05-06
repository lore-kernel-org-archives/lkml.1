Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbZEFI3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbZEFI3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbZEFI3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:29:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62468 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbZEFI3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:29:31 -0400
Message-ID: <4A014A9D.8000903@cn.fujitsu.com>
Date: Wed, 06 May 2009 16:30:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: printk %0*X is broken.
References: <4A0136F4.4010504@kernel.org> <20090506071839.GA14412@elte.hu>
In-Reply-To: <20090506071839.GA14412@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Cc:-ed more folks who modified lib/vsprintf.c recently.
> 
> 	Ingo
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> it seems someone broke 
>>
>> printk(   "%0*X\n", width, x);
>>
>> looks like 0 is dumped.
>>
>> YH
>>
>> [    0.000000] MTRR variable ranges enabled:
>> [    0.000000]   0 base 0   00000000 mask FF0 00000000 write-back
>> [    0.000000]   1 base 10  00000000 mask FFF 80000000 write-back
>> [    0.000000]   2 base 0   80000000 mask FFF 80000000 uncachable
>> [    0.000000]   3 base 0   7F800000 mask FFF FF800000 uncachable
>>

2.6.30-rc4-tip, the output of my box:

high_width: 1
MTRR variable ranges enabled:
  0 base 000000000 mask FC0000000 write-back
  1 base 03C000000 mask FFC000000 uncachable
  2 base 0D0000000 mask FF8000000 write-combining

Is it possible that high_width is negative in your output?
If high_width == -3, we can get exactly the same output with yours.

>>
>> code:
>>         for (i = 0; i < num_var_ranges; ++i) {
>>                 if (mtrr_state.var_ranges[i].mask_lo & (1 << 11))
>>                         printk(KERN_DEBUG "  %u base %0*X%05X000 mask %0*X%05X000 %s\n",
>>                                i,
>>                                high_width,
>>                                mtrr_state.var_ranges[i].base_hi,
>>                                mtrr_state.var_ranges[i].base_lo >> 12,
>>                                high_width,
>>                                mtrr_state.var_ranges[i].mask_hi,
>>                                mtrr_state.var_ranges[i].mask_lo >> 12,
>>                                mtrr_attrib_to_str(mtrr_state.var_ranges[i].base_lo & 0xff));
>>                 else
>>                         printk(KERN_DEBUG "  %u disabled\n", i);
>>         }
>>
> 
> 
