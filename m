Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYHHUg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYHHUg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYHHUgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:36:20 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:37369 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYHHUgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:36:19 -0400
Message-ID: <489CAC70.7090809@cs.columbia.edu>
Date: Fri, 08 Aug 2008 16:28:32 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC][PATCH 2/4] checkpoint/restart: x86 support
References: <20080807224033.FFB3A2C1@kernel> <20080807224035.E56663BF@kernel> <200808081409.30591.arnd@arndb.de>
In-Reply-To: <200808081409.30591.arnd@arndb.de>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the feedback.

The proof-of-concept is written for x86 32 bits, keeping in mind that
we'll need support for 64 bits support. My goal is to leverage feedback
and contributions to have support for 64 bits and other architectures
as well.

Arnd Bergmann wrote:
> 
>> diff -puN /dev/null include/asm-x86/ckpt.h
>> --- /dev/null	2007-04-11 11:48:27.000000000 -0700
>> +++ linux-2.6.git-dave/include/asm-x86/ckpt.h	2008-08-04 13:29:59.000000000 -0700
>> @@ -0,0 +1,46 @@
> 
>> +
>> +struct cr_hdr_cpu {
>> +        __u64 bx;
>> +        __u64 cx;
>> +        __u64 dx;
>> +        __u64 si;
>> +        __u64 di;
>> +        __u64 bp;
>> +        __u64 ax;
>> +        __u64 ds;
>> +        __u64 es;
>> +        __u64 orig_ax;
>> +        __u64 ip;
>> +        __u64 cs;
>> +        __u64 flags;
>> +        __u64 sp;
>> +        __u64 ss;
>> +        __u64 fs;
>> +        __u64 gs;
>> +
>> +	__u64 debugreg0;
>> +	__u64 debugreg1;
>> +	__u64 debugreg2;
>> +	__u64 debugreg3;
>> +	__u64 debugreg6;
>> +	__u64 debugreg7;
>> +
>> +	__u8 uses_debug;
>> +
>> +	__u8 used_math;
>> +	__u8 has_fxsr;
>> +	union thread_xstate xstate;	/* i387 */
>> +};
> 
> It seems weird that you use __u64 members for the registers, but don't
> include r8..r15 in the list. As a consequence, this structure does not
> seem well suited for either x86-32 or x86-64.

In the context of CR, x86-32 and x86-64 are distinct architectures because
you cannot always migrate from one to the other (though 32->64 is sometimes
possible). Therefore, each architecture can have a separate checkpoint file
format (eg r8..r15 only for x86-64).

The information about the kernel configuration, version and cpu settings
will appear on the header; so the restart code will know the architecture
on which the checkpoint had been taken.

So if we want to restart a task checkpointed on x86-32 on a x86-64 machine
(in 32 bit mode), the code will know to not expect that data (r8..r15).

Except for this special case (32 bit running 64 bit), simple conversion can
be done in the kernel if needed, but most conversion between kernel the
format for different kernel versions (should it change) can be done in
user space (eg. with a filter).

> 
> I would suggest either using struct pt_regs by reference, or defining
> it so that you can use the same structure for both 32 and 64 bit x86.

We prefer not to use the kernel structure directly, but an intermediate
structure that can help mitigate subtle incompatibilities issues (between
kernel configurations, versions, and even compiler versions).

Anyway, either a single structure for both 32 and 64 bit x86, or separate
"struct cr_hdr_cpu{_32,_64}", one for each architecture.

Oren.

