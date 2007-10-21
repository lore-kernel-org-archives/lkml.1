Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbXJUKZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbXJUKZm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 06:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbXJUKZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 06:25:35 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:12759 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbXJUKZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 06:25:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=GXdfFJkZskGUBf5NEdRO3FQs3fife++X6foGyLAepS+g9ZXzicoJJheglaUrpc9T0qpLQBlwNaw/tpjClni3pp01vwAzsZE1jnNSfHJvZ5L6fjzZSHTwMe/cL2FLo72hlLx/ENpdpjuUZvi05SFI4ylEW3jtAuQlkUOKFxoXOl0=
Message-ID: <471B2918.5090502@googlemail.com>
Date: Sun, 21 Oct 2007 12:25:28 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gabriel C <crazy@pimpmylinux.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: some kernel headers broken in current git ?
References: <4719174A.7020004@googlemail.com> <471AD5AD.9030000@zytor.com>
In-Reply-To: <471AD5AD.9030000@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Gabriel C wrote:
>> Hi,
>>
>> usually I'll wait for rc1 and test compile external module to see which are broken and what need fixing
>> but while I need virtualbox for some tests I test compile it on current git and it failed badly.
>>
>> Maybe something is missing from x86 merge ?
>>
>> Here is what I get :
>>
>> ...
>>
>> /linux/memobj-r0drv-linux.c
>> In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/atomic_32.h:265,
>>                  from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/atomic.h:2,
>>                  from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/spinlock_32.h:4,
>>                  from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/spinlock.h:2,
>>                  from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/spinlock.h:87,
>>                  from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:53,
>>                  from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
>> /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:23: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'atomic_long_t'
> 
> I have been unable to make heads or tails of the maze of twisty 
> dependencies that VirtualBox wants, but the fact that it gets to line 23 
> of <asm-generic/atomic.h> means it has gotten past:
> 
>      21  #if BITS_PER_LONG == 64
>      22
>      23  typedef atomic64_t atomic_long_t;
> 
> BITS_PER_LONG was originally set in <asm/types.h>:
> 
>      39  #ifdef CONFIG_X86_32
>      40  # define BITS_PER_LONG 32
>      41  #else
>      42  # define BITS_PER_LONG 64
>      43  #endif

User land does not know anything about 'CONFIG_X86_32' right ?

I just changed some things manually to test , s/CONFIG_X86_32/__i386__/ in asm/types.h and worked fine 
but subarch headers are still not included probably for the same reason. ( manually changed to test as well )

After doing so , the part filed compiled.

but next error a bit later :

..


In file included from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/include/iprt/string.h:25,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/assert.cpp:24:
/lib/modules/2.6.23-rc0/build/include/linux/string.h:70: error: declaration of C function '__kernel_size_t strlen(const char*)' conflicts with
/lib/modules/2.6.23-rc0/build/include/asm/string_64.h:53: error: previous declaration 'size_t strlen(const char*)' here
/lib/modules/2.6.23-rc0/build/include/linux/string.h:101: error: declaration of C function 'int memcmp(const void*, const void*, __kernel_size_t)' conflicts with
/lib/modules/2.6.23-rc0/build/include/asm/string_64.h:52: error: previous declaration 'int memcmp(const void*, const void*, size_t)' here

..

And again both 32/64 things are defined at the same time.


> 
> The most obvious reason for failure is that the symbol CONFIG_X86_32 
> isn't being defined where expected.  From that point on everything goes 
> to hell.

Yes you are right but as I said above I don't think user land understands CONFIG_X86_32.

> 
> Have you done "make oldconfig && make prepare" in your kernel tree since 
> you last updated it?

Yes I always do that.

> 
> 	-hpa
> 
> 

Gabriel
