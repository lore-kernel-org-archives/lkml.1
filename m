Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbYL0RQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbYL0RQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 12:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYL0RQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 12:16:31 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:45899 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbYL0RQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 12:16:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tOiIxGQgLmcwqxHPAdsa3FE1NxInb2gn00vFn+c+cEZ0xGbqIGa7utr+pvF8yt7VvW
         F4TSh4U1KqDih31/XcSIsGQdfYJH6nR48hcsP4nBFcwaBs82DU3Gc6jPm/Q4FbXUrObp
         wd5PJ0npFFuYgqB28QWPb0jXJ57z/atz6MQOc=
Message-ID: <73c1f2160812270916i1f43cbeave955a434b17491fb@mail.gmail.com>
Date: Sat, 27 Dec 2008 12:16:29 -0500
From: "Brian Gerst" <brgerst@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/3] x86-64: Convert the PDA to percpu.
Cc: "Christoph Lameter" <cl@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081227155339.GA17851@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230052506-5041-1-git-send-email-brgerst@gmail.com>
	 <20081227104123.GH14639@elte.hu>
	 <73c1f2160812270730w249eabb4labaa4fa3bc6a6ddd@mail.gmail.com>
	 <20081227155339.GA17851@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 10:53 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Brian Gerst <brgerst@gmail.com> wrote:
>
>> On Sat, Dec 27, 2008 at 5:41 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > (Cc:-ed a few more people who might be interested in this)
>> >
>> > * Brian Gerst <brgerst@gmail.com> wrote:
>> >
>> >> This patch makes the PDA a normal per-cpu variable, allowing the
>> >> removal of the special allocator code.  %gs still points to the
>> >> base of the PDA.
>> >>
>> >> Tested on a dual-core AMD64 system.
>> >>
>> >> Signed-off-by: Brian Gerst <brgerst@gmail.com>
>> >> ---
>> >>  arch/x86/include/asm/pda.h     |    3 --
>> >>  arch/x86/include/asm/percpu.h  |    3 --
>> >>  arch/x86/include/asm/setup.h   |    1 -
>> >>  arch/x86/kernel/cpu/common.c   |    6 ++--
>> >>  arch/x86/kernel/dumpstack_64.c |    8 ++--
>> >>  arch/x86/kernel/head64.c       |   23 +------------
>> >>  arch/x86/kernel/irq.c          |    2 +-
>> >>  arch/x86/kernel/nmi.c          |    2 +-
>> >>  arch/x86/kernel/setup_percpu.c |   70 ++++++++--------------------------------
>> >>  arch/x86/kernel/smpboot.c      |   58 +--------------------------------
>> >>  arch/x86/xen/enlighten.c       |    2 +-
>> >>  arch/x86/xen/smp.c             |   12 +------
>> >>  12 files changed, 27 insertions(+), 163 deletions(-)
>> >
>> > the simplification factor is significant. I'm wondering, have you measured
>> > the code size impact of this on say the defconfig x86 kernel? That will
>> > generally tell us how much worse optimizations the compiler does under
>> > this scheme.
>> >
>> >        Ingo
>> >
>>
>> Patch #1 by itself doesn't change how the PDA is accessed, only how it
>> is allocated.  The text size goes down significantly with patch #1,
>> but data goes up.  Changing the PDA to cacheline-aligned (1a) brings
>> it back in line.
>>
>>    text          data     bss     dec     hex filename
>> 7033648       1754476  758508 9546632  91ab88 vmlinux.0   (vanilla 2.6.28)
>> 7029563       1758428  758508 9546499  91ab03 vmlinux.1   (with patch #1)
>> 7029563       1754460  758508 9542531  919b83 vmlinux.1a  (with patch #1 cache align)
>> 7036694       1758428  758508 9553630  91c6de vmlinux.3   (with all three patches)
>>
>> I think the first patch (with the alignment fix) is a clear win.  As for
>> the other patches, they add about 8 bytes per use of a PDA variable.
>> cpu_number is used 903 times in this compile, so this is likely the most
>> extreme example.  I have an idea to optimize this particular case
>> further that I'd like to look at which would lessen the impact.
>
> curious, what idea is that?
>
>        Ingo
>

Something like this:
+#define raw_smp_processor_id()                                         \
+({                                                                     \
+       extern int gsoff__cpu_number;                                   \
+       int cpu;                                                        \
+       __asm__("movl %%gs:%1, %0" : "=r" (cpu)                         \
+                                  : "m" (gsoff__cpu_number);           \
+       cpu;                                                            \
+})

And add this to vmlinux_64.lds.S:
+#define GSOFF(x) gsoff__##x = per_cpu__##x - per_cpu__pda
+  GSOFF(cpu_number);

The trick is that the linker can calculate against multiple symbols,
but it must be done in the final link.  The problem with this approach
is that only a limited set of symbols can be used.  There isn't a
simple solution for all per-cpu variables.  Some post-processing would
have to be done, similar to kallsyms.

Looking some more at the usage statistics of the PDA members, there
are four heavy hitters:
pda->pcurrent (2719)
pda->kernelstack (1055)
pda->cpunumber (933)
pda->data_offset (327)

The rest of the PDA members have an insignificant number of accesses.
I think for now I'll avoid converting the above four fields until an
optimal solution can be agreed on, but the others (primarily the TLB
and irqstat fields) can be converted without bloating the kernel code
alot.

--
Brian Gerst
