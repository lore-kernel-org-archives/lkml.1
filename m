Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZHCTwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZHCTwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbZHCTwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:52:45 -0400
Received: from mail-ew0-f227.google.com ([209.85.219.227]:45843 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbZHCTwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:52:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Nxr+YvOO1LnEUpba6MsprEUJaeyaUp1BVeawDz5ch2JEuhoBqIIf+HURU/U2MpFyaX
         9foU6MQ4HI+ukYSAMPGhQez/+QuBM9mwMveOZuBqTHYvhbi1El79wZCC4POo4mYNgsis
         vudY6LqOd8fmNQKTHL7m7aF2wVEVylJqSpfzk=
Message-ID: <4A773FFF.7050106@gmail.com>
Date: Mon, 03 Aug 2009 20:52:31 +0100
From: Dave <kilroyd@googlemail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090328)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] locking: Check spinlock_t/rwlock_t argument
 type on non-SMP builds too
References: <1249238465-4929-1-git-send-email-kilroyd@googlemail.com> <tip-8d19bd347e1073e7f1ef9f8057c560a5f6be63d7@git.kernel.org> <20090803113929.GA25828@elte.hu>
In-Reply-To: <20090803113929.GA25828@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * tip-bot for David Kilroy <kilroyd@googlemail.com> wrote:
> 
>> Commit-ID:  8d19bd347e1073e7f1ef9f8057c560a5f6be63d7
>> Gitweb:     http://git.kernel.org/tip/8d19bd347e1073e7f1ef9f8057c560a5f6be63d7
>> Author:     David Kilroy <kilroyd@googlemail.com>
>> AuthorDate: Sun, 2 Aug 2009 19:41:05 +0100
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Sun, 2 Aug 2009 21:29:07 +0200
>>
>> locking: Check spinlock_t/rwlock_t argument type on non-SMP builds too
>>
>> When writing code for UP without CONFIG_DEBUG_SPINLOCK it's
>> easy to get the first argument to the spinlock/rwlock functions
>> wrong. This is because the parameter is not actually used in
>> this configuration.
>>
>> Typically you will only find out it's wrong:
>>
>>  * by rebuilding with CONFIG_SMP or CONFIG_DEBUG_SPINLOCK
>>  * after you've submitted your beautiful patch series
>>
>> The first means a long wait, and the latter is a bit late.
>>
>> Change the intermediate macros into inline functions.
>>
>> -v2: Use C inlines instead of in-macro type-checks
>> -v3: Correct bug in _spin_trylock_bh
> 
> x86 works fine now - but this patch broke architecture builds, such 
> as the build on Alpha:
> 
> In file included from 
> /home/mingo/tip/arch/alpha/kernel/sys_sable.c:25:
> /home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 
> 't2_readb':
> /home/mingo/tip/arch/alpha/include/asm/core_t2.h:451: error: 
> '_spin_lock_irqsave' is static but used in inline function 
> 't2_readb' which is not static

I tried a couple things (see below), but don't see a nice simple way
forward. One option I didn't investigate is copying what SMP does.

I'm inclined to recommend v1 of the patch.


Regards,

Dave.
---
Switching to extern inline on x86 leads to:

/usr/src/linux-current/wireless-testing/include/linux/spinlock_api_up.h:
In function '_spin_lock_irq':
/usr/src/linux-current/wireless-testing/include/linux/spinlock_api_up.h:73:
warning: 'raw_local_irq_disable' is static but used in inline function
'_spin_lock_irq' which is not static
...
/usr/src/linux-current/wireless-testing/include/linux/spinlock_api_up.h:139:
warning: 'current_thread_info' is static but used in inline function
'_write_unlock_irqrestore' which is not static

Looks like one for each of the functions. Seems to link OK.

-> cascade the extern inline into raw versions of functions? on all archs?

---
Plain old inline (and __attribute__((gnu_inline)) ) on x86 leads to:

  LD      init/mounts.o
init/do_mounts_rd.o: In function `_write_unlock_irqrestore':
do_mounts_rd.c:(.text+0x0): multiple definition of
`_write_unlock_irqrestore'
init/do_mounts.o:do_mounts.c:(.text+0x1b5): first defined here
...
init/do_mounts_initrd.o: In function `_spin_lock':
do_mounts_initrd.c:(.text+0x298): multiple definition of `_spin_lock'
init/do_mounts.o:do_mounts.c:(.text+0x44d): first defined here
make[2]: *** [init/mounts.o] Error 1
make[1]: *** [init] Error 2
make: *** [sub-make] Error 2

-> clever linker solution?

---
The statistics (2.6.31-rc4ish) show a strong preference for static inline:

$ find include -name "*.h" | xargs grep "static inline" | wc -l
6461

$ find include -name "*.h" | xargs grep "extern inline" | wc -l
2

$ find arch -name "*.h" | xargs grep "extern inline" | wc -l
125

$ find arch -name "*.h" | xargs grep "static inline" | wc -l
7058

$ find arch -name "*.h" | xargs grep "extern inline" | sed
"s?^\(.*\):.*\$?\1?" | sort | uniq
arch/alpha/include/asm/core_apecs.h
arch/alpha/include/asm/core_cia.h
arch/alpha/include/asm/core_irongate.h
arch/alpha/include/asm/core_lca.h
arch/alpha/include/asm/core_marvel.h
arch/alpha/include/asm/core_mcpcia.h
arch/alpha/include/asm/core_polaris.h
arch/alpha/include/asm/core_t2.h
arch/alpha/include/asm/core_titan.h
arch/alpha/include/asm/core_tsunami.h
arch/alpha/include/asm/core_wildfire.h
arch/alpha/include/asm/io.h
arch/alpha/include/asm/jensen.h
arch/alpha/include/asm/mmu_context.h
arch/alpha/include/asm/pci.h
arch/alpha/include/asm/pgtable.h
arch/alpha/include/asm/processor.h
arch/alpha/include/asm/system.h
arch/alpha/include/asm/tlbflush.h
arch/alpha/include/asm/uaccess.h
arch/blackfin/include/asm/string.h
arch/m68k/include/asm/sbus.h
arch/microblaze/include/asm/cacheflush.h
arch/microblaze/include/asm/delay.h
arch/microblaze/include/asm/pgalloc.h
arch/microblaze/include/asm/processor.h
