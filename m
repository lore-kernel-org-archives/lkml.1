Return-Path: <linux-kernel-owner+w=401wt.eu-S1751789AbZHHQPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbZHHQPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 12:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZHHQPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 12:15:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46229 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbZHHQPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 12:15:24 -0400
Date: Sat, 8 Aug 2009 18:15:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <petkovbb@googlemail.com>,
       Kevin Winchester <kjwinchester@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>, borislav.petkov@amd.com
Subject: Re: [PATCH] x86: clear incorrectly forced X86_FEATURE_LAHF_LM flag
Message-ID: <20090808161507.GA13493@elte.hu>
References: <4A7D673A.1090401@gmail.com> <20090808152016.GB25374@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090808152016.GB25374@liondog.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <petkovbb@googlemail.com> wrote:

> By the way, what does /proc/cpuinfo say on your machine?

below is the separate bugreport email, with cpuinfo included.

	Ingo

----- Forwarded message from Kevin Winchester <kjwinchester@gmail.com> -----

Date: Thu, 06 Aug 2009 13:50:46 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: X86_FEATURE_LAHF_LM set incorrectly (likely due to BIOS bug)
CC: LKML <linux-kernel@vger.kernel.org>


Hi,

I have an AMD Athlon64 processor:

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 4
model name	: AMD Athlon(tm) 64 Processor 2800+
stepping	: 10
cpu MHz		: 1800.000
cache size	: 512 KB
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext lm 3dnowext 3dnow rep_good lahf_lm
bogomips	: 3600.25
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

As you can see, the lahf_lm feature is reported as being present,
but the lahf/sahf instructions are not actually supported by this
processor.  A simple program:

int main() {
	asm("lahf");
}


results in:

$ ./a.out
Illegal instruction

I think the problem is with my BIOS, because, in the following guide
from AMD:

http://support.amd.com/us/Processor_TechDocs/25759.pdf

Erratum 110 indicates that some CPUs will not report the LAHF
capability, even if they have it, and the BIOS should write to a
specific MSR bit in order to get the feature reported as present (for
processors that support LAHF).  I believe that perhaps my BIOS is
writing to that bit unconditionally, and this causes my CPU to report
support for the feature.

If I am correct, would it be appropriate to add a check somewhere in
the CPU feature code to detect early Athlon 64 processors like mine
and clear that feature flag, in case other BIOSes have made the same
mistake?  If so, is there some kind of quirk mechanism for this, or
should I prepare a patch that adds the check directly to the feature
checking code?

Thanks,

-- 
Kevin Winchester

----- End forwarded message -----
